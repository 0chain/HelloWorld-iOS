# ZusExampleiOS
This is a test project for the Zus iOS SDK. In this app you can find examples of how to use the
SDK.

The app covers demo for two product lines of Zus i.e. bolt and vult.

## Bolt

It is a cryptocurrency wallet for exchange of zcn ERC 20 and ethereum tokens. Tokens can also be
staked and users get rewards for staking.

## Vult

Vult is a dencentralised anonymous file sharing platform. Users can upload files and share them with
other users.

## SDK

Both of the apps rely on the [gosdk](https://github.com/0chain/gosdk) for interacting with the
0chain blockchain.

## Setup the SDK

### Download the latest sdk from [here](https://github.com/0chain/gosdk/releases). Extract `zcncore.xcframework`

1. Now copy `zcncore.xcframework` to prokect directory.
2. Embed the library in your target. 
3. `import Zcncore` to your file and access methods!

Now we also need to initialize the `Zcncore` in our `Application` class.

configJson is the json string which contains the configuration for the sdk.

```json
 {
  "config": {
    "chain_id": "0afc093ffb509f059c55478bc1a60351cef7b4e9c008a53a6cc8241ca8617dfe",
    "signature_scheme": "bls0chain",
    "block_worker": "https://beta.0chain.net/dns",
    "min_submit": 50,
    "min_confirmation": 50,
    "confirmation_chain_length": 3,
    "num_keys": 1,
    "eth_node": "https://ropsten.infura.io/v3/f0a254d8d18b4749bd8540da63b3292b"
  },
  "data_shards": 2,
  "parity_shards": 2,
  "zbox_url": "https://0box.beta.0chain.net/",
  "block_worker": "https://beta.0chain.net",
  "domain_url": "beta.0chain.net",
  "network_fee_url": "https://beta.0chain.net/miner01/v1/block/get/fee_stats",
  "explorer_url": "https://beta.0chain.net/"
}
```

```Swift
var error : NSError?
ZcncoreInit(configJSON, &error)
```

## How to create a wallet.
To create a wallet you need to call the `ZcncoreCreateWallet` function. 
## Some common terms used in our code and blockchain

- `blobber` - A blobber is a storage provider. It is a server that stores files on behalf of users.
  Blobbers are paid for storing files and for serving files to users. Blobbers are also paid for
  serving files to other blobbers. Blobbers are paid in ZCN tokens.
- `allocation` - An allocation is a group of blobbers that are used to store files. An allocation
  has a set of parameters that define how files are stored and how blobbers are paid. An allocation
  is paid in ZCN tokens.
- `miners` - Miners are the nodes that run the 0chain blockchain. Miners are paid in ZCN tokens.
- `sharders` - Sharders are the nodes that run the 0chain blockchain. Sharders are paid in ZCN
  tokens.
- `wallet` - A wallet is a collection of keys that are used to sign transactions. A wallet is used
  to sign transactions for blobbers, miners, sharders, and users.
- `ZCN` - ZCN is the token that is used to pay miners, sharders, blobbers, and users.
- `ERC20` - ERC20 is the token format used by zcn and ethereum.
- `public key` - A public key is a key that is used to verify a signature. A public key is used to
  verify a signature for a transaction.
- `private key` - A private key is a key that is used to sign a transaction. A private key is used
  to sign a transaction for a blobber, miner, sharder, or user.
- `signature` - A signature is a string that is used to verify that a transaction was signed by a
  private key. A signature is used to verify that a transaction was signed by a private key for a
  blobber, miner, sharder, or user.
- `mnemonics` - Mnemonics are a set of words that are used to generate a wallet. Mnemonics are used
  to generate a wallet for a user.
 
## Hackathon Discord Link

https://discord.gg/7JSzwpcK55


