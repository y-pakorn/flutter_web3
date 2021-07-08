part of ethereum;

@JS()
@anonymous
class _ChainParamsImpl {
  external factory _ChainParamsImpl({
    required String chainId,
    required String chainName,
    required _CurrencyParamsImpl nativeCurrency,
    required List<String> rpcUrls,
    List<String>? blockExplorerUrls,
  });

  external List<String> get blockExplorerUrls;

  external String get chainId;

  external String get chainName;

  external CurrencyParams get nativeCurrency;

  external List<String> get rpcUrls;
}

@JS()
@anonymous
class _CurrencyParamsImpl {
  external factory _CurrencyParamsImpl({
    required String name,
    required String symbol,
    required int decimals,
  });

  external int get decimals;

  external String get name;

  external String get symbol;
}

@internal
@JS()
@anonymous
class EthereumBaseImpl {
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
