# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env
export PATH := $(HOME)/.foundry/bin:$(PATH)

# deps
update:; forge update

# Build & test
build  :
	forge build --sizes --via-ir

build-watch  :
	forge build --watch

test   :
	forge test --fork-url ${RPC_URL} -vvv

deploy :
	forge script ./scripts/${SCRIPT_NAME}.s.sol:Deploy --rpc-url ${RPC_URL}  --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvv --broadcast

deploy-strategies :
	SCRIPT_NAME=DeployV3Strategies make deploy

deploy-payload :
	SCRIPT_NAME=DeployPhase1Payload make deploy
