part of ethereum;

@internal
@JS()
@anonymous
class EthereumBaseImpl {
  /// Returns a hexadecimal string representing the current chain ID.
  ///
  /// Deprecated, Consider using [getChainId]
  @deprecated
  external String get chainId;

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  external int listenerCount([String? eventName]);

  /// Returns the list of Listeners for the [eventName] events.
  external List<dynamic> listeners(String eventName);

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  external removeAllListeners([String? eventName]);
}

/// Interface for provier message used by [Ethereum] method.
@JS()
@anonymous
class ProviderMessage {
  /// The data of the message.
  external dynamic get data;

  /// The type of the message.
  ///
  /// If you create a subscription using `eth_subscribe`, each subscription update will be emitted as a message event with a type of `eth_subscription`.
  external String get type;
}

/// Interface for provier error used by [Ethereum] method.
@JS()
@anonymous
class ProviderRpcError {
  external int get code;

  external dynamic get data;

  external String get message;
}

@JS()
@anonymous
class _EthereumImpl extends EthereumBaseImpl {
  external set autoRefreshOnNetworkChange(bool b);

  /// Returns first [getAccounts] item but may return unexpected value.
  ///
  /// Deprecated, Consider using [getAccounts] instead.
  @deprecated
  external String? get selectedAddress;

  /// Returns true if the provider is connected to the current chain, and false otherwise.
  ///
  /// Note that this method has nothing to do with the user's accounts.
  ///
  /// You may often encounter the word `connected` in reference to whether a web3 site can access the user's accounts. In the provider interface, however, `connected` and `disconnected` refer to whether the provider can make RPC requests to the current chain.
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

/// The specific information of the asset to watch.
@JS()
@anonymous
class _WatchAssetOptionsImpl {
  external factory _WatchAssetOptionsImpl({
    required String address,
    required String symbol,
    required int decimals,
    String? image,
  });

  /// The address of the token contract.
  external String get address;

  /// The number of token decimals.
  external int get decimals;

  /// A string url of the token logo.
  external String? get image;

  /// A ticker symbol or shorthand, up to 5 characters.
  external String get symbol;
}

/// The metadata of the asset to watch.
@JS()
@anonymous
class _WatchAssetParamsImpl {
  external factory _WatchAssetParamsImpl({
    required String type,
    required _WatchAssetOptionsImpl options,
  });

  /// Asset options.
  external _WatchAssetOptionsImpl get options;

  /// Asset type.
  ///
  /// In the future, other standards will be supported.
  external String get type;
}
