library flutter_web3_provider;

import 'ethereum.dart';
import 'ethers.dart';

export 'ethereum.dart';
export 'ethers.dart';

Web3Provider? getWeb3Provider() {
  final Ethereum? provider = ethereum ?? binanceChain ?? web3;
  if (provider != null) {
    return Web3Provider(ethereum!);
  }
}
