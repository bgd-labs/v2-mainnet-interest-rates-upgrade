// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DefaultReserveInterestRateStrategy, IPoolAddressesProvider} from '../../aave-v3-core/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol';
import {IInterestRatesStrategyFactory} from './IInterestRatesStrategyFactory.sol';

contract InterestRatesStrategyFactory is IInterestRatesStrategyFactory {
  mapping(bytes32 => address) private _deployedStrategies;

  function createDeterministic(StrategyParams[] calldata strategyParams)
    external
    returns (address[] memory)
  {
    address[] memory strategies = new address[](strategyParams.length);
    for (uint256 i = 0; i < strategyParams.length; i++) {
      strategies[i] = address(
        new DefaultReserveInterestRateStrategy{
          salt: _getSaltFromName(strategyParams[i].name)
        }(
          IPoolAddressesProvider(address(0)), // TODO: check
          strategyParams[i].optimalUsageRatio,
          strategyParams[i].baseVariableBorrowRate,
          strategyParams[i].variableRateSlope1,
          strategyParams[i].variableRateSlope2,
          strategyParams[i].stableRateSlope1,
          strategyParams[i].stableRateSlope2,
          strategyParams[i].baseStableRateOffset,
          strategyParams[i].stableRateExcessOffset,
          strategyParams[i].optimalStableToTotalDebtRatio
        )
      );
      _deployedStrategies[
        _getSaltFromName(strategyParams[i].name)
      ] = strategies[i];

      emit ReserveInterestRateStrategyCreated(
        strategyParams[i].name,
        strategyParams[i].optimalUsageRatio,
        strategyParams[i].baseVariableBorrowRate,
        strategyParams[i].variableRateSlope1,
        strategyParams[i].variableRateSlope2,
        strategyParams[i].stableRateSlope1,
        strategyParams[i].stableRateSlope2,
        strategyParams[i].baseStableRateOffset,
        strategyParams[i].stableRateExcessOffset,
        strategyParams[i].optimalStableToTotalDebtRatio
      );
    }
    return strategies;
  }

  function predictCreateDeterministic(StrategyParams memory params)
    public
    view
    returns (address)
  {
    return
      _predictCreate2Address(
        address(this),
        _getSaltFromName(params.name),
        type(DefaultReserveInterestRateStrategy).creationCode,
        abi.encode(params)
      );
  }

  function getDeployedStrategyByName(string calldata name)
    external
    view
    returns (address)
  {
    return _deployedStrategies[_getSaltFromName(name)];
  }

  function _getSaltFromName(string memory name)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(abi.encode(name));
  }

  function _predictCreate2Address(
    address creator,
    bytes32 salt,
    bytes memory creationCode,
    bytes memory constructorArgs
  ) internal pure returns (address) {
    bytes32 hash = keccak256(
      abi.encodePacked(
        bytes1(0xff),
        creator,
        salt,
        keccak256(abi.encodePacked(creationCode, constructorArgs))
      )
    );

    return address(uint160(uint256(hash)));
  }
}
