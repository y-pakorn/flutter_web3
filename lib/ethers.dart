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
}

@JS()
@anonymous
class TxParams {
  external String get method;

  // Must have an unnamed factory constructor with named arguments.
  external factory TxParams({String to, String value});
}

@JS("Contract")
class Contract {
  external Contract(String address, List<String> abi, Web3Provider provider);

  @JS("symbol")
  external Future<String> symbol();

  @JS("connect")
  external Contract connect(Signer signer);

  @JS("transfer")
  external Future transfer(String to, String amount);
}
