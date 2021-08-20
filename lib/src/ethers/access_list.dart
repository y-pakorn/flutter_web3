part of ethers;

/// An EIP-2930 transaction allows an optional AccessList which causes a transaction to warm (i.e. pre-cache) another addresses state and the specified storage keys.
///
/// This incurs an increased intrinsic cost for the transaction, but provides discounts for storage and state access throughout the execution of the transaction.
class AccessList extends Interop<_AccessListImpl> {
  const AccessList._(_AccessListImpl impl) : super.internal(impl);

  factory AccessList(String address, List<String> storageKey) =>
      AccessList._(_AccessListImpl(address, storageKey));

  String get address => impl.address;

  List<String> get storageKey => impl.storageKey.cast<String>();
}
