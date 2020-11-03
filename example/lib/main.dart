import 'dart:js_util';

import 'package:decimal/decimal.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
const goUsdcAddress = '0x97a19aD887262d7Eca45515814cdeF75AcC4f713';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String selectedAddress;
  Web3Provider web3;
  TextEditingController _controller;
  TextEditingController _verifyController;
  Future balanceF;
  Future usdcBalanceF;

  @override
  void initState() {
    super.initState();
    if (ethereum != null) {
      web3 = Web3Provider(ethereum);
      balanceF = promiseToFuture(web3.getBalance(ethereum.selectedAddress));
      var contract = Contract(goUsdcAddress, erc20Abi, web3);
      usdcBalanceF = promiseToFuture(
          callMethod(contract, "balanceOf", [ethereum.selectedAddress]));
    }
    _controller = TextEditingController();
    _verifyController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _verifyController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            connectedStuff(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget connectedStuff() {
    if (ethereum == null) {
      return Text("Dapp Browser not found");
    }
    return Column(
      children: [
        (selectedAddress != null)
            ? Text(selectedAddress)
            : RaisedButton(
                child: Text("Connect Wallet"),
                onPressed: () async {
                  var accounts = await promiseToFuture(ethereum
                      .request(RequestParams(method: 'eth_requestAccounts')));
                  print(accounts);
                  String se = ethereum.selectedAddress;
                  print("selectedAddress: $se");
                  setState(() {
                    selectedAddress = se;
                  });
                },
              ),
        SizedBox(height: 10),
        Text("Native balance:"),
        FutureBuilder(
          future: balanceF,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var big = BigInt.parse(snapshot.data.toString());
            var d = toDecimal(big, 18);
            return Text("${d}");
          },
        ),
        SizedBox(height: 10),
        Text("GO:USDC balance:"),
        FutureBuilder(
          future: usdcBalanceF,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var big = BigInt.parse(snapshot.data.toString());
            var d = toDecimal(big, 6);
            return Text("${d}");
          },
        ),
        RaisedButton(
          child: Text("Transfer \$0.01"),
          onPressed: () async {
            var contract = Contract(goUsdcAddress, erc20Abi, web3);
            var contract2 = contract.connect(web3.getSigner());
            try {
              // DEPRECATED:
              // var res = await promiseToFuture(contract2.transfer(
              //     '0x39C5190c09ec04cF09C782bA4311C469473Ffe83',
              //     "0x" +
              //         BigInt.parse(toBase(Decimal.parse("0.01"), 6).toString())
              //             .toRadixString(16)));
              // USE THIS INSTEAD:
              var res =
                  await promiseToFuture(callMethod(contract2, "transfer", [
                '0x39C5190c09ec04cF09C782bA4311C469473Ffe83',
                "0x" +
                    BigInt.parse(toBase(Decimal.parse("0.01"), 6).toString())
                        .toRadixString(16)
              ]));
              print("Transferred: ${res.toString()}");
            } catch (e) {
              print("EXCEPTION:" + e.toString());
            }
            // setState(() {
            //   _controller.text = signature;
            // });
          },
        ),
        SizedBox(height: 10),
        RaisedButton(
          child: Text("Sign Message"),
          onPressed: () async {
            var signature = await promiseToFuture(
                web3.getSigner().signMessage("Sign this message"));
            print(signature);
            setState(() {
              _controller.text = signature;
            });
          },
        ),
        Text("Signature:"),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            // labelText: 'Password',
          ),
          controller: _controller,
        ),
        RaisedButton(
          child: Text("Verify Signature"),
          onPressed: () async {
            var verified =
                Utils.verifyMessage("Sign this message", _controller.text);
            print(verified);
            setState(() {
              _verifyController.text = verified;
            });
          },
        ),
        Text("Verified Address"),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            // labelText: 'Password',
          ),
          controller: _verifyController,
        ),
      ],
    );
  }
}
