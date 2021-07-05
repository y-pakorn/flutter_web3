import 'package:js/js_util.dart';

import '../ethereum/ethereum_utils.dart';
import 'wallet_connect.dart';

/// Function to convert Dart rpc map into JS rpc map.
dynamic convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);

extension WalletConnectExtension on WalletConnectProvider {
  ///  Enable session (triggers QR Code modal)
  Future<void> connect() => promiseToFuture(callMethod(this, 'enable', []));

  /// Close provider session
  Future<void> disconnect() =>
      promiseToFuture(callMethod(this, 'disconnect', []));

  Map<int, String> get rpc => (convertToDart(getProperty(this, 'rpc')) as Map)
      .map((key, value) => MapEntry(int.parse(key), value.toString()));
}
