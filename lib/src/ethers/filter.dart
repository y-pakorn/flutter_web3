part of ethers;

class EventFilter<T extends _EventFilterImpl> extends Interop<T> {
  /// Instantiate [EventFilter] by providing [address] and [topics].
  factory EventFilter({String? address, List<dynamic>? topics}) =>
      EventFilter._(_EventFilterImpl(address: address, topics: topics));

  /// Instantiate [EventFilter] by providing [address] and [topics], same as [EventFilter] default constructor.
  factory EventFilter.create({String? address, List<dynamic>? topics}) =>
      EventFilter._(_EventFilterImpl(address: address, topics: topics));

  const EventFilter._(_EventFilterImpl impl) : super.internal(impl as T);

  /// The address to filter by, or `null` to match any address.
  String? get address => impl.address;

  set address(String? address) => impl.address = address;

  /// The topics to filter by or `null` to match any topics.
  ///
  /// Each entry represents an AND condition that must match, or may be null to match anything.
  ///
  /// If a given entry is an Array, then that entry is treated as an OR for any value in the entry.
  List<dynamic>? get topics => impl.topics;

  set topics(List<dynamic>? topics) => impl.topics = topics;

  @override
  String toString() => 'Filter: $address with $topics';
}

class Filter extends EventFilter<_FilterImpl> {
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

  Filter._(_FilterImpl impl) : super._(impl);

  /// The starting block (inclusive) to search for logs matching the filter criteria.
  dynamic get fromBlock => impl.fromBlock;

  /// "latest" - The most recently mined block
  /// "earliest" - Block #0
  /// "pending" - The block currently being prepared for mining; not all
  ///
  /// Or an [int] block number.
  /// Positive number mean block at that height. Negative mean block that many block ago.
  ///
  /// Or a Hex [String] block at that height.
  set fromBlock(blockTag) => impl.fromBlock = blockTag;

  /// The end block (inclusive) to search for logs matching the filter criteria.
  dynamic get toBlock => impl.toBlock;

  /// "latest" - The most recently mined block
  /// "earliest" - Block #0
  /// "pending" - The block currently being prepared for mining; not all
  ///
  /// Or an [int] block number.
  /// Positive number mean block at that height. Negative mean block that many block ago.
  ///
  /// Or a Hex [String] block at that height.
  set toBlock(blockTag) => impl.toBlock = blockTag;

  @override
  String toString() => '${super.toString()} from $fromBlock to $toBlock';
}
