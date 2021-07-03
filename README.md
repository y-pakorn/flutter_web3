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

**flutter_web3** is Dart class and method wrapper for

- Ethereum object
- [Ether.js](https://docs.ethers.io/v5/) package
  - This can be used to sign transaction and interact with smart contract, also query Blockchain data utils and a lot of helper function for developing dapps.
- [Wallet Connect Provider](https://docs.walletconnect.org/quick-start/dapps/web3-provider) package
  - This enable QR code modal interaction and enable wallet that utilize Wallet Connect to use provider.

By utilizing dart2js functionality and dart extension, we manage to get Typing and Asynchonous into dart!

#### This package is made especially for developing Dapp on cross(multiple) chain in Flutter

### API Reference can be view [here](https://pub.dev/documentation/flutter_web3/latest/)

> NOTE: This is for Flutter web only!

## Breaking Changes

- 1.0.17: `ethereumEnabled` getter was changed to `isEthereumSupported` to reflect its property more clearly.

- 1.0.15: Ethers `Utils` class was changed to `EthUtils`, Functionality remain the same.

## Ethereum Object

You can access the Ethereum object by accessing the `ethereum` getter.

```dart
// use `isEthereumSupported` to avoid js undefined error on some browser.
if (isEthereumSupported) {
    final accs = await ethereum!.getAccounts(); // get all accounts in node disposal.
    accs // [foo,bar]
}
```

Prompt user to connect to provider, aka eth_requestAccounts,

```dart
final accs = await ethereum!.requestAccount(); // prompt the connection, make sure to handle the error when user cancle.
accs // [foo,bar]
```

Subscribe to accountsChanged event,

```dart
ethereum!.onAccountChanged((accs) {
 print(accs); // [foo,bar]
});
```

Handle other dynamic event,

```dart
ethereum!.on('message', (message) {
 final json = convertToDart(message); // Convert js to Dart object.
 json['foo'] // Foo
 json['bar']['baz'] // Barbaz
});
```

Or call other json rpc request method that have generic return type T,

```dart
final result = await ethereum!.request<BigNumber>('eth_gasPrice');
result.toBigInt; // 100,000,000,000
```

## Ethers.js

### Initialize

To initialize, add ethers.js script to `web/index.html`.

```
<script src="https://cdn.ethers.io/lib/ethers-5.0.umd.min.js" type="application/javascript"></script>
```

---

### Usage

#### Provider

Then create an ethers provider:

```dart
// For a read-only provider:
final provider = JsonRpcProvider("https://rpc.foo.io");
// For a read-write provider (ie: metamask, trust wallet, binance chain, etc.)
final provider = Web3Provider(ethereum!);
```

Or use the default Web3Provider getter

```dart
final web3provider = provider;
```

Then we can query various Blockchain data,

```dart
final balance = await provider!.getBalance('0xBar');
balance // 100,000,000 (in Wei)

final block = await provider!.getBlock(3949294);
block.miner // 0xbar
block.transaction // [0xfoo,0xbar,0xbarbaz]
block.nounce // 1293014
```

Or directly calling Ethers js with specific result type,

```dart
final result  = await provider!.call<BigNumber>('getGasPrice');
result.toBigInt;// 100,000,000,000,000
```

---

#### Signer

Use signer to get specific data about address in possession,

```dart
final balance = await provider!.getBalance();
balance; // 100,000,000,000,000
```

Or use signer to send transaction,

```dart
final tx = await provider!.getSigner().send(TxParams(to: '0xbar',value: '100,000,000'));
tx.hash // 0xbaz
```

---

#### Contract

Initializing Contract object, Supported Abi types refer to [Ether.js docs](https://docs.ethers.io/v5/api/utils/abi/formats/)

```dart
final abi = [
    // Some details about the token
    "function name() view returns (string)",
    "function symbol() view returns (string)",

    // Get the account balance
    "function balanceOf(address) view returns (uint)",

    // Send some of your tokens to someone else
    "function transfer(address to, uint amount)",

    // An event triggered whenever anyone transfers to someone else
    "event Transfer(address indexed from, address indexed to, uint amount)"
];

final contract = Contract('0xfoo', abi, provider!);
```

Calling view-only property,

```dart
final name = await contract.call<String>('name');
name // FooBarBaz

final symbol = await contract.call<String>('symbol');
symbol // FBB
```

Multicalling view-only constant method,

```dart
final balances = await contract.multicall<String>('balanceOf', [
  ['0xbar'],
  ['0xfoo'],
  ['0xbaz']
]);

balances // [1000000, 1000000, 1000000000] 
```

Sending write method (need Signer to passed into the contract),

```dart
final contract = Contract('0xfoo', abi, provider!.getSigner());

final tx = await contract.send('transfer', ['0xbarbaz','100000000']);

tx.hash // 0xfoo
```

And wait until transaction is successfully mined

```dart
var receipt = await provider!.waitForTransaction(tx.hash);
// or
var receipt = await tx.wait();

receipt.isSuccessful // true if successful
receipt.logs.firstWhere((e) => e.topics.first == '0xbar').data // 0xfoobar

```

Subscribe to any emitted event,

```dart
contract.on('Transfer', (from,to,amount,data) {
 convertToDart(data) // {'foo':'bar','baz':'foobar',...}
 from // 0xbar
 to // 0xbaz
 amount // 100,000,000,000
});
```

Convert abi to different format,

```dart
final interface = Interface([
  'function balanceOf(address) view returns (uint)',
]);

interface.format(FormatTypes.json); // [{"type":"function","name":"balanceOf","constant":true,"stateMutability":"view","payable":false,"inputs":[{"type":"address"}],"outputs":[{"type":"uint256"}]}]
```

Query past event logs,

```dart
// Filter logs from 0xfoo to { 0xbar or 0xbaz }.
final filter = contract.getFilter('Transfer', ['0xfoo', ['0xbar', '0xbaz']]); 

// Apply filter and query all logs from block 111111 to lastest.
final logs = await contract.queryFilter(filter, 111111);

// The last is the most recent one.
logs.last.transactionHash // 0xfoobar
```

Alternatively for ERC20 Contract, we can use ContractERC20 class.

```dart
final token = ContractERC20('0xfoo', provider!.getSigner());

await token.name; // Foo
await token.symbol; // Bar
await token.decimals; // Baz

final tx = await token.transfer('0xbar', BigInt.parse('10000000000000'));
tx.hash // 0xbarbaz

token.onApproval((owner, spender, value, data) {
  owner // 0xfoo
  spender //0xbar
  value //0xbaz
});

```

## Wallet Connect Provider

### Initialize

To initialize, add Wallet Connect Provider script to `web/index.html`. We can use CDN from [jsdelivr](https://www.jsdelivr.com/package/npm/@walletconnect/web3-provider).

```
<script src="https://cdn.jsdelivr.net/npm/@walletconnect/web3-provider@1.5.0-rc.2/dist/umd/index.min.js" type="application/javascript"></script>
```

---

### Usage

Create Wallet Connect Provider object,

Since rpc argument in `WalletConnectProviderOptions` is js map object with dynamic keys and values, we need to wrap it in js converter.

```dart
final jsMap = convertRpc({ 
  56: 'https://bsc-dataseed.binance.org/',
});

final option = WalletConnectProviderOptions(
  rpc: jsMap,
  network: 'binance', // select one sepcific network to connect
  chainId: 56, // select one sepcific network to connect
);

final wc = WalletConnectProvider(option);
```

Then enable the session by toggling QR code modal,

```dart
await wc.connect();
```

After that, we can use the object normally as Ethereum object,

```dart
await wc.getChainId(); // 1
```

Or  integrate into Ethers library and use Web3Provider to interact further,

```dart
final w3 = Web3Provider(wc);
await w3.getGasPrice(); // 100,000,000
```
