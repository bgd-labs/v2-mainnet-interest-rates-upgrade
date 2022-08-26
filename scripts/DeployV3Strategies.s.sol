// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {InterestRatesStrategyFactory} from '../src/contracts/InterestRatesStrategyFactory.sol';
import {InterestRatesStrategyConfigs} from '../src/contracts/InterestRatesStrategyConfigs.sol';

contract Deploy is Script {
  function run() external {
    vm.startBroadcast();
    InterestRatesStrategyFactory factory = new InterestRatesStrategyFactory();

    InterestRatesStrategyConfigs.StrategyConfig[]
      memory strategyConfigs = InterestRatesStrategyConfigs.getConfigs();

    uint256 length = strategyConfigs.length;
    uint256 start;
    uint256 end;
    uint256 pageSize = 6;

    if (length != 0) {
      do {
        end += pageSize;
        if (end > length) end = length;

        InterestRatesStrategyFactory.StrategyParams[]
          memory paramsSlice = new InterestRatesStrategyFactory.StrategyParams[](
            end - start
          );

        for (uint256 i = 0; i < paramsSlice.length; i++) {
          paramsSlice[i] = strategyConfigs[start + i].params;
        }

        factory.createDeterministic(paramsSlice);
        start = end;
      } while (end < length);
    }
    vm.stopBroadcast();
  }
}
