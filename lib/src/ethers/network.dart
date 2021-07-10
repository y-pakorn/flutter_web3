part of ethers;

/// A Network represents an Ethereum network.
class Network implements _NetworkImpl {
  final _NetworkImpl _impl;

  const Network._(this._impl);

  ///The Chain ID of the network.
  @override
  int get chainId => _impl.chainId;

  ///The address at which the ENS registry is deployed on this network.
  @override
  String? get ensAddress => _impl.ensAddress;

  ///The human-readable name of the network, such as homestead.
  ///
  ///If the network name is unknown, this will be "unknown".
  @override
  String get name => _impl.name;

  @override
  String toString() => 'Network: $name at $chainId';
}
