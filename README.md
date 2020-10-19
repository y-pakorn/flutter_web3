# flutter_web3_provider

Flutter wrapper for using web3 providers, ie: accessing `window.ethereum`.

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

Then use it like you would in javascript.
