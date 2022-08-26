pragma solidity ^0.8.0;

import {IInterestRatesStrategyFactory} from './IInterestRatesStrategyFactory.sol';

// TODO: for tests
// 1) check that all assets will have strategies

library InterestRatesStrategyConfigs {
  struct StrategyConfig {
    IInterestRatesStrategyFactory.StrategyParams params;
    address deployedStrategyAddress;
    address[] assets;
  }

  function getConfigs() public pure returns (StrategyConfig[] memory) {
    StrategyConfig[] memory params = new StrategyConfig[](18);
    address[] memory assets;

    assets = new address[](2);
    assets[0] = 0x4Fabb145d64652a948d72533023f6E7A623C7C53; // BUSD
    assets[1] = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51; // sUSD
    params[0] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyStableOne', // STABLE
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 1 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](4);
    assets[0] = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI
    assets[1] = 0x0000000000085d4780B73119b644AE5ecd22b376; // TUSD
    assets[2] = 0x03ab458634910AaD20eF5f1C8ee96F1D6ac54919; // RAI
    assets[3] = 0xa693B19d2931d498c5B318dF961919BB4aee87a5; // UST
    params[1] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyStableTwo', // STABLE
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 0.75 * 1e27,
        stableRateSlope1: 0.02 * 1e27,
        stableRateSlope2: 0.75 * 1e27,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](2);
    assets[0] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // USDC
    assets[1] = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
    params[2] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyStableThree', // STABLE
        optimalUsageRatio: 0.9 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 0.6 * 1e27,
        stableRateSlope1: 0.02 * 1e27,
        stableRateSlope2: 0.6 * 1e27,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
    params[3] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyWETH',
        optimalUsageRatio: 0.7 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.03 * 1e27,
        variableRateSlope2: 1 * 1e27,
        stableRateSlope1: 0.04 * 1e27,
        stableRateSlope2: 1 * 1e27,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9; // AAVE
    params[4] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyAAVE',
        optimalUsageRatio: 0.45 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0,
        variableRateSlope2: 0,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](11);
    assets[0] = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF; // BAT
    assets[1] = 0xF629cBd94d3791C9250152BD8dfBDF380E2a3B9c; // ENJ
    assets[2] = 0x514910771AF9Ca656af840dff83E8264EcF986CA; // LINK
    assets[3] = 0x0F5D2fB29fb7d3CFeE444a200298f468908cC942; // MANA
    assets[4] = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2; // MKR
    assets[5] = 0x408e41876cCCDC0F92210600ef50372656052a38; // REN
    assets[6] = 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e; // YFI
    assets[7] = 0xE41d2489571d322189246DaFA5ebDe1F4699F498; // ZRX
    assets[8] = 0xD533a949740bb3306d119CC777fa900bA034cd52; // CRV
    assets[9] = 0xba100000625a3754423978a60c9317c58a424e3D; // BAL
    assets[10] = 0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B; // CVX
    params[5] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyVolatileOne',
        optimalUsageRatio: 0.45 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.07 * 1e27,
        variableRateSlope2: 3 * 1e27,
        stableRateSlope1: 0.1 * 1e27,
        stableRateSlope2: 3 * 1e27,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](2);
    assets[0] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599; // WBTC
    assets[1] = 0xdd974D5C2e2928deA5F71b9825b8b646686BD200; // KNC
    params[6] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyVolatileTwo',
        optimalUsageRatio: 0.65 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.08 * 1e27,
        variableRateSlope2: 3 * 1e27,
        stableRateSlope1: 0.1 * 1e27,
        stableRateSlope2: 3 * 1e27,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](3);
    assets[0] = 0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272; // xSUSHI
    assets[1] = 0xC18360217D8F7Ab5e7c516566761Ea12Ce7F9D72; // ENS
    assets[2] = 0x111111111117dC0aa78b770fA6A738034120C302; // 1INCH
    params[7] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyVolatileThree',
        optimalUsageRatio: 0.45 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.07 * 1e27,
        variableRateSlope2: 3 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x056Fd409E1d7A124BD7017459dFEa2F387b6d5Cd; // GUSD
    params[8] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyGUSD', // STABLE
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 1 * 1e27,
        stableRateSlope1: 0.04 * 1e27,
        stableRateSlope2: 1 * 1e27,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0xD5147bc8e386d91Cc5DBE72099DAC6C9b99276F5; // renFIL
    params[9] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyRenFIL',
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.07 * 1e27,
        variableRateSlope2: 3 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0xD46bA6D942050d489DBd938a2C909A5d5039A161; // AMPL
    params[10] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyAMPL',
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0.01 * 1e27,
        variableRateSlope1: 0.02 * 1e27,
        variableRateSlope2: 7.5 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x8E870D67F660D95d5be530380D0eC0bd388289E1; // USDP
    params[11] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyUSDP', // STABLE
        optimalUsageRatio: 0.9 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 0.6 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x1494CA1F11D487c2bBe4543E90080AeBa4BA3C2b; // DPI
    params[12] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyDPI',
        optimalUsageRatio: 0.5 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.07 * 1e27,
        variableRateSlope2: 3 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x853d955aCEf822Db058eb8505911ED77F175b99e; // FRAX
    params[13] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyFRAX', // STABLE
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 0.75 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA; // FEI
    params[14] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyFEI', // STABLE
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.04 * 1e27,
        variableRateSlope2: 1 * 1e27,
        stableRateSlope1: 0.02 * 1e27,
        stableRateSlope2: 1 * 1e27,
        baseStableRateOffset: 0.01 * 1e27,
        stableRateExcessOffset: 0.08 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84; // stETH
    params[15] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyStETH',
        optimalUsageRatio: 0.6 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.08 * 1e27,
        variableRateSlope2: 2 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F; // SNX
    params[16] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategySNX',
        optimalUsageRatio: 0.8 * 1e27,
        baseVariableBorrowRate: 0.03 * 1e27,
        variableRateSlope1: 0.12 * 1e27,
        variableRateSlope2: 1 * 1e27,
        stableRateSlope1: 0,
        stableRateSlope2: 0,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    assets = new address[](1);
    assets[0] = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984; // UNI
    params[17] = StrategyConfig({
      params: IInterestRatesStrategyFactory.StrategyParams({
        name: 'rateStrategyUNI',
        optimalUsageRatio: 0.45 * 1e27,
        baseVariableBorrowRate: 0,
        variableRateSlope1: 0.07 * 1e27,
        variableRateSlope2: 3 * 1e27,
        stableRateSlope1: 0.12 * 1e27,
        stableRateSlope2: 3 * 1e27,
        baseStableRateOffset: 0.02 * 1e27,
        stableRateExcessOffset: 0.05 * 1e27,
        optimalStableToTotalDebtRatio: 0.2 * 1e27
      }),
      assets: assets,
      deployedStrategyAddress: address(0)
    });

    return params;
  }
}
