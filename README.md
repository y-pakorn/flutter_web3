# flutter_web3_provider

Flutter wrapper for using web3 providers, ie: accessing `window.ethereum`.

NOTE: This is for web only!

## Getting Started

Add import `import 'package:flutter_web3_provider/ethereum.dart';`

Then you can access it just be using the `ethereum` variable.

```dart
if(ethereum != null){
    // then an ethereum provider was injected
    print(ethereum.selectedAddress);
}
```

Ask user to connect their wallet:

```dart
RaisedButton(
    child: Text("Connect Wallet"),
    onPressed: () async {
        var accounts = await promiseToFuture(
            ethereum.request(RequestParams(method: 'eth_requestAccounts')));
        print(accounts);
        String se = ethereum.selectedAddress;
        print("selectedAddress: $se");
        setState(() {
            selectedAddress = se;
        });
    },
)
```

### Using ethers.js

Add ethers.js to `web/index.html`.

eg: 

```
<script src="https://cdn.ethers.io/lib/ethers-5.0.umd.min.js" type="application/javascript"></script>
```

Then create an ethers Web3Provider:

```dart
Web3Provider web3 = Web3Provider(ethereum);
```

Then you can do things like submit transactions, etc:

```dart
Future tx = promiseToFuture(web3.Signer().sendTransaction(TxParams(
      to: to,
      value: "0x" +
          BigInt.parse(toBase(amount, 18).toString()).toRadixString(16))));
```

Or use a contract:

```dart
const erc20Abi = [
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
var contract = Contract(address, erc20Abi, web3);
contract = contract.connect(web3.getSigner()); // uses the connected wallet as signer
Future tx = promiseToFuture(contract.transfer(
      to,
      "0x" +
          BigInt.parse(toBase(amount, 18).toString()).toRadixString(16)));
```
