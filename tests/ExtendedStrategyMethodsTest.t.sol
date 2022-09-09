// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test} from 'forge-std/Test.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {DataTypes} from 'aave-address-book/AaveV2.sol';

import '../lib/aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol' as DataTypesV3;

import {ExtendedV3ReserveInterestRateStrategy, DefaultReserveInterestRateStrategy} from '../src/contracts/ExtendedV3ReserveInterestRateStrategy.sol';
import {InterestRatesStrategyConfigs} from '../src/contracts/InterestRatesStrategyConfigs.sol';
import {InterestRatesStrategyFactory} from '../src/contracts/InterestRatesStrategyFactory.sol';

interface IERC20 {
  function balanceOf(address account) external view returns (uint256);
}

contract ExtendedStrategyMethodsTest is Test {
  ExtendedV3ReserveInterestRateStrategy public strategy;
  address public reserve;

  function setUp() external {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15503086);
    InterestRatesStrategyFactory factory = new InterestRatesStrategyFactory();
    InterestRatesStrategyConfigs.StrategyConfig
      memory config = InterestRatesStrategyConfigs.getConfigs()[1];

    InterestRatesStrategyFactory.StrategyParams[]
      memory params = new InterestRatesStrategyFactory.StrategyParams[](1);
    params[0] = config.params;
    address[] memory factoryOutput = factory.createDeterministic(params);
    strategy = ExtendedV3ReserveInterestRateStrategy(factoryOutput[0]);
    reserve = config.assets[0];
  }

  function testOfCalculateInterestRates() external {
    DataTypes.ReserveData memory reserveData = AaveV2Ethereum
      .POOL
      .getReserveData(reserve);
    DataTypesV3.DataTypes.CalculateInterestRatesParams
      memory testParams = DataTypesV3.DataTypes.CalculateInterestRatesParams({
        unbacked: 0,
        liquidityAdded: 1 ether,
        liquidityTaken: 0,
        totalStableDebt: 1 ether,
        totalVariableDebt: 1 ether,
        averageStableBorrowRate: 1 * 1e27,
        reserveFactor: 1000,
        reserve: reserve,
        aToken: reserveData.aTokenAddress
      });

    uint256 availableLiquidity = IERC20(reserve).balanceOf(
      reserveData.aTokenAddress
    ) +
      testParams.liquidityAdded -
      testParams.liquidityTaken;

    uint256[3] memory actualRates;
    uint256[3] memory legacyRates;
    (actualRates[0], actualRates[1], actualRates[2]) = strategy
      .calculateInterestRates(testParams);
    (legacyRates[0], legacyRates[1], legacyRates[2]) = strategy
      .calculateInterestRates(
        testParams.reserve,
        availableLiquidity,
        testParams.totalStableDebt,
        testParams.totalVariableDebt,
        testParams.averageStableBorrowRate,
        testParams.reserveFactor
      );
    assertEq(
      legacyRates[0],
      actualRates[0],
      'wrong liquidityRate on calculateInterestRates v2.0'
    );
    assertEq(
      legacyRates[1],
      actualRates[1],
      'wrong stableBorrowRateLegacy on calculateInterestRates v2.0'
    );
    assertEq(
      legacyRates[2],
      actualRates[2],
      'wrong variableBorrowRateLegacy on calculateInterestRates v2.0'
    );

    (legacyRates[0], legacyRates[1], legacyRates[2]) = strategy
      .calculateInterestRates(
        testParams.reserve,
        testParams.aToken,
        testParams.liquidityAdded,
        testParams.liquidityTaken,
        testParams.totalStableDebt,
        testParams.totalVariableDebt,
        testParams.averageStableBorrowRate,
        testParams.reserveFactor
      );
    assertEq(
      legacyRates[0],
      actualRates[0],
      'wrong liquidityRate on calculateInterestRates v2.1'
    );
    assertEq(
      legacyRates[1],
      actualRates[1],
      'wrong stableBorrowRateLegacy on calculateInterestRates v2.1'
    );
    assertEq(
      legacyRates[2],
      actualRates[2],
      'wrong variableBorrowRateLegacy on calculateInterestRates v2.1'
    );
  }

  function testOfTheMiscMethods() external {
    assertEq(
      strategy.OPTIMAL_UTILIZATION_RATE(),
      strategy.OPTIMAL_USAGE_RATIO(),
      'wrong OPTIMAL_UTILIZATION_RATE'
    );

    assertEq(
      strategy.baseVariableBorrowRate(),
      strategy.getBaseVariableBorrowRate(),
      'wrong baseVariableBorrowRate'
    );
    assertEq(
      strategy.variableRateSlope1(),
      strategy.getVariableRateSlope1(),
      'wrong variableRateSlope1'
    );
    assertEq(
      strategy.variableRateSlope2(),
      strategy.getVariableRateSlope2(),
      'wrong variableRateSlope2'
    );
    assertEq(
      strategy.stableRateSlope1(),
      strategy.getStableRateSlope1(),
      'wrong stableRateSlope1'
    );
    assertEq(
      strategy.stableRateSlope2(),
      strategy.getStableRateSlope2(),
      'wrong stableRateSlope2'
    );
  }
}
