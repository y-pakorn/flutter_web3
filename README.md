<h1 align="center">flutter_web3</h1>

<div align="center">
<a href="https://pub.dev/packages/flutter_web3">
<img alt="Pub Version" src="https://img.shields.io/pub/v/flutter_web3?style=flat-square">
</a>
<a href="https://pub.dev/packages/flutter_web3/versions">
<img alt="Pub Version Include Prerelease" src="https://img.shields.io/pub/v/flutter_web3?include_prereleases&style=flat-square">
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

- Ethereum object from provider, i.e. MetaMask.
- [Ether.js](https://docs.ethers.io/v5/) package
  - This can be used to sign transaction and interact with smart contract, also query Blockchain data utils and a lot of helper function for developing dapps.
- [Wallet Connect Provider](https://docs.walletconnect.org/quick-start/dapps/web3-provider) package
  - This enable QR code modal interaction and enable wallet that utilize Wallet Connect to use provider.

#### This package is made especially for developing Dapp on cross(multiple) chain in Flutter Web

## V2.1 Changes

Version 2.1 introduce EIP-1559 properties for various object.

- `gasPrice` property on many(all) class is now nullable.
  - will be `null` on mainnet but not `null` on fork or chain that not yet implement EIP-1559.
- Added `maxFeePerGas` and `maxPriorityFeePerGas` properties to `Transaction`, `TransactionRequest`, and `TransactionOverride`.
- Added `getFeeData` method to `Provider`.
- Added `baseFee` property to `Block`.

Pull requests for missing features/properties are always welcomed.

---

## Example Usage And Tutorial

- Auction
  - A ERC20 token auction website built by Flutter
  - <https://github.com/y-pakorn/flutter_web3_auction>

- Building Modern Web Dapp with Flutter
  - <https://medium.com/coinmonks/building-modern-web-dapp-with-flutter-91656c71d8b>

---

## Getting Started

### Installing

To use Flutter Web3 package, use

```shell
 flutter pub add flutter_web3
```

#### Ethers JS and Wallet Connect Provider

To use Ethers JS and Wallet Connect Provider, we need to include script to JS package in `web/index.html`

```html
  <!--Ethers-->
  <script src="https://cdn.ethers.io/lib/ethers-5.4.umd.min.js" type="application/javascript"></script>
  <!--Wallet Connect-->
  <script src="https://cdn.jsdelivr.net/npm/@walletconnect/web3-provider@1.6.5/dist/umd/index.min.js" type="application/javascript"></script>
```

---

### Ethereum Provider

Prompt the connection to MetaMask or other provider.  

```dart
// `Ethereum.isSupported` is the same as `ethereum != null`
if (ethereum != null) {
  try {
    // Prompt user to connect to the provider, i.e. confirm the connection modal
    final accs = await ethereum!
        .requestAccount(); // Get all accounts in node disposal
    accs; // [foo,bar]
  } on EthereumUserRejected {
    print('User rejected the modal');
  }
}
```

Subscribe to Ethereum events.

```dart
// Subscribe to `chainChanged` event
ethereum!.onChainChanged((chainId) {
  chainId; // foo
});

// Subscribe to `accountsChanged` event.
ethereum!.onAccountsChanged((accounts) {
  print(accounts); // ['0xbar']
});

// Subscribe to `message` event, need to convert JS message object to dart object.
ethereum!.on('message', (message) {
  dartify(message); // baz
});
```

Call other [JSON RPC API](https://eth.wiki/json-rpc/API#json-rpc-methods).

```dart
// Call `eth_gasPrice` as `BigInt`
final result = await ethereum!.request<BigInt>('eth_gasPrice');

result; // 5000000000
result is BigInt; // true
```

---

### Ethers

> Based on Ethers documentation on [Getting Started](https://docs.ethers.io/v5/getting-started/).

#### Connecting to Ethereum: Metamask

```dart
final web3provider = Web3Provider(ethereum!);
// or
final web3provider = Web3Provider.fromEthereum(ethereum!);
// or
provider; // Default Web3Provider instance from default Ethereum provider
```

#### Connecting to Ethereum: RPC

```dart
final rpcProvider = JsonRpcProvider(); // Rpc Provider from default Rpc url, i.e. https://localhost:8545

final rpcProvider = JsonRpcProvider('https://bsc-dataseed.binance.org/'); // Rpc Provider from specific Rpc url
```

#### Querying the Blockchain

```dart
// Look up the current block number
await provider!.getBlockNumber(); // 9261427

// Get the lastest block information that available
await provider!.getLastestBlock(); // Block: 9261427 0x9e7900b8 mined at 2021-07-18T16:58:45.000 with diff 2

// Get the specific account balance
await provider!.getBalance('0xgarply'); // 315752957360231815

// Get the transcation receipt of specific transaction hash
await provider!.getTransactionReceipt('0xwaldo'); // TransactionReceipt: 0x1612d8ba from 0x6886ec02 with 20 confirmations and 12 logs
```

Calling other [Ether provider API](https://docs.ethers.io/v5/api/providers/provider/).

```dart
// Call `getGasPrice` as `BigInt`
final result = await provider!.call<BigInt>('getGasPrice');

result; // 5000000000
result is BigInt; // true
```

#### Signer

Query data about your account.

```dart
// Get signer from provider
final signer = provider!.getSigner();

// Get account balance
await signer.getBalance(); // 315752957360231815

// Get account sent transaction count (not contract call)
await signer.getTransactionCount(BlockTag.latest); // 1
```

Send/write to the Blockchain

```dart
// Send 1000000000 wei to `0xcorge`
final tx = await provider!.getSigner().sendTransaction(
      TransactionRequest(
        to: '0xcorge',
        value: BigInt.from(1000000000),
      ),
    );

tx.hash; // 0xplugh

final receipt = await tx.wait();

receipt is TransactionReceipt; // true
```

#### Wallet

Create a wallet from mnemonic phrase.

```dart
final mnemonic =
    "announce room limb pattern dry unit scale effort smooth jazz weasel alcohol";
final wallet = Wallet.fromMnemonic(mnemonic);
```

Or directly from private key.

```dart
final anotherWallet = Wallet(wallet.privateKey);
```

Then connect the wallet to specific provider.

```dart
// Connect wallet to network
final testnetProvider =
    JsonRpcProvider('https://data-seed-prebsc-1-s2.binance.org:8545/');
final walletWithProvider = wallet.connect(testnetProvider);
``` 

After that, the wallet object can be used as normal signer object.

```dart
final tx = await walletWithProvider.sendTransaction(
  TransactionRequest(
    to: '0xbar',
    value: BigInt.from(100),
  ),
); // Send 100 wei to `0xbar`

tx.hash; // 0xbash
```

#### Contract

Define ABI object, All ABI formats can be view [here](https://docs.ethers.io/v5/api/utils/abi/formats/).

Note that you must be precise with the function argument and return types, this will yield different data types. For example, `uint256` will yield `BigNumber` but `uint16` will simply yield `int`. **There might be error if you manually type this by hand.**

```dart
final humanReadableAbi = [
  "function balanceOf(address owner) view returns (uint256 balance)",
  // Some examples with the struct type, we use the tuple keyword:
  // (note: the tuple keyword is optional, simply using additional
  //        parentheses accomplishes the same thing)
  // struct Person {
  //   string name;
  //   uint16 age;
  // }
  "function addPerson(tuple(string name, uint16 age) person)", // Or "function addPerson((string name, uint16 age) person)"
];

final jsonAbi = '''[
  {
    "type": "function",
    "name": "balanceOf",
    "constant":true,
    "stateMutability": "view",
    "payable":false, "inputs": [
      { "type": "address", "name": "owner"}
    ],
    "outputs": [
      { "type": "uint256"}
    ]
  }
]''';

// Contruct Interface object out of `humanReadableAbi` or `jsonAbi`
final humanInterface = Interface(humanReadableAbi);
final jsonInterface = Interface(jsonAbi);

// These two abi interface can be exchanged
humanInterface.format(FormatTypes.minimal); // [function balanceOf(address) view returns (uint256)]
humanInterface.format(FormatTypes.minimal)[0] == jsonInterface.format(FormatTypes.minimal)[0]; // true
```

Initialize Contract object.

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

final busdAddress = '0xe9e7cea3dedca5984780bafc599bd69add087d56';

// Use `Provider` for Read-only contract, i.e. Can't call state-changing method
final busd = Contract(
  busdAddress,
  abi,
  provider!,
);

// Use `Signer` for Read-write contract
// Notice that ABI can be exchangeable
final anotherBusd = Contract(
  busdAddress,
  Interface(abi),
  provider!.getSigner(),
);
// Or `busd.connect(provider!.getSigner());`
```

Read-only method.

```dart
// Call `name`
await busd.call<String>('name'); // BUSD Token
// Call `symbol`
await busd.call<String>('symbol'); // BUSD
// Call `balanceOf`
await busd.call<BigInt>(
  'balanceOf',
  ['0xthud'],
); // 2886780594123782414119
```

Use List to notate Tuple type.

```dart
final abi = "function see(tuple(address, uint8, bytes)[], uint256) view returns (uint256)";

final contract = Contract('0xrandomContract', abi, provider!);

await contract.call<BigInt>('see', [
  [
    '0x0000000000000000000000000000000000000000',
    0,
    '0x',
  ],
  1000,
]); // 1248842
```

Write/State-changing method.

```dart
// Send 1 ether to `0xfoo` 
final tx = await anotherBusd.send('transfer', ['0xfoo', '1000000000000000000']);
tx.hash; // 0xbar

final receipt = tx.wait(); // Wait until transaction complete
receipt.from; // 0xthud
receipt.to; // 0xe9e7cea3dedca5984780bafc599bd69add087d56 (BUSD Address)
```

Send Ether along with payable method.

```dart
final abi = "function throw() payable";

final contract = Contract('0xrandomContract', abi, provider!);

// Send 100 wei of ether along
final tx = await contract.send(
  'throw',
  [],
  TransactionOverride(value: BigInt.from(100)),
);

tx.hash; // 0xfoo
```

Listening to Events.

```dart
// Receive an event when ANY transfer occurs
busd.on('Transfer', (from, to, amount, event) {
  from; // 0x0648ff5de80Adf54aAc07EcE2490f50a418Dde23
  to; // 0x12c64E61440582793EF4964A36d98020d83490a3
  amount; // 1015026418461703883891
  Event.fromJS(event); // Event: Transfer Transfer(address,address,uint256) with args [0x0648ff5de80Adf54aAc07EcE2490f50a418Dde23, 0x12c64E61440582793EF4964A36d98020d83490a3, 1015026418461703883891]
});

// A filter for when a specific address receives tokens
final myAddress = "0x8ba1f109551bD432803012645Ac136ddd64DBA72";
final filter = busd.getFilter('Transfer', [null, myAddress]);
// {
//   address: '0xe9e7cea3dedca5984780bafc599bd69add087d56',
//   topics: [
//     '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
//     null,
//     '0x0000000000000000000000008ba1f109551bd432803012645ac136ddd64dba72'
//   ]
// }

busd.on(filter, (from, to, amount, event) {
// ...
});
```

Query Historic Events

```dart
final filter = busd.getFilter('Transfer');

// Query past event in last 100 blocks.
final events = await busd.queryFilter(filter, -100);

events.first; // Event: Transfer Transfer(address,address,uint256) with args [0x209F2A37Ccb5672794329cB311406A995de9347c, 0x928bE3DEB1f8B9e4A24a5744bD313E726462961D, 150000000000000000000]
```

Alternatively for ERC20 Contract, we can use ContractERC20 class.

```dart
final token = ContractERC20('0xfoo', provider!.getSigner());

await token.name; // foo
await token.symbol; // bar
await token.decimals; // baz

final tx = await token.transfer('0xbar', BigInt.parse('10000000000000'));
tx.hash // 0xbarbaz

token.onApproval((owner, spender, value, event) {
  owner // 0xfoo
  spender //0xbar
  value //0xbaz
});
```

---

### Wallet Connect Provider

Create `WalletConnectProvider` object.

```dart
// From RPC
final wc = WalletConnectProvider.fromRpc(
  {56: 'https://bsc-dataseed.binance.org/'},
  chainId: 56,
  network: 'binance',
);

// From Infura
final infuraWc = WalletConnectProvider.fromInfura('https://foo.infura.io/v3/barbaz');

// Static RPC
final binaceWc = WalletConnectProvider.binance();
final polygonWc = WalletConnectProvider.polygon();
...
```

Enable the session, toggle QRCode Modal.

```dart
await wc.connect();
```

Use in Ethers `Web3Provider`.

```dart
final web3provider = Web3Provider.fromWalletConnect(wc);

await web3provider.getGasPrice(); // 5000000000
```

---
