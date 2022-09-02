// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DefaultReserveInterestRateStrategy, PercentageMath, WadRayMath, DataTypes, IPoolAddressesProvider} from '../../lib/aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol';
import {IV2ReserveInterestRatesStrategy} from './IV2ReserveInterestRatesStrategy.sol';

contract V2V3ReserveInterestRateStrategy is
  DefaultReserveInterestRateStrategy,
  IV2ReserveInterestRatesStrategy
{
  using WadRayMath for uint256;
  using PercentageMath for uint256;

  constructor(
    IPoolAddressesProvider provider,
    uint256 inpOptimalUsageRatio,
    uint256 inpBaseVariableBorrowRate,
    uint256 inpVariableRateSlope1,
    uint256 inpVariableRateSlope2,
    uint256 inpStableRateSlope1,
    uint256 inpStableRateSlope2,
    uint256 inpBaseStableRateOffset,
    uint256 inpStableRateExcessOffset,
    uint256 inpOptimalStableToTotalDebtRatio
  )
    DefaultReserveInterestRateStrategy(
      provider,
      inpOptimalUsageRatio,
      inpBaseVariableBorrowRate,
      inpVariableRateSlope1,
      inpVariableRateSlope2,
      inpStableRateSlope1,
      inpStableRateSlope2,
      inpBaseStableRateOffset,
      inpStableRateExcessOffset,
      inpOptimalStableToTotalDebtRatio
    )
  {}

  function OPTIMAL_UTILIZATION_RATE() external view returns (uint256) {
    return OPTIMAL_USAGE_RATIO;
  }

  function baseVariableBorrowRate() external view returns (uint256) {
    return _baseVariableBorrowRate;
  }

  function variableRateSlope1() external view returns (uint256) {
    return _variableRateSlope1;
  }

  function variableRateSlope2() external view returns (uint256) {
    return _variableRateSlope2;
  }

  function stableRateSlope1() external view returns (uint256) {
    return _stableRateSlope1;
  }

  function stableRateSlope2() external view returns (uint256) {
    return _stableRateSlope2;
  }

  // @dev Legacy method going to be deprecated on v3
  function calculateInterestRates(
    address reserve,
    uint256 availableLiquidity,
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 averageStableBorrowRate,
    uint256 reserveFactor
  )
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 unbacked = 0;
    CalcInterestRatesLocalVars memory vars;

    vars.totalDebt = totalStableDebt + totalVariableDebt;

    vars.currentLiquidityRate = 0;
    vars.currentVariableBorrowRate = _baseVariableBorrowRate;
    vars.currentStableBorrowRate = getBaseStableBorrowRate();

    if (vars.totalDebt != 0) {
      vars.stableToTotalDebtRatio = totalStableDebt.rayDiv(vars.totalDebt);
      vars.availableLiquidityPlusDebt = availableLiquidity + vars.totalDebt;
      vars.borrowUsageRatio = vars.totalDebt.rayDiv(
        vars.availableLiquidityPlusDebt
      );
      vars.supplyUsageRatio = vars.totalDebt.rayDiv(
        vars.availableLiquidityPlusDebt + unbacked
      );
    }

    if (vars.borrowUsageRatio > OPTIMAL_USAGE_RATIO) {
      uint256 excessBorrowUsageRatio = (vars.borrowUsageRatio -
        OPTIMAL_USAGE_RATIO).rayDiv(MAX_EXCESS_USAGE_RATIO);

      vars.currentStableBorrowRate +=
        _stableRateSlope1 +
        _stableRateSlope2.rayMul(excessBorrowUsageRatio);

      vars.currentVariableBorrowRate +=
        _variableRateSlope1 +
        _variableRateSlope2.rayMul(excessBorrowUsageRatio);
    } else {
      vars.currentStableBorrowRate += _stableRateSlope1
        .rayMul(vars.borrowUsageRatio)
        .rayDiv(OPTIMAL_USAGE_RATIO);

      vars.currentVariableBorrowRate += _variableRateSlope1
        .rayMul(vars.borrowUsageRatio)
        .rayDiv(OPTIMAL_USAGE_RATIO);
    }

    if (vars.stableToTotalDebtRatio > OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO) {
      uint256 excessStableDebtRatio = (vars.stableToTotalDebtRatio -
        OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO).rayDiv(
          MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO
        );
      vars.currentStableBorrowRate += _stableRateExcessOffset.rayMul(
        excessStableDebtRatio
      );
    }

    vars.currentLiquidityRate = _getOverallBorrowRate(
      totalStableDebt,
      totalVariableDebt,
      vars.currentVariableBorrowRate,
      averageStableBorrowRate
    ).rayMul(vars.supplyUsageRatio).percentMul(
        PercentageMath.PERCENTAGE_FACTOR - reserveFactor
      );

    return (
      vars.currentLiquidityRate,
      vars.currentStableBorrowRate,
      vars.currentVariableBorrowRate
    );
  }

  // @dev Legacy method going to be deprecated on v3
  function calculateInterestRates(
    address reserve,
    address aToken,
    uint256 liquidityAdded,
    uint256 liquidityTaken,
    uint256 totalStableDebt,
    uint256 totalVariableDebt,
    uint256 averageStableBorrowRate,
    uint256 reserveFactor
  )
    external
    view
    returns (
      uint256 liquidityRate,
      uint256 stableBorrowRate,
      uint256 variableBorrowRate
    )
  {
    return
      calculateInterestRates(
        DataTypes.CalculateInterestRatesParams({
          unbacked: 0,
          liquidityAdded: liquidityAdded,
          liquidityTaken: liquidityTaken,
          totalStableDebt: totalStableDebt,
          totalVariableDebt: totalVariableDebt,
          averageStableBorrowRate: averageStableBorrowRate,
          reserveFactor: reserveFactor,
          reserve: reserve,
          aToken: aToken
        })
      );
  }
}
