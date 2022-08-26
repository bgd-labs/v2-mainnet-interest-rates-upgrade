// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
//import {console2} from 'forge-std/console2.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';
import {DefaultReserveInterestRateStrategy} from '../lib/protocol-v2/contracts/protocol/lendingpool/DefaultReserveInterestRateStrategy.sol';
import {InterestRatesStrategiesParams} from '../src/contracts/InterestRatesStrategiesParams.sol';

contract InterestRatesStrategiesParamsTest is Test {
  function setUp() public {}

  function testThatWeHaveAllReserves() public {
    address[] memory reserves = AaveV2Ethereum.POOL.getReservesList();
    InterestRatesStrategiesParams.InterestRatesStrategyParams[]
      memory params = InterestRatesStrategiesParams
        .getInterestRatesStrategiesParams();

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
      assertEq(reserves[k], address(0));
    }
  }

  function testThatBaseParamsAreTheSameAsCurrentV2() public {
    InterestRatesStrategiesParams.InterestRatesStrategyParams[]
      memory params = InterestRatesStrategiesParams
        .getInterestRatesStrategiesParams();

    for (uint256 i = 0; i < params.length; i++) {
      for (uint256 j = 0; j < params[i].assets.length; j++) {
        DataTypes.ReserveData memory reserveData = AaveV2Ethereum
          .POOL
          .getReserveData(params[i].assets[j]);
        DefaultReserveInterestRateStrategy strategy = DefaultReserveInterestRateStrategy(
            reserveData.interestRateStrategyAddress
          );
        assertEq(
          params[i].optimalUsageRatio,
          strategy.OPTIMAL_UTILIZATION_RATE()
        );
        assertEq(
          params[i].baseVariableBorrowRate,
          strategy.baseVariableBorrowRate()
        );
        assertEq(params[i].variableRateSlope1, strategy.variableRateSlope1());
        assertEq(params[i].variableRateSlope2, strategy.variableRateSlope2());
        assertEq(params[i].stableRateSlope1, strategy.stableRateSlope1());
        assertEq(params[i].stableRateSlope2, strategy.stableRateSlope2());
      }
    }
  }
}
