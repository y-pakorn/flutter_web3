## 2.2.0-pre.2

- Pre-release for utils
- Fix BigInt not parsed properly on contract call

## 2.1.1

- Fix BigInt not parsed properly on contract call

## 2.1.0

- Implement EIP-15559 properties (#7)
- Add specific format method and more functionality
- Add code documentation for verifyMessage

## 2.0.5

- Fix js interop object not passed to connect method (#8)
- Add request method for json-rpc api call on WalletConnect
- Fix WalletConnectProvider event emitter argument
- Add Polygon, Harmony, and xDai chain to WalletConnectProvider
- Add support for BigInt in Contract call/send method
- Add getCode and getStorageAt to Provider

## 2.0.4

- Fix EtherException uncaught error
- Add estimateGas method to Ethers Contract

## 2.0.3

- Fix TransactionResponse bug

## 2.0.1

- Add exception handling to Signer and Contract
- Fix Ethers send transaction bugs

## 2.0.0

- Implement Dart class for Ethereum, Ethers, and WalletConnect
- Add Getting Started section to README.method
- Add Event and event listener handling
- Add Ethers exception handling
- Add Ethers ABI Interface
- Fix TransactionRequest/Ovverride constructor
- Fix Ethereum request type annotation
- Add Example package
- Add more code example
- Dartdoc unresolved docs fix
- Add custom exception throwing and handling
- Add more method to Ethers and Ethereum
- Generalize interop class implementation
- Remove redundant export and hide
- Remove isEthereumSupported
- Add class name to toString override for easier debugging
- Add assertion to Provider constructor

## 1.0.20

- Add more method and property to wallet connect wrapper

## 1.0.19

- Add BigInt wrapper for calling method on ethers
- Modify ContractERC20 according to BigInt wrapper
- Update README.md to recent changes

## 1.0.18

- Update breaking changes and add more element to README.md
- Remove export redundancy
- Add more useful method to ContractERC20
- Fix ethereum throw undefined error in some cases

## 1.0.16

- Reorganize export library

## 1.0.15

- Add more Ethers utils method
- Ethers bugs fix and change class name
- Add variable caching to ERC20 Contract

## 1.0.14

- Add filter object and method to query past events

## 1.0.13

- Add more Ethers method

## 1.0.12

- Add multicalling functionality

## 1.0.11

- Add balanceOf function to ERC20 Contract
- Seperate constant class and add more Ethers method

## 1.0.10

- Add more class and function wrapper
- Rewrite some documentation

## 1.0.9

- Implement new wrapping method that involve promise listener function
- Add ERC20 Contract wrapper and more utility function for Ethers

## 1.0.7

- Add more ethers js class and function wrapper
- Breaking changes: TxReceipt changes to TransactionReceipt

## 1.0.6

- Wallet Connect buges fix

## 1.0.5

- Reorganize directory structure
- Solve internal package issues

## 1.0.3

- Add Walletconnect Provider wrapper for provider connection and QR code modal

## 1.0.2

- Initial version
