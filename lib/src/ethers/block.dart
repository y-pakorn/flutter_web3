part of ethers;

class _RawBlock<T extends _RawBlockImpl> extends Interop<T> {
  const _RawBlock._(T impl) : super.internal(impl);

  /// The difficulty target required to be met by the miner of the block.
  num get difficulty => impl.difficulty;

  /// This is extra data a miner may choose to include when mining a block.
  String get extraData => impl.extraData;

  /// The maximum amount of gas that this block was permitted to use.
  ///
  /// This is a value that can be voted up or voted down by miners and is used to automatically adjust the bandwidth requirements of the network.
  BigInt get gasLimit => impl.gasLimit.toBigInt;

  /// The total amount of gas used by all transactions in this block.
  BigInt get gasUsed => impl.gasUsed.toBigInt;

  /// The hash of this block.
  String get hash => impl.hash;

  /// The coinbase address of this block, which indicates the address the miner that mined this block would like the subsidy reward to go to.
  String get miner => impl.miner;

  /// The nonce used as part of the proof-of-work to mine this block.
  int get nounce => impl.nounce;

  /// The height (number) of this block.
  int get number => impl.number;

  /// The hash of the previous block.
  String get parentHash => impl.parentHash;

  /// The timestamp of this block.
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(impl.timestamp * 1000);

  @override
  String toString() =>
      'Block: $number ${hash.substring(0, 10)} mined at ${timestamp.toIso8601String()} with diff $difficulty';
}

/// An object consist of basic information about block.
///
/// Often only the hashes of the transactions included in a block are needed, so by default a block only contains this information, as it is substantially less data.
class Block extends _RawBlock<_BlockImpl> {
  const Block._(_BlockImpl impl) : super._(impl);

  /// A list of the transactions hashes for each transaction this block includes.
  List<String> get transactions => impl.transactions.cast<String>();
}

/// An object consist of basic information about block.
///
/// If all transactions for a block are needed, this object instead includes the full details on each transaction.
class BlockWithTransaction extends _RawBlock<_BlockWithTransactionImpl> {
  const BlockWithTransaction._(_BlockWithTransactionImpl impl) : super._(impl);

  /// A list of the transactions this block includes.
  List<TransactionResponse> get transactions => impl.transactions
      .cast<_TransactionResponseImpl>()
      .map((e) => TransactionResponse._(e))
      .toList();
}
