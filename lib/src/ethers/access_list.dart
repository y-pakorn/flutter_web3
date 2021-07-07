part of ethers;

/// An EIP-2930 transaction allows an optional AccessList which causes a transaction to warm (i.e. pre-cache) another addresses state and the specified storage keys.
///
/// This incurs an increased intrinsic cost for the transaction, but provides discounts for storage and state access throughout the execution of the transaction.
class AccessList implements _AccessListImpl {
  final _AccessListImpl _impl;

  const AccessList._(this._impl);

  @override
  String get address => _impl.address;

  @override
  List<String> get storageKey => _impl.storageKey.cast<String>();
}
