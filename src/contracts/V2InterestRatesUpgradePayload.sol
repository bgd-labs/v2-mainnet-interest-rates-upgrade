// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DefaultReserveInterestRateStrategy} from '../../lib/aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol';
import {IPoolAddressesProvider} from '../../lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {IV2InterestRatesUpgradePayload} from '../interfaces/V2InterestRatesUpgradePayload.sol';
import {InterestRatesStrategyConfigs} from './InterestRatesStrategyConfigs.sol';

contract V2InterestRatesUpgradePayload is IV2InterestRatesUpgradePayload {
  constructor() {
    InterestRatesStrategyConfigs.StrategyConfig[]
      memory params = InterestRatesStrategyConfigs.getConfigs();
    for (uint256 i = 0; i < params.length; i++) {
      new DefaultReserveInterestRateStrategy(
        IPoolAddressesProvider(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER)),
        params[i].params.optimalUsageRatio,
        params[i].params.baseVariableBorrowRate,
        params[i].params.variableRateSlope1,
        params[i].params.variableRateSlope2,
        params[i].params.stableRateSlope1,
        params[i].params.stableRateSlope2,
        params[i].params.baseStableRateOffset,
        params[i].params.stableRateExcessOffset,
        params[i].params.optimalStableToTotalDebtRatio
      );
    }
  }
}
