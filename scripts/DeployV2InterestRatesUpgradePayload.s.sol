// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {V2InterestRatesUpgradePayload} from '../src/contracts/V2InterestRatesUpgradePayload.sol';

contract Deploy is Script {
  function run() external {
    vm.startBroadcast();
    new V2InterestRatesUpgradePayload();
    vm.stopBroadcast();
  }
}
