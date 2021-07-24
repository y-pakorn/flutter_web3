/// A BlockTag specifies a specific block location in the Blockchain.
class BlockTag {
  /// The most recently mined block.
  static const latest = 'latest';

  /// Genesis block, or block #0.
  static const earliest = 'earliest';

  /// The block currently being prepared for mining; not all operations and backends support this BlockTag.
  static const pending = 'pending';
}
