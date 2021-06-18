import 'package:js/js_util.dart';

import 'wallet_connect.dart';

extension WalletConnectExtension on WalletConnectProvider {
  ///  Enable session (triggers QR Code modal)
  Future<void> connect() => promiseToFuture(callMethod(this, 'enable', []));

  /// Close provider session
  Future<void> disconnect() =>
      promiseToFuture(callMethod(this, 'disconnect', []));
}

/// Function to convert Dart rpc map into JS rpc map.
dynamic convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);
