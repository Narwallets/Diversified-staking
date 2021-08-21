set -e
NETWORK=mainnet
OWNER=narwallets.$NETWORK
MASTER_ACC=meta-pool.$NETWORK
OPERATOR_ACC_SUFFIX=.meta-pool.$NETWORK
CONTRACT_ACC=$MASTER_ACC
GOV_TOKEN=meta-token.$NETWORK

meta --cliconf -c $CONTRACT_ACC -acc $OWNER

export NODE_ENV=$NETWORK

near create-account treasury$OPERATOR_ACC_SUFFIX --masterAccount $MASTER_ACC
near create-account operator$OPERATOR_ACC_SUFFIX --masterAccount $MASTER_ACC

## delete acc
#echo "Delete $CONTRACT_ACC? are you sure? Ctrl-C to cancel"
#read input
#near delete $CONTRACT_ACC $MASTER_ACC
#near create-account $CONTRACT_ACC --masterAccount $MASTER_ACC
meta deploy ./res/metapool.wasm
meta new { owner_account_id:$OWNER, treasury_account_id:treasury$OPERATOR_ACC_SUFFIX, operator_account_id:operator$OPERATOR_ACC_SUFFIX, meta_token_account_id:$GOV_TOKEN } --accountId $MASTER_ACC
## set params@meta set_params
#meta set_params
## deafult 4 pools
##meta default_pools_testnet


## redeploy code only
near deploy $CONTRACT_ACC ./res/metapool.wasm  --accountId $MASTER_ACC
#meta set_params

#near deploy contract4.preprod-pool.testnet ./res/metapool.wasm  --accountId preprod-pool.testnet
#near call contract4.preprod-pool.testnet set_busy "{\"value\":false}" --accountId preprod-pool.testnet --depositYocto 1

#save this deployment  (to be able to recover state/tokens)
cp ./res/metapool.wasm ./res/metapool.$CONTRACT_ACC.`date +%F.%T`.wasm
date +%F.%T