// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DefaultReserveInterestRateStrategy} from '../../lib/aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol';
import {IPoolAddressesProvider} from '../../lib/aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {IV2InterestRatesUpgradePayload} from '../interfaces/V2InterestRatesUpgradePayload.sol';
import {InterestRatesStrategiesParams} from './InterestRatesStrategiesParams.sol';

contract V2InterestRatesUpgradePayload is IV2InterestRatesUpgradePayload {
  constructor() {
    InterestRatesStrategiesParams.InterestRatesStrategyParams[]
      memory params = InterestRatesStrategiesParams
        .getInterestRatesStrategiesParams();
    for (uint256 i = 0; i < params.length; i++) {
      new DefaultReserveInterestRateStrategy(
        IPoolAddressesProvider(address(AaveV2Ethereum.POOL_ADDRESSES_PROVIDER)),
        params[i].optimalUsageRatio,
        params[i].baseVariableBorrowRate,
        params[i].variableRateSlope1,
        params[i].variableRateSlope2,
        params[i].stableRateSlope1,
        params[i].stableRateSlope2,
        params[i].baseStableRateOffset,
        params[i].stableRateExcessOffset,
        params[i].optimalStableToTotalDebtRatio
      );
    }
  }
}
