import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../objects/objects.dart';
import 'ethers.dart';

extension BigNumberExtension on BigNumber {
  /// Convert JS [BigNumber] to Dart [BigInt].
  BigInt get toBigInt => BigInt.parse(this.toString());

  /// Convert JS [BigNumber] to Dart [int].
  int get toInt => int.parse(this.toString());

  /// Convert JS [BigNumber] to Dart [double].
  double get toDouble => double.parse(this.toString());
}

extension ContractExtension on Contract {
  /// Return a filter for [eventName], optionally filtering by additional constraints.
  ///
  /// Only indexed event parameters may be filtered. If a parameter is null (or not provided) then any value in that field matches.
  Filter getFilter(String eventName, [List<dynamic> args = const []]) =>
      callMethod(getProperty(this, 'filters'), eventName, args);

  /// Return a [List] of [Logs] that have been emitted by the Contract by the [filter].
  Future<List<Log>> queryFilter(EventFilter filter,
          [dynamic startBlock, dynamic endBlock]) async =>
      (await promiseToFuture<List<dynamic>>(callMethod(this, 'queryFilter',
              [filter, startBlock, endBlock]..removeWhere((e) => e == null))))
          .cast<Log>();

  /// This is a promise that will resolve to the address the [Contract] object is attached to.
  ///
  /// If an Address was provided to the constructor, it will be equal to this; if an ENS name was provided, this will be the resolved address.
  Future<String> get resolvedAddress =>
      promiseToFuture<String>(getProperty(this, 'resolvedAddress'));

  /// If the [Contract] object is the result of a ContractFactory deployment, this is the transaction which was used to deploy the contract.
  Future<TransactionResponse> get deployTransaction =>
      promiseToFuture<TransactionResponse>(
          getProperty(this, 'deployTransaction'));

