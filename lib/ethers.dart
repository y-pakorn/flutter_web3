@JS("ethers")
library ethers;

import 'package:js/js.dart';

import 'ethereum.dart';

@JS("providers.Web3Provider")
class Web3Provider {
  external Web3Provider(Ethereum eth);

  @JS("getSigner")
  external Signer getSigner();

  @JS("getBalance")
  external Future getBalance(String address);

  @JS("getNetwork")
  external Future<Network> getNetwork();
}

@JS("providers.JsonRpcProvider")
class JsonRpcProvider {
  external JsonRpcProvider(String rpcUrl);

  @JS("getBalance")
  external Future getBalance(String address);
}

@JS("networks.Network")
class Network {
  @JS("chainId")
  external int get chainId;
}

@JS("signer.Signer")
class Signer {
  @JS("getAddress")
  external Future getAddress();

  @JS("sendTransaction")
  external Future sendTransaction(TxParams params);

  @JS("signMessage")
  external Future signMessage(String message);
}

@JS("utils")
class Utils {
  external static String verifyMessage(var hash, var sig);

  external static String arrayify(var hash);

  external static String getAddress(var address);
}

@JS("BigNumber")
class BigNumber {
  external static BigNumber from(String num);
}

@JS()
@anonymous
class TxParams {
  external String get method;

  external String get to;

  external String get value;

  external String get gasLimit;

  external String get gasPrice;

  external String get nonce;

  // Must have an unnamed factory constructor with named arguments.
  external factory TxParams(
      {String? to,
      String? value,
      String? gasLimit,
      String? gasPrice,
      String? nonce});
}

// I couldn't figure out how to call any ol' function with this package:js stuff
// so I'm just adding the most common functions from ERC20 and ERC721.
// To call other functions, use `callMethod`, see README for example.
@JS("Contract")
class Contract {
  external Contract(String address, List<String> abi, dynamic provider);

  @JS("name")
  external Future<String> name();

  @JS("symbol")
  external Future<String> symbol();

  @JS("connect")
  external Contract connect(Signer signer);

  @JS("transfer")
  external Future transfer(String to, String amount);

  @JS("balanceOf")
  external Future balanceOf(String address);

  @JS("tokenURI")
  external Future tokenURI(BigNumber tokenID);

  /// Return the number of listeners that are subscribed to event. If no event is provided, returns the total count of all events.
  @JS("listenerCount")
  external Future listenerCount(String eventName);

  /// Return a list of listeners that are subscribed to event.
  @JS("listeners")
  external Future listeners();

  /// Subscribe to event calling listener when the event occurs.
  @JS("on")
  external Future on(String eventName, Function func);

  /// Subscribe once to event calling listener when the event occurs.
  @JS("once")
  external Future once(String eventName, Function func);

  /// Unsubscribe listener to event.
  @JS("off")
  external Future off(String eventName, Function func);

  /// Unsubscribe all listeners for event. If no event is provided, all events are unsubscribed.
  @JS("removeAllListeners")
  external Future removeAllListeners(List<String>? events);
}
