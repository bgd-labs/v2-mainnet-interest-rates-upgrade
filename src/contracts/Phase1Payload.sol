// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AaveV2Ethereum, ILendingPoolAddressesProvider} from 'aave-address-book/AaveV2Ethereum.sol';

import {InterestRatesStrategyConfigs} from './InterestRatesStrategyConfigs.sol';

interface Initializable {
  function initialize(ILendingPoolAddressesProvider provider) external;
}

interface IProposalGenericExecutor {
  function execute() external;
}

contract Phase1Payload is IProposalGenericExecutor {
  address public constant NEW_LENDING_POOL_IMPLEMENTATION = address(0);

  function execute() external {
    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolImpl(
      NEW_LENDING_POOL_IMPLEMENTATION
    );
    require(
      AaveV2Ethereum.POOL.getReservesList().length == 10,
      'NEW_ASSET_ADDED_AND_WILL_BE_BRICKED'
    );
    InterestRatesStrategyConfigs.Strategy[]
      memory strategies = InterestRatesStrategyConfigs.getStrategies();

    // @dev proceed if implementation was already initialized
    try
      Initializable(NEW_LENDING_POOL_IMPLEMENTATION).initialize(
        AaveV2Ethereum.POOL_ADDRESSES_PROVIDER
      )
    {} catch {}

    for (uint256 i = 0; i < strategies.length; i++) {
      for (uint256 j = 0; j < strategies[i].assets.length; j++) {
        AaveV2Ethereum.POOL.setReserveInterestRateStrategyAddress(
          strategies[i].assets[j],
          strategies[i].deployedStrategyAddress
        );
      }
    }
  }
}
