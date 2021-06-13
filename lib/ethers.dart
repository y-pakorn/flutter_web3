@JS("ethers")
library ethers;

import 'package:js/js.dart';

import 'ethereum.dart';
import 'objects.dart';

@JS("AbiCoder")
class AbiCoder {
  @JS("decode")
  external String decode(List<String> types, String data);

  @JS("encode")
  external String encode(List<String> types, List<dynamic> values);
}

@JS("BigNumber")
class BigNumber {
  external static BigNumber from(String num);
}

@JS("Contract")
class Contract {
  external Contract(String address, List<String> abi, dynamic provider);

  @JS("balanceOf")
  external Future balanceOf(String address);

  @JS("connect")
  external Contract connect(Signer signer);

  /// Return the number of listeners that are subscribed to event. If no event is provided, returns the total count of all events.
  @JS("listenerCount")
  external Future listenerCount(String eventName);

  /// Return a list of listeners that are subscribed to event.
  @JS("listeners")
  external Future listeners();

  @JS("name")
  external Future<String> name();

  /// Unsubscribe listener to event.
  @JS("off")
  external Future off(String eventName, Function func);

  /// Subscribe to event calling listener when the event occurs.
  @JS("on")
  external Future on(String eventName, Function func);

  /// Subscribe once to event calling listener when the event occurs.
  @JS("once")
  external Future once(String eventName, Function func);

  /// Unsubscribe all listeners for event. If no event is provided, all events are unsubscribed.
  @JS("removeAllListeners")
  external Future removeAllListeners(String? events);

  @JS("symbol")
  external Future<String> symbol();

  @JS("tokenURI")
  external Future tokenURI(BigNumber tokenID);

  @JS("transfer")
  external Future transfer(String to, String amount);
}

@JS("providers.JsonRpcProvider")
class JsonRpcProvider extends Provider {
  external JsonRpcProvider(String rpcUrl);

  @JS("getBalance")
  external Future<BigNumber> getBalance(String address);
}

@JS("networks.Network")
class Network {
  @JS("chainId")
  external int get chainId;
}

@JS("providers")
class Provider {
  @JS("waitForTransaction")
  external Future<TxReceipt> waitForTransaction(
    String hash, [
    int confirms = 1,
  ]);
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
  @JS("defaultAbiCoder")
  external static AbiCoder get defaultAbiCoder;

  external static String arrayify(var hash);

  external static String getAddress(var address);

  external static String verifyMessage(var hash, var sig);
}

// I couldn't figure out how to call any ol' function with this package:js stuff
// so I'm just adding the most common functions from ERC20 and ERC721.
// To call other functions, use `callMethod`, see README for example.
@JS("providers.Web3Provider")
class Web3Provider extends Provider {
  external Web3Provider(Ethereum eth);

  @JS("getBalance")
  external Future<BigNumber> getBalance(String address);

  @JS("getNetwork")
  external Future<Network> getNetwork();

  @JS("getSigner")
  external Signer getSigner();
}
