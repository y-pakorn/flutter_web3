part of ethers;

extension ContractExtension on Contract {
  Future<T> _call<T>(String method, [List<dynamic> args = const []]) async {
    switch (T) {
      case BigInt:
        return (await call<BigNumber>(method, args)).toBigInt as T;
      default:
        return promiseToFuture<T>(callMethod(this, method, args));
    }
  }

  Future<T> _get<T>(String method) async {
    switch (T) {
      case BigInt:
        return (await call<BigNumber>(method)).toBigInt as T;
      default:
        return promiseToFuture<T>(getProperty(this, method));
    }
  }

  /// Return a filter for [eventName], optionally filtering by additional constraints.
  ///
  /// Only indexed event parameters may be filtered. If a parameter is null (or not provided) then any value in that field matches.
  _FilterImpl getFilter(String eventName, [List<dynamic> args = const []]) =>
      callMethod(getProperty(this, 'filters'), eventName, args);

  /// Return a [List] of [Logs] that have been emitted by the Contract by the [filter].
  Future<List<Log>> queryFilter(EventFilter filter,
          [dynamic startBlock, dynamic endBlock]) async =>
      (await _call<List>(
        'queryFilter',
        [filter._eventImpl, startBlock, endBlock]
          ..removeWhere((e) => e == null),
      ))
          .cast<Log>();

  /// This is a promise that will resolve to the address the [Contract] object is attached to.
  ///
  /// If an Address was provided to the constructor, it will be equal to this; if an ENS name was provided, this will be the resolved address.
  Future<String> get resolvedAddress => _get<String>('resolvedAddress');

  /// If the [Contract] object is the result of a ContractFactory deployment, this is the transaction which was used to deploy the contract.
  Future<TransactionResponse> get deployTransaction =>
      _get<TransactionResponse>('deployTransaction');

  /// Multicall read-only constant method on the Contract. `May not` be at the same block.
  ///
  /// If [eagerError] is `true`, returns the error immediately on the first error found.
  Future<List<T>> multicall<T>(String method, List<List<dynamic>> args,
          [bool eagerError = false]) =>
      Future.wait(
          Iterable<int>.generate(args.length).map(
            (e) => _call<T>(method, args[e]),
          ),
          eagerError: eagerError);

  /// Multicall method and args on the Contract, this lose ability to annotate type.
  Future<List<dynamic>> multicallMethod(
    List<String> method,
    List<List<dynamic>> args,
  ) {
    assert(method.isNotEmpty);
    assert(args.isNotEmpty);
    assert(method.length == args.length);

    return Future.wait(Iterable<int>.generate(method.length)
        .map((e) => call(method[e], args[e])));
  }

  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  once(String eventName, Function listener) =>
      callMethod(this, 'once', [eventName, allowInterop(listener)]);

  /// Add a [listener] to be triggered for each [eventName] event.
  on(String eventName, Function listener) =>
      callMethod(this, 'on', [eventName, allowInterop(listener)]);

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  off(String eventName, [Function? listener]) => callMethod(this, 'off',
      listener != null ? [eventName, allowInterop(listener)] : [eventName]);

  /// Call read-only constant method on the Contract.
  ///
  /// A constant method is read-only and evaluates a small amount of EVM code against the current blockchain state and can be computed by asking a single node, which can return a result.
  ///
  /// It is therefore free and does not require any ether, but cannot make changes to the blockchain state.
  Future<T> call<T>(String method, [List<dynamic> args = const []]) =>
      _call<T>(method, args);

  /// Send write method to the Contract.
  ///
  /// This required the Contract object to be initalized with [Signer].
  ///
  /// A non-constant method requires a transaction to be signed and requires payment in the form of a fee to be paid to a miner.
  ///
  /// This transaction will be verified by every node on the entire network as well by the miner who will compute the new state of the blockchain after executing it against the current state.
  ///
  /// It cannot return a result. If a result is required, it should be logged using a Solidity event (or EVM log), which can then be queried from the transaction receipt.
  Future<TransactionResponse> send(String method,
          [List<dynamic> args = const [], TxOverride? params]) =>
      _call<TransactionResponse>(
          method, params != null ? [...args, params] : args);
}
