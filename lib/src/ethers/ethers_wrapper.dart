import 'dart:js';
import 'dart:js_util';

import '../objects/objects.dart';
import '../utils.dart';
import 'ethers.dart';
import 'ethers_utils.dart';

extension ContractExtension on Contract {
  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  onceEvent(String eventName, Function listener) =>
      once(eventName, allowInterop(listener));

  /// Add a [listener] to be triggered for each [eventName] event.
  onEvent(String eventName, Function listener) =>
      on(eventName, allowInterop(listener));

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  offEvent(String eventName, [Function? listener]) => listener != null
      ? off(eventName, allowInterop(listener))
      : off(eventName);

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
  Future<dynamic> send(String method,
          [List<dynamic> args = const [], TxOverride? params]) async =>
      convertToDart(await promiseToFuture(
          callMethod(this, method, params != null ? [...args, params] : args)));
}

extension ProviderExtension on Provider {
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

  /// Returns a Future of [TxReceipt] which will not resolve until [transactionHash] is mined.
  ///
  /// If confirms is 0, this method is non-blocking and if the transaction has not been mined returns null.
  ///
  /// Otherwise, this method will block until the transaction has confirms blocks mined on top of the block in which is was mined.
  Future<TxReceipt> waitForTransaction(
    String transactionHash, [
    int confirms = 1,
    Duration? timeout,
  ]) =>
      promiseToFuture<TxReceipt>(callMethod(
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

  /// Returns the number of transactions [address] has ever sent, as of blockTag.
  ///
  /// This value is required to be the nonce for the next transaction from address sent to the network.
  Future<int> getTransactionCount(String address, [String? blockTag]) async =>
      int.parse(
        (await promiseToFuture(callMethod(this, 'getBalance',
                blockTag != null ? [address, blockTag] : [address])))
            .toString(),
      );

  /// Returns the block number (or height) of the most recently mined block.
  Future<int> getBlockNumber() async =>
      int.parse(await promiseToFuture(callMethod(this, 'getBlockNumber', [])));

  /// Returns the current gas price.
  Future<BigInt> getGasPrice() async =>
      (await promiseToFuture<BigNumber>(callMethod(this, 'getGasPrice', [])))
          .toBigInt;

  /// Get the block from the network by [blockNumber], where the [Block.transactions] is a list of transaction hashes.
  Future<Block> getBlock(int blockNumber) =>
      promiseToFuture<Block>(callMethod(this, 'getBlock', [blockNumber]));

  /// Returns the [TxReceipt] for hash or [null] if the transaction has not been mined.
  ///
  /// To stall until the transaction has been mined, consider the [waitForTransaction] method.
  Future<TxReceipt?> getTransactionReceipt(String transactionHash) =>
      promiseToFuture<TxReceipt?>(
          callMethod(this, 'getTransactionReceipt', [transactionHash]));
}

extension SignerExtension on Signer {
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
  Future<dynamic> send(TxParams params) async =>
      convertToDart(await promiseToFuture<dynamic>(
          callMethod(this, 'sendTransaction', [params])));
}
