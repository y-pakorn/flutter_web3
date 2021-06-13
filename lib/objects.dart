@JS()
library flutter_web3.internal.object.js;

import 'dart:core';

import 'package:js/js.dart';

import 'ethers.dart';

@JS()
@anonymous
class Block {
  /// The maximum amount of gas that this block was permitted to use.
  ///
  /// This is a value that can be voted up or voted down by miners and is used to automatically adjust the bandwidth requirements of the network.
  external BigNumber get gasLimit;

  /// The total amount of gas used by all transactions in this block.
  external BigNumber get gasUsed;

  /// The coinbase address of this block, which indicates the address the miner that mined this block would like the subsidy reward to go to.
  external String get miner;

  /// This is extra data a miner may choose to include when mining a block.
  external String get extraData;

  /// A list of the transactions hashes for each transaction this block includes.
  external List<String> get transactions;

  /// The difficulty target required to be met by the miner of the block.
  external num get difficulty;

  /// The hash of this block.
  external String get hash;

  /// The nonce used as part of the proof-of-work to mine this block.
  external int get nounce;

  /// The height (number) of this block.
  external int get number;

  /// The hash of the previous block.
  external String get parentHash;

  /// The timestamp of this block.
  external int get timestamp;
}

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
  /// The address of the contract that generated this log.
  external String get address;

  /// The block hash of the block including the transaction of this log.
  external String get blockHash;

  /// The block height (number) of the block including the transaction of this log.
  external int get blockNumber;

  /// The data included in this log.
  external String get data;

  /// The index of this log in the transaction.
  external String get logIndex;

  /// During a re-org, if a transaction is orphaned, this will be set to true to indicate the Log entry has been removed;
  ///
  /// it will likely be emitted again in the near future when another block is mined with the transaction that triggered this log, but keep in mind the values may change.
  external bool get removed;

  /// The list of topics (indexed properties) for this log.
  external List<String> get topics;

  /// The transaction hash of the transaction of this log.
  external String get transactionHash;

  /// The index of the transaction in the block of the transaction of this log.
  external String get transactionIndex;

  /// The index of this log across all logs in the entire block.
  external int get transactionLogIndex;
}

@JS()
@anonymous
class Network {
  ///The Chain ID of the network.
  external int get chainId;

  ///The address at which the ENS registry is deployed on this network.
  external String? get ensAddress;

  ///The human-readable name of the network, such as homestead.
  ///
  ///If the network name is unknown, this will be "unknown".
  external String get name;
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
class RawTxParams {
  external factory RawTxParams({
    required String to,
    required String data,
  });

  /// The address (or ENS name) this transaction it to.
  external String get to;

  /// The transaction data.
  external String get data;
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

  /// The amount (in wei) this transaction is sending.
  external String get value;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  external String get nonce;
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

  /// The maximum amount of gas this transaction is permitted to use.
  external String get gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  external String get gasPrice;

  /// The amount (in wei) this transaction is sending.
  external String get value;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  external String get nonce;

  /// The address (or ENS name) this transaction it to.
  external String get to;

  external String get method;
}

@JS()
@anonymous
class TxReceipt {
  external String get blockHash;

  /// The block height (number) of the block that this transaction was included in.
  external int get blockNumber;

  /// This is true if the block is in a post-Byzantium Hard Fork block.
  external bool get byzantium;

  /// The number of blocks that have been mined since this transaction, including the actual block it was mined in.
  external int get confirmations;

  /// If this transaction has a null to address, it is an init transaction used to deploy a contract,
  /// in which case this is the address created by that contract.
  external String? get contractAddress;

  /// For the block this transaction was included in,
  /// this is the sum of the gas used by each transaction in the ordered list of transactions up to (and including) this transaction.
  ///
  /// This is generally of little interest to developers.
  external BigNumber get cumulativeGasUsed;

  /// The address this transaction is from.
  external String get from;

  /// The amount of gas actually used by this transaction.
  external BigNumber get gasUsed;

  /// All the logs emitted by this transaction.
  external List<Log> get logs;

  ///A bloom-filter, which includes all the addresses and topics included in any log in this transaction.
  external String get logsBloom;

  /// The intermediate state root of a receipt.
  ///
  /// Only transactions included in blocks before the Byzantium Hard Fork have this property, as it was replaced by the status property.
  ///
  /// The property is generally of little use to developers. At the time it could be used to verify a state transition with a fraud-proof only considering the single transaction; without it the full block must be considered.
  external String? get root;

  /// The status of a transaction is 1 is successful or 0 if it was reverted.
  ///
  /// Only transactions included in blocks post-Byzantium Hard Fork have this property.
  external int get status;

  /// The address this transaction is to.
  ///
  /// This is [null] if the transaction was an init transaction, used to deploy a contract.
  external String? get to;

  external String get transactionHash;

  /// The index of this transaction in the list of transactions included in the block this transaction was mined in.
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

  /// The address of the token contract
  external String get address;

  /// The number of token decimals
  external int get decimals;

  /// A string url of the token logo
  external String? get image;

  /// A ticker symbol or shorthand, up to 5 characters
  external String get symbol;
}

@JS()
@anonymous
class WatchAssetParams {
  external factory WatchAssetParams({
    required String type,
    required WatchAssetOptions options,
  });

  /// Asset options.
  external WatchAssetOptions get options;

  /// Asset type.
  ///
  /// In the future, other standards will be supported
  external String get type;
}
