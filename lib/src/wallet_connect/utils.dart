part of wallet_connect_provider;

/// Function to convert Dart rpc map into JS rpc map.
dynamic _convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);
