import 'package:js/js_util.dart';

import 'wallet_connect.dart';

extension WalletConnectExtension on WalletConnectProvider {
  ///  Enable session (triggers QR Code modal)
  Future<void> connect() async {
    try {
      await promiseToFuture(callMethod(this, 'enable', []));
    } catch (error) {
      //if (error.toString().contains('User closed'))
      //throw UserClosedModalException();
      //else if (error.toString().contains('No RPC Url'))
      //throw NoRPCAvailableException(
      //chainId: int.parse(error.toString().split(' ').last));
      //else
      rethrow;
    }
  }

  /// Close provider session
  Future<void> disconnect() =>
      promiseToFuture(callMethod(this, 'disconnect', []));

  //List<String> get accounts =>
  //(callMethod(this, 'accounts', []) as List<dynamic>)
  //.map((e) => e.toString())
  //.toList();
}

//class UserClosedModalException implements Exception {}

//class NoRPCAvailableException implements Exception {
//final int chainId;

//NoRPCAvailableException({required this.chainId});
//}

/// Function to convert Dart rpc map into JS rpc map.
dynamic convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);
