part of ethers;

/// The Web3Provider is meant to ease moving from a web3.js based application to ethers by wrapping an existing Web3-compatible (such as a Web3HttpProvider, Web3IpcProvider or Web3WsProvider) and exposing it as an ethers.js Provider which can then be used with the rest of the library.
///
/// This may also be used to wrap a standard [EIP-1193 Provider](link-eip-1193].
class Web3Provider extends Provider implements _Web3ProviderImpl {
  final _Web3ProviderImpl _impl;

  const Web3Provider._(this._impl) : super._(_impl);

  /// Create new [Web3Provider] instance from provider instance.
  factory Web3Provider(dynamic provider) {
    assert(provider != null, 'Provider must not be null.');
    assert(
        provider is Ethereum ||
            provider is WalletConnectProvider ||
            provider is EthereumBaseImpl,
        'Provider type must be valid.');
    return Web3Provider._(
      _Web3ProviderImpl(
        provider is Ethereum
            ? getEthereumImpl(provider)
            : provider is WalletConnectProvider
                ? getWalletConnectImpl(provider)
                : provider,
      ),
    );
  }

  /// Create new [Web3Provider] instance from [Ethereum] instance.
  factory Web3Provider.fromEthereum(Ethereum ethereum) =>
      Web3Provider._(_Web3ProviderImpl(getEthereumImpl(ethereum)));

  /// Create new [Web3Provider] instance from [WalletConnectProvider] instance.
  factory Web3Provider.fromWalletConnect(WalletConnectProvider walletConnect) =>
      Web3Provider._(_Web3ProviderImpl(getWalletConnectImpl(walletConnect)));

  /// Connect this to create new [Signer] object.
  @override
  Signer getSigner() => Signer._(_impl.getSigner());
}

/// The JSON-RPC API is a popular method for interacting with Ethereum and is available in all major Ethereum node implementations (e.g. Geth and Parity) as well as many third-party web services (e.g. INFURA)
class JsonRpcProvider extends Provider implements _JsonRpcProviderImpl {
  final _JsonRpcProviderImpl _impl;

  final String _rpcUrl;

  JsonRpcProvider._(this._impl, this._rpcUrl) : super._(_impl);

  /// Create new [JsonRpcProvider] from [rpcUrl].
  factory JsonRpcProvider(String rpcUrl) {
    assert(rpcUrl.isNotEmpty, 'Rpc url must not be empty');
    return JsonRpcProvider._(_JsonRpcProviderImpl(rpcUrl), rpcUrl);
  }

  /// Rpc url that [this] is connected to.
  String get rpcUrl => _rpcUrl;

  /// Returns a list of all account addresses managed by [this] provider.
  Future<List<String>> listAccounts() async =>
      (await promiseToFuture<List>(callMethod(_impl, 'listAccounts', [])))
          .cast<String>();

  @override
  String toString() => 'JsonRpcProvider $rpcUrl';
}

/// A Provider is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality.
///
/// The ethers.js library provides several options which should cover the vast majority of use-cases, but also includes the necessary functions and classes for sub-classing if a more custom configuration is necessary.
class Provider implements _ProviderImpl {
  final _ProviderImpl _provImpl;

  const Provider._(this._provImpl);

  /// Returns a Future which will stall until the [Network] has heen established, ignoring errors due to the target node not being active yet.
  ///
  /// This can be used for testing or attaching scripts to wait until the node is up and running smoothly.
  Future<Network> get ready async =>
      Network._(await call<_NetworkImpl>('ready'));

  /// Direct Ethers provider call to access Blockchain data.
  Future<T> call<T>(String method, [List<dynamic> args = const []]) async {
    switch (T) {
      case BigInt:
        return (await call<BigNumber>(method, args)).toBigInt as T;
      default:
        return promiseToFuture<T>(callMethod(_provImpl, method, args));
    }
  }

  /// Returns the balance of [address] as of the [blockTag] block height.
  Future<BigInt> getBalance(String address, [String? blockTag]) => call<BigInt>(
        'getBalance',
        blockTag != null ? [address, blockTag] : [address],
      );

  /// Get the block from the network by [blockNumber], where the [Block.transactions] is a list of transaction hashes.
  Future<Block> getBlock(int blockNumber) async =>
      Block._(await call<_BlockImpl>('getBlock', [blockNumber]));

