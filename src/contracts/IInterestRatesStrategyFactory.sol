// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IInterestRatesStrategyFactory {
  event ReserveInterestRateStrategyCreated(
    string name,
    uint256 optimalUsageRatio,
    uint256 baseVariableBorrowRate,
    uint256 variableRateSlope1,
    uint256 variableRateSlope2,
    uint256 stableRateSlope1,
    uint256 stableRateSlope2,
    uint256 baseStableRateOffset,
    uint256 stableRateExcessOffset,
    uint256 optimalStableToTotalDebtRatio
  );

  struct StrategyParams {
    string name;
    uint256 optimalUsageRatio;
    uint256 baseVariableBorrowRate;
    uint256 variableRateSlope1;
    uint256 variableRateSlope2;
    uint256 stableRateSlope1;
    uint256 stableRateSlope2;
    uint256 baseStableRateOffset;
    uint256 stableRateExcessOffset;
    uint256 optimalStableToTotalDebtRatio;
  }

  function createDeterministic(StrategyParams[] calldata strategyParams)
    external
    returns (address[] memory);

  function predictCreateDeterministic(StrategyParams memory params)
    external
    view
    returns (address);

  function getDeployedStrategyByName(string calldata name)
    external
    view
    returns (address);
}
