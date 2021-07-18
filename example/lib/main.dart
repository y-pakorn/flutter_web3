import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      GetMaterialApp(title: 'Flutter Web3 Example', home: Home());
}

class HomeController extends GetxController {
  bool get isInOperatingChain => currentChain == OPERATING_CHAIN;

  bool get isConnected => Ethereum.isSupported && currentAddress.isNotEmpty;

  String currentAddress = '';

  int currentChain = -1;

  bool wcConnected = false;

  static const OPERATING_CHAIN = 56;

  final wc = WalletConnectProvider.binance();

  Web3Provider? web3wc;

  connectProvider() async {
    if (Ethereum.isSupported) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) {
        currentAddress = accs.first;
        currentChain = await ethereum!.getChainId();
      }

      update();
    }
  }

  connectWC() async {
    await wc.connect();
    if (wc.connected) {
      currentAddress = wc.accounts.first;
      currentChain = 56;
      wcConnected = true;
      web3wc = Web3Provider.fromWalletConnect(wc);
    }

    update();
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    wcConnected = false;
    web3wc = null;

    update();
  }

  init() {
    if (Ethereum.isSupported) {
      connectProvider();

      ethereum!.onAccountsChanged((accs) {
        clear();
      });

      ethereum!.onChainChanged((chain) {
        clear();
      });
    }
  }

  getLastestBlock() async {
    print(await provider!.getLastestBlock());
    print(await provider!.getLastestBlockWithTransaction());
  }

  testProvider() async {
    final rpcProvider = JsonRpcProvider('https://bsc-dataseed.binance.org/');
    print(rpcProvider);
    print(await rpcProvider.getNetwork());
  }

  test() async {}

  testSwitchChain() async {
    await ethereum!.walletSwitchChain(97, () async {
      await ethereum!.walletAddChain(
        chainId: 97,
        chainName: 'Binance Testnet',
        nativeCurrency:
            CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
        rpcUrls: ['https://data-seed-prebsc-1-s1.binance.org:8545/'],
      );
    });
  }

  @override
  void onInit() {
    init();

    super.onInit();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (h) => Scaffold(
        body: Center(
          child: Column(children: [
            Container(height: 10),
            Builder(builder: (_) {
              var shown = '';
              if (h.isConnected && h.isInOperatingChain)
                shown = 'You\'re connected!';
              else if (h.isConnected && !h.isInOperatingChain)
                shown = 'Wrong chain! Please connect to BSC. (56)';
              else if (Ethereum.isSupported)
                return OutlinedButton(
                    child: Text('Connect'), onPressed: h.connectProvider);
              else
                shown = 'Your browser is not supported!';

              return Text(shown,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
            }),
            Container(height: 30),
            if (h.isConnected && h.isInOperatingChain) ...[
              TextButton(
                  onPressed: h.getLastestBlock,
                  child: Text('get lastest block')),
              Container(height: 10),
              TextButton(
                  onPressed: h.testProvider,
                  child: Text('test binance rpc provider')),
              Container(height: 10),
              TextButton(onPressed: h.test, child: Text('test')),
              Container(height: 10),
              TextButton(
                  onPressed: h.testSwitchChain,
                  child: Text('test switch chain')),
            ],
            Container(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Wallet Connect connected: ${h.wcConnected}'),
                Container(width: 10),
                OutlinedButton(
                    child: Text('Connect to WC'), onPressed: h.connectWC)
              ],
            ),
            Container(height: 30),
            if (h.wcConnected && h.wc.connected) ...[
              Text(h.wc.walletMeta.toString()),
            ],
          ]),
        ),
      ),
    );
  }
}