  /// Returns the block number (or height) of the most recently mined block.
  Future<int> getBlockNumber() => call<int>('getBlockNumber');

  /// Get the block from the network, where the [BlockWithTransaction.transactions] is an Array of [TransactionResponse].
  Future<BlockWithTransaction> getBlockWithTransaction(int blockNumber) async =>
      BlockWithTransaction._(
        await call<_BlockWithTransactionImpl>(
          'getBlockWithTransactions',
          [blockNumber],
        ),
      );

  /// Returns the current gas price.
  Future<BigInt> getGasPrice() => call<BigInt>('getGasPrice');

  /// Returns the [List] of [Log] matching the filter.
  ///
  /// Keep in mind that many backends will discard old events, and that requests which are too broad may get dropped as they require too many resources to execute the query.
  Future<List<Log>> getLogs(EventFilter filter) async =>
      (await call<List>('getLogs', [filter._eventImpl]))
          .cast<_LogImpl>()
          .map((e) => Log._(e))
          .toList();

  /// Returns the Network this Provider is connected to.
  Future<Network> getNetwork() async =>
      Network._(await call<_NetworkImpl>('getNetwork'));

  /// Returns the [TransactionResponse] with [hash] or null if the transaction is unknown.
  ///
  /// If a transaction has not been mined, this method will search the transaction pool.
  ///
  /// Various backends may have more restrictive transaction pool access (e.g. if the gas price is too low or the transaction was only recently sent and not yet indexed) in which case this method may also return null.
  Future<TransactionResponse?> getTransaction(String hash) async {
    final response =
        await call<_TransactionResponseImpl?>('getTransaction', [hash]);
    if (response != null) return TransactionResponse._(response);
  }

  /// Returns the number of transactions [address] has ever sent, as of [blockTag].
  ///
  /// This value is required to be the nonce for the next transaction from address sent to the network.
  Future<int> getTransactionCount(String address, [String? blockTag]) =>
      call<int>(
        'getTransactionCount',
        blockTag != null ? [address, blockTag] : [address],
      );

  /// Returns the [TransactionReceipt] for [hash] or null if the transaction has not been mined.
  ///
  /// To stall until the transaction has been mined, consider the [waitForTransaction] method.
  Future<TransactionReceipt?> getTransactionReceipt(String hash) async {
    final receipt =
        await call<_TransactionReceiptImpl?>('getTransactionReceipt', [hash]);
    if (receipt != null) return TransactionReceipt._(receipt);
  }

  /// Returns the result of executing the transaction, using call.
  ///
  /// A call does not require any ether, but cannot change any state. This is useful for calling getters on Contracts.
  Future<T> rawCall<T>(String to, String data, [String? blockTag]) =>
      promiseToFuture<T>(callMethod(
        this,
        'call',
        blockTag != null
            ? [_RawTxParamsImpl(to: to, data: data), blockTag]
            : [_RawTxParamsImpl(to: to, data: data)],
      ));

  /// Submits transaction to the network to be mined.
  ///
  /// The transaction must be signed, and be valid (i.e. the nonce is correct and the account has sufficient balance to pay for the transaction).
  ///
  /// ```dart
  /// await provider.sendTransaction("0xf86e808502540be400825208948ba1f109551bd432803012645ac136ddd64dba72880de0b6b3a764000080820a96a0f0c5bcb11e5a16ab116c60a0e5837ae98ec36e7f217740076572e8183002edd2a01ed1b4411c2840b9793e8be5415a554507f1ea320069be6dcecabd7b9097dbd4");
  /// ```
  Future<TransactionResponse> sendTransaction(String data) async =>
      TransactionResponse._(
          await call<_TransactionResponseImpl>('sendTransaction', [data]));

  /// Returns a Future of [TransactionReceipt] which will not resolve until [transactionHash] is mined.
  ///
  /// If confirms is 0, this method is non-blocking and if the transaction has not been mined returns null.
  ///
  /// Otherwise, this method will block until the transaction has confirms blocks mined on top of the block in which is was mined.
  Future<TransactionReceipt> waitForTransaction(
    String transactionHash, [
    int confirms = 1,
    Duration? timeout,
  ]) async =>
      TransactionReceipt._(
        await call<_TransactionReceiptImpl>(
          'waitForTransaction',
          timeout != null
              ? [transactionHash, confirms, timeout.inSeconds]
              : [transactionHash, confirms],
        ),
      );
}
