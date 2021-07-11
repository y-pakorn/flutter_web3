part of ethers;

class EventFilter implements _EventFilterImpl {
  final _EventFilterImpl _eventImpl;

  /// Instantiate [EventFilter] by providing [address] and [topics].
  factory EventFilter({String? address, List<dynamic>? topics}) =>
      EventFilter._(_EventFilterImpl(address: address, topics: topics));

  /// Instantiate [EventFilter] by providing [address] and [topics], same as [EventFilter] default constructor.
  factory EventFilter.create({String? address, List<dynamic>? topics}) =>
      EventFilter._(_EventFilterImpl(address: address, topics: topics));

  EventFilter._(this._eventImpl);

  /// The address to filter by, or `null` to match any address.
  @override
  String? get address => _eventImpl.address;

  @override
  set address(String? address) => _eventImpl.address = address;

  /// The topics to filter by or `null` to match any topics.
  ///
  /// Each entry represents an AND condition that must match, or may be null to match anything.
  ///
  /// If a given entry is an Array, then that entry is treated as an OR for any value in the entry.
  @override
  List<dynamic>? get topics => _eventImpl.topics;

  @override
  set topics(List<dynamic>? topics) => _eventImpl.topics = topics;

  @override
  String toString() => 'Filter: $address with $topics';
}

class Filter extends EventFilter implements _FilterImpl {
  final _FilterImpl _impl;

  /// Instantiate [Filter] by providing [address], [topics], [toBlock], and [endBlock].
  factory Filter({
    String? address,
    List<dynamic>? topics,
    dynamic toBlock,
    dynamic fromBlock,
  }) =>
      Filter._(_FilterImpl(
        address: address,
        topics: topics,
        fromBlock: fromBlock,
        toBlock: toBlock,
      ));

  /// Instantiate [Filter] by providing [address], [topics], [toBlock], and [endBlock], same as [Filter] default constructor.
  factory Filter.create({
    String? address,
    List<dynamic>? topics,
    dynamic toBlock,
    dynamic fromBlock,
  }) =>
      Filter._(_FilterImpl(
        address: address,
        topics: topics,
        fromBlock: fromBlock,
        toBlock: toBlock,
      ));

  Filter._(this._impl) : super._(_impl);

  /// The starting block (inclusive) to search for logs matching the filter criteria.
  @override
  dynamic get fromBlock => _impl.fromBlock;

  /// "latest" - The most recently mined block
  /// "earliest" - Block #0
  /// "pending" - The block currently being prepared for mining; not all
  ///
  /// Or an [int] block number.
  /// Positive number mean block at that height. Negative mean block that many block ago.
  ///
  /// Or a Hex [String] block at that height.
  @override
  set fromBlock(blockTag) => _impl.fromBlock = blockTag;

  /// The end block (inclusive) to search for logs matching the filter criteria.
  @override
  dynamic get toBlock => _impl.toBlock;

  /// "latest" - The most recently mined block
  /// "earliest" - Block #0
  /// "pending" - The block currently being prepared for mining; not all
  ///
  /// Or an [int] block number.
  /// Positive number mean block at that height. Negative mean block that many block ago.
  ///
  /// Or a Hex [String] block at that height.
  @override
  set toBlock(blockTag) => _impl.toBlock = blockTag;

  @override
  String toString() => '${super.toString()} from $fromBlock to $toBlock';
}
