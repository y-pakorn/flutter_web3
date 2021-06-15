@JS("window")
library ethereum;

import 'package:js/js.dart';

import 'ethereum_wrapper.dart';

/// Getter for default Ethereum object, cycles through available injector in environment.
Ethereum? get ethereum => _ethereum ?? _binanceChain;

@deprecated
@JS("web3")
external Ethereum? get web3;

@JS("BinanceChain")
external Ethereum? get _binanceChain;

@JS("ethereum")
external Ethereum? get _ethereum;

/// Convert JavaScript object or value to a JSON string,
///
/// optionally replacing values if a replacer function is specified or optionally including only the specified properties if a replacer array is specified.
@JS("JSON.stringify")
external String stringify(dynamic obj);

@JS()
class Ethereum {
  external set autoRefreshOnNetworkChange(bool b);

  /// Returns a hexadecimal string representing the current chain ID.
  ///
  /// Deprecated, Consider using [getChainId]
  @deprecated
  external String get chainId;

  /// Returns first [getAccounts] item but may return unexpected value.
  ///
  /// Deprecated, Consider using [getAccounts] instead.
  @deprecated
  external String? get selectedAddress;

  /// Returns true if the provider is connected to the current chain, and false otherwise.
  ///
  /// Note that this method has nothing to do with the user's accounts.
  ///
  /// You may often encounter the word "connected" in reference to whether a web3 site can access the user's accounts. In the provider interface, however, "connected" and "disconnected" refer to whether the provider can make RPC requests to the current chain.
  external bool isConnected();

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  external int listenerCount([String? eventName]);

  /// Returns the list of Listeners for the [eventName] events.
  external List<dynamic> listeners(String eventName);

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  external removeAllListeners([String? eventName]);
}
