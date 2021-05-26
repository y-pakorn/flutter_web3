library flutter_web3_provider;

import 'ethereum.dart';
import 'ethers.dart';

export 'ethereum.dart';
export 'ethers.dart';

Ethereum? getEthereum() {
  return ethereum ?? binanceChain ?? web3;
}

Web3Provider? getWeb3Provider() {
  final Ethereum? provider = getEthereum();
  if (provider != null) {
    return Web3Provider(ethereum!);
  }
}
