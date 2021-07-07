@JS()
library flutter_web3.internal.object.js;

import 'dart:core';

import 'package:js/js.dart';

import '../ethereum/ethereum.dart';
import '../ethers/ethers.dart';

@JS()
@anonymous
class ChainParams {
  external factory ChainParams({
    required String chainId,
    required String chainName,
    required CurrencyParams nativeCurrency,
    required List<String> rpcUrls,
    List<String>? blockExplorerUrls,
  });

  external List<String> get blockExplorerUrls;

  external String get chainId;

  external String get chainName;

  external CurrencyParams get nativeCurrency;

  external List<String> get rpcUrls;
}

/// Interface for connection info used by [Ethereum] method.
@JS()
@anonymous
class ConnectInfo {
  /// Chain id in hex that is currently connected to.
  external String get chainId;
}

@JS()
@anonymous
class CurrencyParams {
  external factory CurrencyParams({
    required String name,
    required String symbol,
    required int decimals,
  });

  external int get decimals;

  external String get name;

  external String get symbol;
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
class TxOverride {
  external factory TxOverride({
    String? value,
    String? gasLimit,
    String? gasPrice,
    String? nonce,
  });

  /// The maximum amount of gas this transaction is permitted to use.
  external String get gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  external String get gasPrice;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  external String get nonce;

  /// The amount (in wei) this transaction is sending.
  external String get value;
}
