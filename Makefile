# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes --via-ir
build-watch  :; forge build --watch
test   :; forge test --fork-url $RPC_URL -vvvv
deploy-payload :; forge script scripts/DeployV2InterestRatesUpgradePayload.s.sol:Deploy --rpc-url $RPC_URL  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv
