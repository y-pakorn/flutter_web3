@JS("window")
library ethereum;

import 'package:js/js.dart';

@JS("ethereum")
external Ethereum? get ethereum;

@JS("BinanceChain")
external Ethereum? get binanceChain;

@JS("web3")
external Ethereum? get web3;

// LEGACY
// @JS("web3")
// external Ethereum get web3Legacy;

@JS("")
class Ethereum {
  @JS("chainId")
  external String chainId();

  @JS("isConnected")
  external bool isConnected();

  @JS("selectedAddress")
  external String get selectedAddress;

  @JS("request")
  external Future request(RequestParams params);

  /// Add a listener to be triggered for each eventName event.
  @JS("on")
  external Future on(String eventName, Function func);

  /// Add a listener to be triggered for only the next eventName event, at which time it will be removed.
  @JS("once")
  external Future once(String eventName, Function func);

  /// Add a listener to be triggered for only the next eventName event, at which time it will be removed.
  @JS("off")
  external Future off(String eventName, Function func);

  /// Add a listener to be triggered for only the next eventName event, at which time it will be removed.
  @JS("removeAllListeners")
  external Future removeAllListeners(String? events);

  /// Return the number of listeners that are subscribed to event. If no event is provided, returns the total count of all events.
  @JS("listenerCount")
  external Future listenerCount(String eventName);

  /// Return a list of listeners that are subscribed to event.
  @JS("listeners")
  external Future listeners();

  @JS("autoRefreshOnNetworkChange")
  external set autoRefreshOnNetworkChange(bool b);
}

@JS()
@anonymous
class RequestParams {
  external String get method;

  external List<dynamic> get params;

  // Must have an unnamed factory constructor with named arguments.
  external factory RequestParams({String? method, dynamic params});
}

@JS("JSON.stringify")
external String stringify(dynamic obj);

@JS()
@anonymous
class CurrencyParams {
  external String get name;

  external String get symbol;

  external int get decimals;

  external factory CurrencyParams({String name, String symbol, int decimals});
}

@JS()
@anonymous
class ChainParams {
  external String get chainId;

  external String get chainName;

  external CurrencyParams get nativeCurrency;

  external List<String> get rpcUrls;

  external List<String> get blockExplorerUrls;

  external factory ChainParams(
      {String chainId,
      String chainName,
      CurrencyParams nativeCurrency,
      List<String> rpcUrls,
      List<String> blockExplorerUrls});
}