  /// Multicall read-only constant method on the Contract. `May not` be at the same block.
  ///
  /// If [eagerError] is `true`, returns the error immediately on the first error found.
  Future<List<T>> multicall<T>(String method, List<List<dynamic>> args,
          [bool eagerError = false]) =>
      Future.wait(
          Iterable<int>.generate(args.length).map(
            (e) => call<T>(method, args[e]),
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
      promiseToFuture<T>(callMethod(this, method, args));

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
      promiseToFuture<TransactionResponse>(
          callMethod(this, method, params != null ? [...args, params] : args));
}

extension ProviderExtension on Provider {
  /// Returns the [List] of [Log] matching the filter.
  ///
  /// Keep in mind that many backends will discard old events, and that requests which are too broad may get dropped as they require too many resources to execute the query.
  Future<List<Log>> getLogs(EventFilter filter) async =>
      (await promiseToFuture<List<dynamic>>(
              callMethod(this, 'getLogs', [filter])))
          .cast<Log>();

  /// Returns a Future which will stall until the [Network] has heen established, ignoring errors due to the target node not being active yet.
  ///
  /// This can be used for testing or attaching scripts to wait until the node is up and running smoothly.
  Future<Network> get ready =>
      promiseToFuture<Network>(getProperty(this, 'ready'));

  /// Direct Ethers provider call to access Blockchain data.
  Future<T> call<T>(String method, [List<dynamic> args = const []]) =>
      promiseToFuture<T>(callMethod(this, method, args));

  /// Returns the result of executing the transaction, using call.
  ///
  /// A call does not require any ether, but cannot change any state. This is useful for calling getters on Contracts.
  Future<T> rawCall<T>(String to, String data, [String? blockTag]) =>
      promiseToFuture<T>(callMethod(
        this,
        'call',
        blockTag != null
            ? [RawTxParams(to: to, data: data), blockTag]
            : [RawTxParams(to: to, data: data)],
      ));

  /// Returns a Future of [TransactionReceipt] which will not resolve until [transactionHash] is mined.
  ///
  /// If confirms is 0, this method is non-blocking and if the transaction has not been mined returns null.
  ///
  /// Otherwise, this method will block until the transaction has confirms blocks mined on top of the block in which is was mined.
  Future<TransactionReceipt> waitForTransaction(
    String transactionHash, [
    int confirms = 1,
    Duration? timeout,
  ]) =>
      promiseToFuture<TransactionReceipt>(callMethod(
        this,
        'waitForTransaction',
        timeout != null
            ? [transactionHash, confirms, timeout.inSeconds]
            : [transactionHash, confirms],
      ));

  /// Returns the Network this Provider is connected to.
  Future<Network> getNetwork() =>
      promiseToFuture<Network>(callMethod(this, 'getNetwork', []));

  /// Returns the balance of [address] as of the [blockTag] block height.
  Future<BigInt> getBalance(String address, [String? blockTag]) async =>
      (await promiseToFuture<BigNumber>(callMethod(this, 'getBalance',
              blockTag != null ? [address, blockTag] : [address])))
          .toBigInt;

  /// Returns the number of transactions [address] has ever sent, as of [blockTag].
  ///
  /// This value is required to be the nonce for the next transaction from address sent to the network.
  Future<int> getTransactionCount(String address, [String? blockTag]) async =>
      int.parse(
        (await promiseToFuture(callMethod(this, 'getBalance',
                blockTag != null ? [address, blockTag] : [address])))
            .toString(),
      );

  /// Returns the block number (or height) of the most recently mined block.
  Future<int> getBlockNumber() =>
      promiseToFuture<int>(callMethod(this, 'getBlockNumber', []));

  /// Returns the current gas price.
  Future<BigInt> getGasPrice() async =>
      (await promiseToFuture<BigNumber>(callMethod(this, 'getGasPrice', [])))
          .toBigInt;

  /// Get the block from the network by [blockNumber], where the [Block.transactions] is a list of transaction hashes.
  Future<Block> getBlock(int blockNumber) =>
      promiseToFuture<Block>(callMethod(this, 'getBlock', [blockNumber]));

  /// Returns the [TransactionReceipt] for [hash] or null if the transaction has not been mined.
  ///
  /// To stall until the transaction has been mined, consider the [waitForTransaction] method.
  Future<TransactionReceipt?> getTransactionReceipt(String hash) =>
      promiseToFuture<TransactionReceipt?>(
          callMethod(this, 'getTransactionReceipt', [hash]));

  /// Returns the [TransactionResponse] with [hash] or null if the transaction is unknown.
  ///
  /// If a transaction has not been mined, this method will search the transaction pool.
  ///
  /// Various backends may have more restrictive transaction pool access (e.g. if the gas price is too low or the transaction was only recently sent and not yet indexed) in which case this method may also return null.
  Future<TransactionResponse?> getTransaction(String hash) =>
      promiseToFuture<TransactionResponse?>(
          callMethod(this, 'getTransaction', [hash]));

  /// Submits transaction to the network to be mined.
  ///
  /// The transaction must be signed, and be valid (i.e. the nonce is correct and the account has sufficient balance to pay for the transaction).
  ///
  /// ```dart
  /// await provider.sendTransaction("0xf86e808502540be400825208948ba1f109551bd432803012645ac136ddd64dba72880de0b6b3a764000080820a96a0f0c5bcb11e5a16ab116c60a0e5837ae98ec36e7f217740076572e8183002edd2a01ed1b4411c2840b9793e8be5415a554507f1ea320069be6dcecabd7b9097dbd4");
  /// ```
  Future<TransactionResponse> sendTransaction(String data) =>
      promiseToFuture<TransactionResponse>(
          callMethod(this, 'sendTransaction', [data]));

  /// Get the block from the network, where the [BlockWithTransaction.transactions] is an Array of [TransactionResponse].
  Future<BlockWithTransaction> getBlockWithTransaction(int blockNumber) =>
      promiseToFuture<BlockWithTransaction>(
          callMethod(this, 'getBlockWithTransactions', [blockNumber]));
}

extension SignerExtension on Signer {
  /// Returns a Future that resolves to the account address.
  Future<String> getAddress() =>
      promiseToFuture<String>(callMethod(this, 'getAddress', []));

  /// Returns the balance of this wallet at [blockTag].
  Future<BigInt> getBalance([String? blockTag]) async =>
      (await promiseToFuture<BigNumber>(callMethod(
              this, 'getBalance', blockTag != null ? [blockTag] : [])))
          .toBigInt;

  /// Returns the chain ID this wallet is connected to.
  Future<int> getChainId() =>
      promiseToFuture<int>(callMethod(this, 'getChainId', []));

  /// Returns the current gas price.
  Future<BigInt> getGasPrice() async =>
      (await promiseToFuture<BigNumber>(callMethod(this, 'getGasPrice', [])))
          .toBigInt;

  /// Returns the number of transactions this account has ever sent.
  ///
  /// This is the value required to be included in transactions as the nonce.
  Future<int> getTransactionCount([String? blockTag]) async => int.parse(
        (await promiseToFuture(callMethod(
                this, 'getBalance', blockTag != null ? [blockTag] : [])))
            .toString(),
      );

  /// Submits transaction to the network to be mined.
  ///
  /// The transaction must be valid (i.e. the nonce is correct and the account has sufficient balance to pay for the transaction).
  Future<TransactionResponse> sendTransaction(TransactionRequest request) =>
      promiseToFuture<TransactionResponse>(
          callMethod(this, 'sendTransaction', [request]));

  /// Returns the result of calling using the [TransactionRequest], with this account address being used as the from field.
  Future<String> call(TransactionRequest request) =>
      promiseToFuture<String>(callMethod(this, 'call', [request]));

  /// Returns the result of estimating the cost to send the [TransactionRequest], with this account address being used as the from field.
  Future<BigInt> estimateGas(TransactionRequest request) async =>
      (await promiseToFuture<BigNumber>(
              callMethod(this, 'estimateGas', [request])))
          .toBigInt;

  /// Returns a Future which resolves to the signed transaction of the transactionRequest. This method does not populate any missing fields.
  Future<String> signTransaction(TransactionRequest request) =>
      promiseToFuture<String>(callMethod(this, 'sendTransaction', [request]));

  /// Returns a Future which resolves to the Raw Signature of message.
  Future<String> signMessage(String message) =>
      promiseToFuture<String>(callMethod(this, 'signMessage', [message]));
}
