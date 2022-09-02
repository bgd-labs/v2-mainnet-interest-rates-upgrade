// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IV2ReserveInterestRatesStrategy {
  function OPTIMAL_UTILIZATION_RATE() external view returns (uint256);

  function baseVariableBorrowRate() external view returns (uint256);

  function variableRateSlope1() external view returns (uint256);

  function variableRateSlope2() external view returns (uint256);

  function stableRateSlope1() external view returns (uint256);

  function stableRateSlope2() external view returns (uint256);

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
    );

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
    );
}
