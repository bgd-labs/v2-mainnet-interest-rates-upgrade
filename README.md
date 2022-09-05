# Aave Mainnet Market v2 -> v3 phase 1

## Context

One of the v2 -> v3 migration breaking changes is a new `DefaultReserveInterestRateStrategy`,
in the same time, this is a very isolated change that requires minimal v2 `LendingPool` update
and a lot of gas to deploy. That's why BGD labs decided to separate it into
the independent phase. But it has some problems described below

## Problem
 * to be able to use v3 `DefaultReserveInterestRateStrategy` we should upgrade `LendingPool` contract to
solidity 0.8.0 to have support structs as [parameters of external functions](https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol#L194),
which is quite a big change and requires an audit.
 * in the same time `v3 DefaultReserveInterestRateStrategy` is not compatible with `v2 DefaultReserveInterestRateStrategy`
interface, what will break existing integrations

## Solution
 * develop extended `v3 DefaultReserveInterestRateStrategy` which will be compatible with both [v2 and v3 interfaces](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/src/contracts/ExtendedV3ReserveInterestRateStrategy.sol)
 * upgrade v2 LendingPool implementation with [the latest commit of the protocol-v2 master branch](https://github.com/aave/protocol-v2/blob/master/contracts/protocol/libraries/logic/ReserveLogic.sol#L223),
which currently in production on the Aave v2 Polygon market, to make it compatible with the
`ExtendedV3DefaultReserveInterestRateStrategy` list of parameters
 * remove `aToken.handleRepay()` call from the [latest commit of the protocol-v2 master branch](https://github.com/aave/protocol-v2/blob/master/contracts/protocol/lendingpool/LendingPool.sol#L285),
because deployed aTokens don't have this method implemented. We can do it because this method
currently not used on the [v2 codebase](https://github.com/aave/protocol-v2/blob/master/contracts/protocol/tokenization/AToken.sol#L323).
Here is: [Corresponding PR](https://github.com/bgd-labs/protocol-v2/pull/6)
 * develop [the payload](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/src/contracts/Phase1Payload.sol)
which will execute required operations
## Preparations
 * download [all configuration params](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/src/contracts/InterestRatesStrategyConfigs.sol)
from all deployed `v2 DefaultInterestRatesStrategies`
 * check the code diff between them to be sure that there are not custom implementations of
`v2 DefaultInterestRatesStrategies` deployed

## Testing approach
 * [checking](https://github.com/bgd-labs/v2-mainnet-interest-rates-upgrade/blob/main/tests/InterestRatesStrategiesParamsTest.t.sol)
that all common params on upcoming v3 strategies are identical to the deployed v2 params
