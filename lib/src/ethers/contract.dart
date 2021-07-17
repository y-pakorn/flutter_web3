part of ethers;

/// A Contract is an abstraction of code that has been deployed to the blockchain.
///
/// A Contract may be sent transactions, which will trigger its code to be run with the input of the transaction data.
class Contract extends Interop<_ContractImpl> {
  /// Instantiate Contract object for invoking smart contract method.
  ///
  /// Use [Provider] in [providerOrSigner] for read-only contract calls, or use [Signer] for read-write contract calls.
  factory Contract(String address, dynamic abi, dynamic providerOrSigner) {
    assert(
      //providerOrSigner is Interop &&
      (providerOrSigner is Provider || providerOrSigner is Signer),
      'providerOrSigner must be Provider or Signer',
    );
    return Contract._(
        _ContractImpl(address, abi, (providerOrSigner as Interop).impl));
  }

  /// Instantiate [Contract] from [provider] for read-only contract calls.
  factory Contract.fromProvider(
          String address, dynamic abi, Provider provider) =>
      Contract._(_ContractImpl(address, abi, provider.impl));

  /// Instantiate [Contract] from [provider] for read-write contract calls.
  factory Contract.fromSigner(String address, dynamic abi, Signer signer) =>
      Contract._(_ContractImpl(address, abi, signer.impl));

  const Contract._(_ContractImpl impl) : super.internal(impl);

  /// This is the address (or ENS name) the contract was constructed with.
  String get address => impl.address;

  /// If the [Contract] object is the result of a `ContractFactory` deployment, this is the transaction which was used to deploy the contract.
  Future<TransactionResponse> get deployTransaction =>
      _get<TransactionResponse>('deployTransaction');

  /// This is the ABI as an [Interface].
  Interface get interface => impl.interface;

  /// `true` if connected to [Provider], `false` if connected to [Signer].
  bool get isReadOnly => signer == null;

  /// If a [Provider] was provided to the constructor, this is that provider. If a [Signer] was provided that had a [Provider], this is that provider.
  Provider get provider => Provider._(impl.provider);

  /// This is a Future that will resolve to the address [this] is attached to.
  ///
  /// If an Address was provided to the constructor, it will be equal to [this]. If an ENS name was provided, this will be the resolved address.
  Future<String> get resolvedAddress => _get<String>('resolvedAddress');

  /// If a [Signer] was provided to the constructor, this is that signer.
  Signer? get signer => impl.signer != null ? Signer._(impl.signer!) : null;

  /// Call read-only constant [method] with [args].
  ///
  /// A constant method is read-only and evaluates a small amount of EVM code against the current blockchain state and can be computed by asking a single node, which can return a result.
  ///
  /// It is therefore free and does not require any ether, but cannot make changes to the blockchain state.
  Future<T> call<T>(String method, [List<dynamic> args = const []]) =>
      _call<T>(method, args);

  ///Returns a new instance of the [Contract], but connected to [Provider] or [Signer].
  ///
  ///By passing in a [Provider], this will return a downgraded Contract which only has read-only access (i.e. constant calls).
  ///
  ///By passing in a [Signer]. this will return a Contract which will act on behalf of that signer.
  Contract connect(dynamic providerOrSigner) {
    assert(
      providerOrSigner is Provider || providerOrSigner is Signer,
      'providerOrSigner must be Provider or Signer',
    );
    return Contract._(impl.connect(providerOrSigner));
  }

  /// Return a filter for [eventName], optionally filtering by additional [args] constraints.
  ///
  /// Only indexed event parameters may be filtered. If a parameter is null (or not provided) then any value in that field matches.
  Filter getFilter(String eventName, [List<dynamic> args = const []]) =>
      Filter._(callMethod(getProperty(impl, 'filters'), eventName, args));

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  int listenerCount([String? eventName]) => impl.listenerCount(eventName);

  /// Returns the list of Listeners for the [eventName] events.
  List listeners(String eventName) => impl.listeners(eventName);

  /// Multicall read-only constant [method] with [args]. `May not` be at the same block.
  ///
  /// If [eagerError] is `true`, returns the error immediately on the first error found.
  Future<List<T>> multicall<T>(String method, List<List<dynamic>> args,
          [bool eagerError = false]) =>
      Future.wait(
          Iterable<int>.generate(args.length).map(
            (e) => _call<T>(method, args[e]),
          ),
          eagerError: eagerError);

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  off(String eventName, [Function? listener]) => callMethod(impl, 'off',
      listener != null ? [eventName, allowInterop(listener)] : [eventName]);

  /// Add a [listener] to be triggered for each [eventName] event.
  on(String eventName, Function listener) =>
      callMethod(impl, 'on', [eventName, allowInterop(listener)]);

  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  once(String eventName, Function listener) =>
      callMethod(impl, 'once', [eventName, allowInterop(listener)]);

  /// Return a List of [Log] that have been emitted by the Contract by the [filter]. Optinally constraint from [startBlock] to [endBlock].
  Future<List<Log>> queryFilter(EventFilter filter,
          [dynamic startBlock, dynamic endBlock]) async =>
      (await _call<List>(
        'queryFilter',
        [
          filter.impl,
          startBlock,
          endBlock,
        ]..removeWhere((e) => e == null),
      ))
          .cast<_LogImpl>()
          .map((e) => Log._(e))
          .toList();

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  removeAllListeners([String? eventName]) => impl.removeAllListeners(eventName);

  /// Send write [method] with [args], [override] may be include to send the Ether or adjust transaction options.
  ///
  /// This required the Contract object to be initalized with [Signer].
  ///
  /// A non-constant method requires a transaction to be signed and requires payment in the form of a fee to be paid to a miner.
  ///
  /// This transaction will be verified by every node on the entire network as well by the miner who will compute the new state of the blockchain after executing it against the current state.
  ///
  /// It cannot return a result. If a result is required, it should be logged using a Solidity event (or EVM log), which can then be queried from the transaction receipt.
  Future<TransactionResponse> send(String method,
          [List<dynamic> args = const [], TransactionOverride? override]) =>
      _call<TransactionResponse>(
          method, override != null ? [...args, override.impl] : args);

  @override
  String toString() =>
      'Contract: $address connected to ${isReadOnly ? 'provider' : 'signer'}';

  Future<T> _call<T>(String method, [List<dynamic> args = const []]) async {
    switch (T) {
      case BigInt:
        return (await call<BigNumber>(method, args)).toBigInt as T;
      default:
        return promiseToFuture<T>(callMethod(impl, method, args));
    }
  }

  Future<T> _get<T>(String method) async {
    switch (T) {
      case BigInt:
        return (await call<BigNumber>(method)).toBigInt as T;
      default:
        return promiseToFuture<T>(getProperty(impl, method));
    }
  }
}
