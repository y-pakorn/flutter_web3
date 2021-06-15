@JS()
library flutter_web3.internal.object.js;

import 'dart:core';

import 'package:js/js.dart';

import '../ethers/ethers.dart';

/// An EIP-2930 transaction allows an optional AccessList which causes a transaction to warm (i.e. pre-cache) another addresses state and the specified storage keys.
///
/// This incurs an increased intrinsic cost for the transaction, but provides discounts for storage and state access throughout the execution of the transaction.
@JS()
@anonymous
class AccessList {
  external String get address;
  external List<String> get storageKey;
}

/// Often only the hashes of the transactions included in a block are needed, so by default a block only contains this information, as it is substantially less data.
@JS()
@anonymous
class Block extends RawBlock {
  /// A list of the transactions hashes for each transaction this block includes.
  external List<String> get transactions;
}

/// If all transactions for a block are needed, this object instead includes the full details on each transaction.
@JS()
@anonymous
class BlockWithTransaction extends RawBlock {
  /// A list of the transactions this block includes.
  external List<TransactionResponse> get transactions;
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

/// A Network represents an Ethereum network.
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

/// An object consist of basic information about block.
@JS()
@anonymous
class RawBlock {
  /// The difficulty target required to be met by the miner of the block.
  external num get difficulty;

  /// This is extra data a miner may choose to include when mining a block.
  external String get extraData;

  /// The maximum amount of gas that this block was permitted to use.
  ///
  /// This is a value that can be voted up or voted down by miners and is used to automatically adjust the bandwidth requirements of the network.
  external BigNumber get gasLimit;

  /// The total amount of gas used by all transactions in this block.
  external BigNumber get gasUsed;

  /// The hash of this block.
  external String get hash;

  /// The coinbase address of this block, which indicates the address the miner that mined this block would like the subsidy reward to go to.
  external String get miner;

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
class RawTxParams {
  external factory RawTxParams({
    required String to,
    required String data,
  });

  /// The transaction data.
  external String get data;

  /// The address (or ENS name) this transaction it to.
  external String get to;
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

/// A generic object to represent a transaction.
@JS()
@anonymous
class Transaction {
  ///The chain ID for transaction. This is used as part of EIP-155 to prevent replay attacks on different networks.
  ///
  ///For example, if a transaction was made on ropsten with an account also used on homestead, it would be possible for a transaction signed on ropsten to be executed on homestead, which is likely unintended.
  ///
  ///There are situations where replay may be desired, however these are very rare and it is almost always recommended to specify the chain ID.
  external int get chainId;

  /// The data for transaction. In a contract this is the call data.
  external dynamic get data;

  /// The address transaction is from.
  external String get from;

  /// The gas limit for transaction.
  ///
  /// An account must have enough ether to cover the gas (at the specified gasPrice).
  ///
  /// Any unused gas is refunded at the end of the transaction, and if there is insufficient gas to complete execution, the effects of the transaction are reverted, but the gas is fully consumed and an out-of-gas error occurs.
  external BigNumber get gasLimit;

  /// The price (in wei) per unit of gas for transaction.
  external BigNumber get gasPrice;

  /// The transaction hash, which can be used as an identifier for transaction. This is the keccak256 of the serialized RLP encoded representation of transaction.
  external String get hash;

  /// The nonce for transaction.
  ///
  /// Each transaction sent to the network from an account includes this, which ensures the order and non-replayability of a transaction.
  ///
  /// This must be equal to the current number of transactions ever sent to the network by the from address.
  external int get nounce;

  /// The r portion of the elliptic curve signatures for transaction.
  ///
  /// This is more accurately, the x coordinate of the point r (from which the y can be computed, along with v).
  external String get r;

  /// The s portion of the elliptic curve signatures for transaction.
  external String get s;

  /// The address transaction is to.
  external String? get to;

  /// The v portion of the elliptic curve signatures for transaction.
  ///
  /// This is used to refine which of the two possible points a given x-coordinate can have, and in EIP-155 is additionally used to encode the chain ID into the serialized transaction.
  external int get v;

  /// The value (in wei) for transaction.
  external BigNumber get value;
}

@JS()
@anonymous
class TransactionReceipt {
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
  /// This is null if the transaction was an init transaction, used to deploy a contract.
  external String? get to;

  external String get transactionHash;

  /// The index of this transaction in the list of transactions included in the block this transaction was mined in.
  external int get transactionIndex;
}

/// A transaction request describes a transaction that is to be sent to the network or otherwise processed.
///
/// All fields are optional and may be a promise which resolves to the required type.
@JS()
@anonymous
class TransactionRequest {
  external factory TransactionRequest({
    String? to,
    String? value,
    String? gasLimit,
    String? gasPrice,
    String? nonce,
    String? data,
  });

  /// The transaction data.
  external String get data;

  /// The maximum amount of gas this transaction is permitted to use.
  external String get gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  external String get gasPrice;

  external String get method;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  external String get nonce;

  /// The address (or ENS name) this transaction it to.
  external String get to;

  /// The amount (in wei) this transaction is sending.
  external String get value;
}

/// A TransactionResponse includes all properties of a [Transaction] as well as several properties that are useful once it has been mined.
@JS()
@anonymous
class TransactionResponse extends Transaction {
  /// The AccessList included in an EIP-2930 transaction, which will also have its type equal to 1.
  external AccessList? get accessList;

  /// The hash of the block this transaction was mined in. If the block has not been mined, this is null.
  external String? get blockHash;

  /// The number ("height") of the block this transaction was mined in. If the block has not been mined, this is null.
  external int? get blockNumber;

  /// The number of blocks that have been mined (including the initial block) since this transaction was mined.
  external int get confirmations;

  /// The serialized transaction.
  external String get raw;

  /// The timestamp of the block this transaction was mined in. If the block has not been mined, this is null.
  external int? get timestamp;

  /// The EIP-2718 type of this transaction envelope, or null for legacy transactions that do not have an envelope.
  external int? get type;
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
