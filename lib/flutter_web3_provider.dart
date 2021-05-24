library flutter_web3_provider;

import 'ethereum.dart';
import 'ethers.dart';

export 'ethereum.dart';
export 'ethers.dart';

Web3Provider? getWeb3Provider() {
  if (ethereum != null) {
    Web3Provider web3 = Web3Provider(ethereum!);
    return web3;
  }
}
