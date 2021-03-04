@JS("window")
library ethereum;

import 'package:js/js.dart';

// @JS()
external Ethereum get ethereum;

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

  @JS("on")
  external Future on(String eventName, Function func);

  @JS("autoRefreshOnNetworkChange")
  external set autoRefreshOnNetworkChange(bool b);
}

@JS()
@anonymous
class RequestParams {
  external String get method;
  external List<dynamic> get params;

  // Must have an unnamed factory constructor with named arguments.
  external factory RequestParams({String? method, List<dynamic>? params});
}
