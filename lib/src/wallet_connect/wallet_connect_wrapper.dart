import 'package:js/js_util.dart';

import 'wallet_connect.dart';

extension WalletConnectExtension on WalletConnectProvider {
  ///  Enable session (triggers QR Code modal)
  Future<void> connect() => promiseToFuture(callMethod(this, 'enable', []));

  /// Close provider session
  Future<void> disconnect() =>
      promiseToFuture(callMethod(this, 'disconnect', []));
}

//class UserClosedModalException implements Exception {}

//class NoRPCAvailableException implements Exception {
//final int chainId;

//NoRPCAvailableException({required this.chainId});
//}

/// Function to convert Dart rpc map into JS rpc map.
dynamic convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);
