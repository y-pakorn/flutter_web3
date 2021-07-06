part of ethereum;

@internal
@JS()
@anonymous
class EthereumBaseImpl {
  @deprecated
  external String get chainId;

  external int listenerCount([String? eventName]);

  external List<dynamic> listeners(String eventName);

  external removeAllListeners([String? eventName]);
}

@JS()
@anonymous
class _EthereumImpl extends EthereumBaseImpl {
  external set autoRefreshOnNetworkChange(bool b);

  @deprecated
  external String? get selectedAddress;

  external bool isConnected();
}

@JS()
@anonymous
class _RequestArgumentsImpl {
  external factory _RequestArgumentsImpl({
    required String method,
    dynamic params,
  });

  external String get method;

  external dynamic get params;
}

@JS()
@anonymous
class _WatchAssetOptionsImpl {
  external factory _WatchAssetOptionsImpl({
    required String address,
    required String symbol,
    required int decimals,
    String? image,
  });

  external String get address;

  external int get decimals;

  external String? get image;

  external String get symbol;
}

@JS()
@anonymous
class _WatchAssetParamsImpl {
  external factory _WatchAssetParamsImpl({
    required String type,
    required _WatchAssetOptionsImpl options,
  });

  external _WatchAssetOptionsImpl get options;

  external String get type;
}
