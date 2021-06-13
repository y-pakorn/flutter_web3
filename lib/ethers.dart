@JS("ethers")
library ethers;

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'ethereum.dart';
import 'objects.dart';

/// Getter for default Web3Provider object.
Web3Provider? get provider => ethereum != null ? Web3Provider(ethereum!) : null;

@JS("AbiCoder")
class AbiCoder {
  external String decode(List<String> types, String data);

  external String encode(List<String> types, List<dynamic> values);
}

@JS("BigNumber")
class BigNumber {
  external String toHexString();

  external String toString();

  external static BigNumber from(String num);
}

@JS("Contract")
class Contract {
  external Contract(String address, List<String> abi, dynamic providerOrSigner);

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  external int listenerCount([String? eventName]);

  /// Returns the list of Listeners for the [eventName] events.
  external List<dynamic> listeners(String eventName);

  /// Internal, use [offEvent] instead.
  @JS("off")
  @internal
  external off(String eventName, [Function? func]);

  /// Internal, use [onEvent] instead.
  @JS("on")
  @internal
  external on(String eventName, Function func);

  /// Internal, use [onceEvent] instead.
  @JS("once")
  @internal
  external once(String eventName, Function func);

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  external removeAllListeners([String? eventName]);

  //@JS("balanceOf")
  //external Future balanceOf(String address);

  //@JS("connect")
  //external Contract connect(Signer signer);

  //@JS("listenerCount")
  //external Future listenerCount(String eventName);

  //@JS("listeners")
  //external Future listeners();

  //@JS("name")
  //external Future<String> name();

  //@JS("off")
  //external Future off(String eventName, Function func);

  //@JS("on")
  //external Future on(String eventName, Function func);

  //@JS("once")
  //external Future once(String eventName, Function func);

  //@JS("removeAllListeners")
  //external Future removeAllListeners(String? events);

  //@JS("symbol")
  //external Future<String> symbol();

  //@JS("tokenURI")
  //external Future tokenURI(BigNumber tokenID);

  //@JS("transfer")
  //external Future transfer(String to, String amount);
}

@JS("providers.JsonRpcProvider")
class JsonRpcProvider extends Provider {
  external JsonRpcProvider(String rpcUrl);
}

@JS("providers")
class Provider {}

@JS("signer.Signer")
class Signer {
  external Future<dynamic> sendTransaction(TxParams params);

  external Future<String> signMessage(String message);

  external static bool isSigner(Object object);
}

@JS("utils")
class Utils {
  external static AbiCoder get defaultAbiCoder;

  external static String arrayify(var hash);

  external static String getAddress(var address);

  external static String verifyMessage(var hash, var sig);
}

@JS("providers.Web3Provider")
class Web3Provider extends Provider {
  external Web3Provider(Ethereum eth);

  external Signer getSigner();
}
