<h1 align="center">flutter_web3</h1>

<div align="center">
<a href="https://pub.dev/packages/flutter_web3">
<img alt="Pub Version" src="https://img.shields.io/pub/v/flutter_web3?style=flat-square">
</a>
<a href="https://github.com/y-pakorn/flutter_web3/issues">
<img alt="GitHub issues" src="https://img.shields.io/github/issues/y-pakorn/flutter_web3?style=flat-square">
</a>
<a href="">
<img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/y-pakorn/flutter_web3?style=flat-square">
</a>
</div>

> This is a fork of [flutter_web3_provider](https://github.com/gochain/flutter_web3_provider). Be sure to check out the original package.

## Introduction

**flutter_web3** v2 is full Dart class and function wrapper for

- Ethereum object
- [Ether.js](https://docs.ethers.io/v5/) package
  - This can be used to sign transaction and interact with smart contract, also query Blockchain data utils and a lot of helper function for developing dapps.
- [Wallet Connect Provider](https://docs.walletconnect.org/quick-start/dapps/web3-provider) package
  - This enable QR code modal interaction and enable wallet that utilize Wallet Connect to use provider.

#### This package is made especially for developing Dapp on cross(multiple) chain in Flutter.

> This is for Flutter web only!

## Using V2 Package

Add ref pointer to v2 branch in pubspec.yaml file of your Flutter project.

Pre-release will soon publish into pub.dev after solid progress.

```
flutter_web3:
  git:
    url: git://github.com/y-pakorn/flutter_web3.git
    ref: v2
```


## V2 Changes

Version 2.0 of this package will introduce full dart wrapper instead of js interop class.

Track V2 progress by navigating to [this Github issue](https://github.com/y-pakorn/flutter_web3/pull/2)

### Breaking Changes

- `WalletConnectProvider` completely change the internal structure and constructor, but core class feature and method remain the same.
- `Web3Provider` unnamed constructor changed into `Web3Provider.fromEthereum` and `Web3Provider.fromWalletConnect` for `Ethereum` and `WalletConnectProvider` instance respectively.
