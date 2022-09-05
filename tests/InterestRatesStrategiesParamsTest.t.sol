// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';
import {ILendingRateOracle} from '../lib/next-protocol-v2/contracts/interfaces/ILendingRateOracle.sol';
import {Ownable} from '../lib/next-protocol-v2/contracts/dependencies/openzeppelin/contracts/Ownable.sol';

import {IV2ReserveInterestRatesStrategy} from '../src/interfaces/IV2ReserveInterestRatesStrategy.sol';
import {InterestRatesStrategyConfigs} from '../src/contracts/InterestRatesStrategyConfigs.sol';
import {ExtendedV3ReserveInterestRateStrategy} from '../src/contracts/ExtendedV3ReserveInterestRateStrategy.sol';

import {Phase1Payload, IProposalGenericExecutor} from '../src/contracts/Phase1Payload.sol';

contract InterestRatesStrategiesParamsTest is Test {
  function setUp() public {}

  function testThatWeHaveAllReserves() public {
    address[] memory reserves = AaveV2Ethereum.POOL.getReservesList();
    InterestRatesStrategyConfigs.StrategyConfig[]
      memory params = InterestRatesStrategyConfigs.getConfigs();

    for (uint256 i = 0; i < params.length; i++) {
      for (uint256 j = 0; j < params[i].assets.length; j++) {
        for (uint256 k = 0; k < reserves.length; k++) {
          if (reserves[k] == params[i].assets[j]) {
            delete reserves[k];
            break;
          }
        }
      }
    }
    for (uint256 k = 0; k < reserves.length; k++) {
      assertEq(reserves[k], address(0), 'reserve missing in params');
    }
  }

  function testThatBaseParamsAreTheSameAsCurrentV2() public {
    InterestRatesStrategyConfigs.StrategyConfig[]
      memory configs = InterestRatesStrategyConfigs.getConfigs();
    ILendingRateOracle lendingRateOracle = ILendingRateOracle(
      AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.getLendingRateOracle()
    );
    for (uint256 i = 0; i < configs.length; i++) {
      for (uint256 j = 0; j < configs[i].assets.length; j++) {
        address asset = configs[i].assets[j];
        DataTypes.ReserveData memory reserveData = AaveV2Ethereum
          .POOL
          .getReserveData(asset);
        IV2ReserveInterestRatesStrategy strategy = IV2ReserveInterestRatesStrategy(
            reserveData.interestRateStrategyAddress
          );
        assertEq(
          configs[i].params.optimalUsageRatio,
          strategy.OPTIMAL_UTILIZATION_RATE(),
          'wrong optimalUsageRatio'
        );
        assertEq(
          configs[i].params.baseVariableBorrowRate,
          strategy.baseVariableBorrowRate(),
          'wrong baseVariableBorrowRate'
        );
        assertEq(
          configs[i].params.variableRateSlope1,
          strategy.variableRateSlope1(),
          'wrong variableRateSlope1'
        );
        assertEq(
          configs[i].params.variableRateSlope2,
          strategy.variableRateSlope2(),
          'wrong variableRateSlope2'
        );
        assertEq(
          configs[i].params.stableRateSlope1,
          strategy.stableRateSlope1(),
          'wrong stableRateSlope1'
        );
        assertEq(
          configs[i].params.stableRateSlope2,
          strategy.stableRateSlope2(),
          'wrong stableRateSlope2'
        );

        assertGe(
          configs[i].params.variableRateSlope1 +
            configs[i].params.baseStableRateOffset,
          lendingRateOracle.getMarketBorrowRate(asset),
          'base stable rate is too low'
        );
      }
    }
  }

  function testThatV3StrategiesAreTheSameAsParams() public {
    IProposalGenericExecutor payload = new Phase1Payload();

    // @dev transfer permissions to the payload
    vm.startPrank(address(AaveGovernanceV2.SHORT_EXECUTOR));
    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setPoolAdmin(address(payload));
    Ownable(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER)).transferOwnership(
      address(payload)
    );
    vm.stopPrank();

    payload.execute();

    InterestRatesStrategyConfigs.StrategyConfig[]
      memory configs = InterestRatesStrategyConfigs.getConfigs();
    for (uint256 i = 0; i < configs.length; i++) {
      for (uint256 j = 0; j < configs[i].assets.length; j++) {
        DataTypes.ReserveData memory reserveData = AaveV2Ethereum
          .POOL
          .getReserveData(configs[i].assets[j]);
        ExtendedV3ReserveInterestRateStrategy strategy = ExtendedV3ReserveInterestRateStrategy(
            reserveData.interestRateStrategyAddress
          );

        assertEq(
          address(strategy),
          configs[i].deployedStrategyAddress,
          'strategy address wrongly set on the reserve'
        );

        assertEq(
          configs[i].params.optimalUsageRatio,
          strategy.OPTIMAL_UTILIZATION_RATE(),
          'wrong OPTIMAL_UTILIZATION_RATE'
        );
        assertEq(
          configs[i].params.optimalUsageRatio,
          strategy.OPTIMAL_USAGE_RATIO(),
          'wrong OPTIMAL_USAGE_RATIO'
        );
        assertEq(
          configs[i].params.baseVariableBorrowRate,
          strategy.baseVariableBorrowRate(),
          'wrong baseVariableBorrowRate'
        );
        assertEq(
          configs[i].params.baseVariableBorrowRate,
          strategy.getBaseVariableBorrowRate(),
          'wrong getBaseVariableBorrowRate'
        );
        assertEq(
          configs[i].params.variableRateSlope1,
          strategy.variableRateSlope1(),
          'wrong variableRateSlope1'
        );
        assertEq(
          configs[i].params.variableRateSlope1,
          strategy.getVariableRateSlope1(),
          'wrong getVariableRateSlope1'
        );
        assertEq(
          configs[i].params.variableRateSlope2,
          strategy.variableRateSlope2(),
          'wrong variableRateSlope2'
        );
        assertEq(
          configs[i].params.variableRateSlope2,
          strategy.getVariableRateSlope2(),
          'wrong getVariableRateSlope2'
        );
        assertEq(
          configs[i].params.stableRateSlope1,
          strategy.stableRateSlope1(),
          'wrong stableRateSlope1'
        );
        assertEq(
          configs[i].params.stableRateSlope1,
          strategy.getStableRateSlope1(),
          'wrong getStableRateSlope1'
        );
        assertEq(
          configs[i].params.stableRateSlope2,
          strategy.stableRateSlope2(),
          'wrong stableRateSlope2'
        );
        assertEq(
          configs[i].params.stableRateSlope2,
          strategy.getStableRateSlope2(),
          'wrong getStableRateSlope2'
        );
        assertEq(
          configs[i].params.stableRateExcessOffset,
          strategy.getStableRateExcessOffset(),
          'wrong getStableRateExcessOffset'
        );
        assertEq(
          configs[i].params.optimalStableToTotalDebtRatio,
          strategy.OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO(),
          'wrong OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO'
        );
      }
    }
  }

  function fuzzCalculateInterestRates() public {}
}
