// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPhase1Payload {
  struct StrategyUpdateInput {
    address reserve;
    address strategy;
  }
}
