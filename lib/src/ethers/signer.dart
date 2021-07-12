part of ethers;

/// A Signer in ethers is an abstraction of an Ethereum Account, which can be used to sign messages and transactions and send signed transactions to the Ethereum Network to execute state changing operations.
///
/// The available operations depend largely on the sub-class used.
///
/// For example, a Signer from MetaMask can send transactions and sign messages but cannot sign a transaction (without broadcasting it).
class Signer extends Interop<_SignerImpl> {
  const Signer._(_SignerImpl impl) : super.internal(impl);

  /// Returns `true` if an only if object is a [Signer].
  static bool isSigner(Object object) =>
      _SignerImpl.isSigner(object) || object is Signer;

  Future<T> _call<T>(String method, [List<dynamic> args = const []]) async {
    switch (T) {
      case BigInt:
        return (await _call<BigNumber>(method, args)).toBigInt as T;
      default:
        return promiseToFuture<T>(callMethod(impl, method, args));
    }
  }

  /// Returns a Future that resolves to the account address.
  Future<String> getAddress() => _call<String>('getAddress');

  /// Returns the balance of this wallet at [blockTag].
  Future<BigInt> getBalance([String? blockTag]) async => _call<BigInt>(
        'getBalance',
        blockTag != null ? [blockTag] : [],
      );

  /// Returns the chain ID this wallet is connected to.
  Future<int> getChainId() => _call<int>('getChainId');

  /// Returns the current gas price.
  Future<BigInt> getGasPrice() async => _call<BigInt>('getGasPrice');

  /// Returns the number of transactions this account has ever sent.
  ///
  /// This is the value required to be included in transactions as the nonce.
  Future<int> getTransactionCount([String? blockTag]) =>
      _call<int>('getTransactionCount', blockTag != null ? [blockTag] : []);

  /// Submits transaction to the network to be mined.
  ///
  /// The transaction must be valid (i.e. the nonce is correct and the account has sufficient balance to pay for the transaction).
  Future<TransactionResponse> sendTransaction(
          TransactionRequest request) async =>
      TransactionResponse._(await _call<_TransactionResponseImpl>(
          'sendTransaction', [request.impl]));

  /// Returns the result of calling using the [TransactionRequest], with this account address being used as the from field.
  Future<String> call(TransactionRequest request) =>
      _call<String>('call', [request.impl]);

  /// Returns the result of estimating the cost to send the [TransactionRequest], with this account address being used as the from field.
  Future<BigInt> estimateGas(TransactionRequest request) =>
      _call<BigInt>('estimateGas', [request.impl]);

  /// Returns a Future which resolves to the signed transaction of the transactionRequest. This method does not populate any missing fields.
  Future<String> signTransaction(TransactionRequest request) =>
      _call<String>('signTransaction', [request.impl]);

  /// Returns a Future which resolves to the Raw Signature of message.
  Future<String> signMessage(String message) =>
      _call<String>('signMessage', [message]);
}
