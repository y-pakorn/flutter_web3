@JS()
library flutter_web_3_provider.internal.js;

import 'dart:core';

import 'package:js/js.dart';

import 'ethers.dart';

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

@JS()
@anonymous
class Log {
  external factory Log({
    int blockNumber,
    String blockHash,
    bool removed,
    int transactionLogIndex,
    String address,
    String data,
    List<String> topics,
    String transactionHash,
    String transactionIndex,
    String logIndex,
  });
  external String get address;
  external String get blockHash;
  external int get blockNumber;
  external String get data;
  external String get logIndex;
  external bool get removed;
  external List<String> get topics;
  external String get transactionHash;
  external String get transactionIndex;

  external int get transactionLogIndex;
}

@JS()
@anonymous
class RequestArguments {
  external factory RequestArguments({
    required String method,
    dynamic params,
  });

  external String get method;

  external dynamic get params;
}

@JS()
@anonymous
class TxParams {
  external factory TxParams({
    String? to,
    String? value,
    String? gasLimit,
    String? gasPrice,
    String? nonce,
  });

  external String get gasLimit;

  external String get gasPrice;

  external String get method;

  external String get nonce;

  external String get to;

  external String get value;
}

@JS()
@anonymous
class TxReceipt {
  external factory TxReceipt({
    String to,
    String from,
    String contractAddress,
    int transactionIndex,
    String root,
    BigNumber gasUsed,
    String logsBloom,
    String blockHash,
    String transactionHash,
    List<Log> logs,
    int blockNumber,
    int confirmations,
    BigNumber cumulativeGasUsed,
    bool byzantium,
    int status,
  });
  external String get blockHash;
  external int get blockNumber;
  external bool get byzantium;
  external int get confirmations;
  external String? get contractAddress;
  external BigNumber get cumulativeGasUsed;
  external String get from;
  external BigNumber get gasUsed;
  external List<Log> get logs;
  external String get logsBloom;
  external String? get root;
  external int get status;
  external String? get to;
  external String get transactionHash;

  external int get transactionIndex;
}

@JS()
@anonymous
class WatchAssetOptions {
  external factory WatchAssetOptions({
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
class WatchAssetParams {
  external factory WatchAssetParams({
    required String type,
    required WatchAssetOptions options,
  });

  external WatchAssetOptions get options;

  external String get type;
}
