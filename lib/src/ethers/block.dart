part of ethers;

class _RawBlock implements _RawBlockImpl {
  final _RawBlockImpl _rawImpl;

  const _RawBlock._(this._rawImpl);

  /// The difficulty target required to be met by the miner of the block.
  @override
  num get difficulty => _rawImpl.difficulty;

  /// This is extra data a miner may choose to include when mining a block.
  @override
  String get extraData => _rawImpl.extraData;

  /// The maximum amount of gas that this block was permitted to use.
  ///
  /// This is a value that can be voted up or voted down by miners and is used to automatically adjust the bandwidth requirements of the network.
  @override
  BigInt get gasLimit => (_rawImpl.gasLimit as BigNumber).toBigInt;

  /// The total amount of gas used by all transactions in this block.
  @override
  BigInt get gasUsed => (_rawImpl.gasUsed as BigNumber).toBigInt;

  /// The hash of this block.
  @override
  String get hash => _rawImpl.hash;

  /// The coinbase address of this block, which indicates the address the miner that mined this block would like the subsidy reward to go to.
  @override
  String get miner => _rawImpl.miner;

  /// The nonce used as part of the proof-of-work to mine this block.
  @override
  int get nounce => _rawImpl.nounce;

  /// The height (number) of this block.
  @override
  int get number => _rawImpl.number;

  /// The hash of the previous block.
  @override
  String get parentHash => _rawImpl.parentHash;

  /// The timestamp of this block.
  @override
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(_rawImpl.timestamp * 1000);

  @override
  String toString() =>
      'Block: $hash mined at ${timestamp.toIso8601String()} with diff $difficulty';
}

/// An object consist of basic information about block.
///
/// Often only the hashes of the transactions included in a block are needed, so by default a block only contains this information, as it is substantially less data.
class Block extends _RawBlock implements _BlockImpl {
  final _BlockImpl _impl;

  const Block._(this._impl) : super._(_impl);

  /// A list of the transactions hashes for each transaction this block includes.
  @override
  List<String> get transactions => _impl.transactions.cast<String>();
}

/// An object consist of basic information about block.
///
/// If all transactions for a block are needed, this object instead includes the full details on each transaction.
class BlockWithTransaction extends _RawBlock
    implements _BlockWithTransactionImpl {
  final _BlockWithTransactionImpl _impl;

  const BlockWithTransaction._(this._impl) : super._(_impl);

  /// A list of the transactions this block includes.
  @override
  List<TransactionResponse> get transactions => _impl.transactions
      .cast<_TransactionResponseImpl>()
      .map((e) => TransactionResponse._(e))
      .toList();
}
