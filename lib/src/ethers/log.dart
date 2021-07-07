part of ethers;

/// Information log of specific transaction.
class Log implements _LogImpl {
  final _LogImpl _impl;

  const Log._(this._impl);

  /// The address of the contract that generated this log.
  @override
  String get address => _impl.address;

  /// The block hash of the block including the transaction of this log.
  @override
  String get blockHash => _impl.address;

  /// The block height (number) of the block including the transaction of this log.
  @override
  int get blockNumber => _impl.blockNumber;

  /// The data included in this log.
  @override
  String get data => _impl.data;

  /// The index of this log in the transaction.
  @override
  String get logIndex => _impl.logIndex;

  /// During a re-org, if a transaction is orphaned, this will be set to true to indicate the Log entry has been removed;
  ///
  /// it will likely be emitted again in the near future when another block is mined with the transaction that triggered this log, but keep in mind the values may change.
  @override
  bool get removed => _impl.removed;

  /// The list of topics (indexed properties) for this log.
  @override
  List<String> get topics => _impl.topics.cast<String>();

  /// The transaction hash of the transaction of this log.
  @override
  String get transactionHash => _impl.transactionHash;

  /// The index of the transaction in the block of the transaction of this log.
  @override
  String get transactionIndex => _impl.transactionIndex;

  /// The index of this log across all logs in the entire block.
  @override
  int get transactionLogIndex => _impl.transactionLogIndex;
}
