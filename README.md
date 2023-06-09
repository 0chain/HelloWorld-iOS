# ZusExampleiOS
[Züs](https://zus.network/) is a high-performance cloud on a fast blockchain offering privacy and configurable uptime. It is an alternative to traditional cloud S3 and has shown better performance on a test network due to its parallel data architecture. The technology uses erasure code to distribute the data between data and parity servers. Züs storage is configurable to provide flexibility for IT managers to design for desired security and uptime, and can design a hybrid or a multi-cloud architecture with a few clicks using [Blimp's](https://blimp.software/) workflow, and can change redundancy and providers on the fly.

For instance, the user can start with 10 data and 5 parity providers and select where they are located globally, and later decide to add a provider on-the-fly to increase resilience, performance, or switch to a lower cost provider.

Users can also add their own servers to the network to operate in a hybrid cloud architecture. Such flexibility allows the user to improve their regulatory, content distribution, and security requirements with a true multi-cloud architecture. Users can also construct a private cloud with all of their own servers rented across the globe to have a better content distribution, highly available network, higher performance, and lower cost.

[The QoS protocol](https://medium.com/0chain/qos-protocol-weekly-debrief-april-12-2023-44524924381f) is time-based where the blockchain challenges a provider on a file that the provider must respond within a certain time based on its size to pass. This forces the provider to have a good server and data center performance to earn rewards and income.

The [privacy protocol](https://zus.network/build) from Züs is unique where a user can easily share their encrypted data with their business partners, friends, and family through a proxy key sharing protocol, where the key is given to the providers, and they re-encrypt the data using the proxy key so that only the recipient can decrypt it with their private key.

Züs has ecosystem apps to encourage traditional storage consumption such as [Blimp](https://blimp.software/), a S3 server and cloud migration platform, and [Vult](https://vult.network/), a personal cloud app to store encrypted data and share privately with friends and family, and [Chalk](https://chalk.software/), a zero upfront cost permanent storage solution for NFT artists.

Other apps are [Bolt](https://bolt.holdings/), a wallet that is very secure with air-gapped 2FA split-key protocol to prevent hacks from compromising your digital assets, and it enables you to stake and earn from the storage providers; [Atlus](https://atlus.cloud/), a blockchain explorer and [Chimney](https://demo.chimney.software/), which allows anyone to join the network and earn using their server or by just renting one, with no prior knowledge required.

## Project

This is a test project for the Zus iOS SDK. In this app you can find examples of how to use the
SDK.

The app covers demo for two product lines of Zus i.e. bolt and vult.

https://github.com/0chain/HelloWorld-iOS/assets/53724307/d0d33acd-793b-451b-9dd8-9465d9840ca8

## Bolt

It is a cryptocurrency wallet for exchange of zcn ERC 20 and ethereum tokens. Tokens can also be
staked and users get rewards for staking.

https://github.com/0chain/HelloWorld-iOS/assets/53724307/e9279577-4a23-4539-bc16-a8531e1c51a0


## Vult

Vult is a dencentralised anonymous file sharing platform. Users can upload files and share them with
other users.

https://github.com/0chain/HelloWorld-iOS/assets/53724307/2d98a32d-87f1-4b0d-9d13-ff4f4136d32d


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
    "signature_scheme": "bls0chain",
    "block_worker": "https://demo.zus.network/dns",
    "confirmation_chain_length": 3
  },
  "data_shards": 2,
  "parity_shards": 2,
  "zbox_url": "https://0box.demo.zus.network/",
  "block_worker": "https://demo.zus.network",
  "domain_url": "demo.zus.network",
  "network_fee_url": "https://demo.zus.network/miner01/v1/block/get/fee_stats",
  "explorer_url": "https://demo.zus.network/"
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


