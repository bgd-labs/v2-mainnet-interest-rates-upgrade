# Aave Mainnet Market v2 -> v3 phase 1

## Context

At first glance, v2 -> v3 migration is a very complex process requiring many upgrades, which should
happen atomically and in a very particular order. That leads to significant gas requirements in 1 single transaction.

One of the breaking changes is a new `DefaultReserveInterestRateStrategy` due to
the different list of parameters and modified data fetching flow. At the same time,
this is a very isolated change that requires minimal v2 `LendingPool` update and a lot of gas to deploy.
So after analyzing the whole migration process better, we decided to extract components that don't need
to be atomic (the rates), into the independent phase that we're going to execute before everything else.

This document presents the challenges and solutions found during this Phase 1 of the migration.

## Problems
 * To be able to use v3 `DefaultReserveInterestRateStrategy` we should upgrade `LendingPool` contract to
solidity 0.8.0 to have support structs as [parameters of external functions](https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol#L194),
which is quite a big change and requires an audit.
 * At the same time `v3 DefaultReserveInterestRateStrategy` is not compatible with `v2 DefaultReserveInterestRateStrategy`
interface, what will break existing integrations

## Solutions
 * Develop an extended `v3 DefaultReserveInterestRateStrategy` which will be compatible with both [v2 and v3 interfaces](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/src/contracts/ExtendedV3ReserveInterestRateStrategy.sol)
 * Upgrade v2 LendingPool implementation with [the latest commit of the protocol-v2 master branch](https://github.com/aave/protocol-v2/blob/master/contracts/protocol/libraries/logic/ReserveLogic.sol#L223),
which is currently in production on the Aave v2 Polygon market, to make it compatible with the
`ExtendedV3DefaultReserveInterestRateStrategy` list of parameters
 * Remove `aToken.handleRepay()` call from the [latest commit of the protocol-v2 master branch](https://github.com/aave/protocol-v2/blob/master/contracts/protocol/lendingpool/LendingPool.sol#L285),
because deployed aTokens don't have this method implemented. We can do it because this method
currently not used on the [v2 codebase](https://github.com/aave/protocol-v2/blob/master/contracts/protocol/tokenization/AToken.sol#L323).
Here is: [Corresponding PR](https://github.com/bgd-labs/protocol-v2/pull/6)
 * Develop [the payload](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/src/contracts/Phase1Payload.sol)
which will execute the required operations

## Preparations
 * Download [all configuration params](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/src/contracts/InterestRatesStrategyConfigs.sol)
from all deployed `v2 DefaultInterestRatesStrategies`
 * Check the code diff between them to be sure that there are not custom implementations of
`v2 DefaultInterestRatesStrategies` deployed

## Testing approach
We consider, that v2 `LendingPool` and v3 `DefaultReserveInterestRateStrategy` implementation was already tested
and audited by aave. So, we're focusing out attention on the following:
 * [Checking](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/tests/InterestRatesStrategiesParamsTest.t.sol)
that all common params on upcoming v3 strategies are identical to the deployed v2 params
