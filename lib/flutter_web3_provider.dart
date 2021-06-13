import 'dart:convert';

import 'ethereum.dart';
import 'ethers.dart';

export 'ethereum.dart';
export 'ethereum_wrapper.dart';
export 'ethers.dart';
export 'objects.dart';

dynamic convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));

Web3Provider? get web3 {
  final Ethereum? provider = ethereum;
  if (provider != null) {
    return Web3Provider(ethereum!);
  }
}
