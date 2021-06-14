import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethereum Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String address = '';
  bool get isConnected => ethereum != null && ethereum!.isConnected();

  connect() async {
    if (ethereum != null) address = (await ethereum!.requestAccount()).first;
    setState(() {});
  }

  @override
  void initState() {
    if (ethereum != null) {
      ethereum!.onAccountsChanged((accounts) {
        if (accounts.isNotEmpty)
          address = accounts.first;
        else
          address = '';
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
                'you are currently ${isConnected ? 'connected' : 'not connected'}'),
            Text('your address is ${address.isNotEmpty ? address : 'xxx'}'),
          ],
        ),
      ),
    );
  }
}
