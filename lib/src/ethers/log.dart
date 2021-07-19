part of ethers;

/// Information log of specific transaction.
class Log<T extends _LogImpl> extends Interop<T> {
  const Log._(_LogImpl impl) : super.internal(impl as T);

  /// The address of the contract that generated this log.
  String get address => impl.address;

  /// The block hash of the block including the transaction of this log.
  String get blockHash => impl.address;

  /// The block height (number) of the block including the transaction of this log.
  int get blockNumber => impl.blockNumber;

  /// The data included in this log.
  String get data => impl.data;

  /// The index of this log in the transaction.
  String get logIndex => impl.logIndex;

  /// During a re-org, if a transaction is orphaned, this will be set to true to indicate the Log entry has been removed;
  ///
  /// it will likely be emitted again in the near future when another block is mined with the transaction that triggered this log, but keep in mind the values may change.
  bool get removed => impl.removed;

  /// The list of topics (indexed properties) for this log.
  List<String> get topics => impl.topics.cast<String>();

  /// The transaction hash of the transaction of this log.
  String get transactionHash => impl.transactionHash;

  /// The index of the transaction in the block of the transaction of this log.
  String get transactionIndex => impl.transactionIndex;

  /// The index of this log across all logs in the entire block.
  int get transactionLogIndex => impl.transactionLogIndex;

  @override
  String toString() =>
      'Log: ${topics.length} topics from ${transactionHash.substring(0, 10)}';
}
