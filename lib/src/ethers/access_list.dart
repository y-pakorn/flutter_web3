part of ethers;

/// An EIP-2930 transaction allows an optional AccessList which causes a transaction to warm (i.e. pre-cache) another addresses state and the specified storage keys.
///
/// This incurs an increased intrinsic cost for the transaction, but provides discounts for storage and state access throughout the execution of the transaction.
class AccessList extends Interop<_AccessListImpl> {
  const AccessList._(_AccessListImpl impl) : super.internal(impl);

  /// Create new [AccessList] from [address] and [storageKeys], [storageKey] elements must be empty or bytes32 string.
  ///
  /// ---
  ///
  /// final accessList = AccessList(
  ///   '0x0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e',
  ///   [
  ///     "0x0000000000000000000000000000000000000000000000000000000000000004",
  ///     "0x0bcad17ecf260d6506c6b97768bdc2acfb6694445d27ffd3f9c1cfbee4a9bd6d"
  ///   ],
  /// );
  factory AccessList(String address, List<String> storageKeys) =>
      AccessList._(_AccessListImpl(address, storageKeys));

  String get address => impl.address;

  List<String> get storageKeys => impl.storageKeys.cast<String>();
}
