part of ethers;

/// The JSON-RPC API is a popular method for interacting with Ethereum and is available in all major Ethereum node implementations (e.g. Geth and Parity) as well as many third-party web services (e.g. INFURA)
class JsonRpcProvider extends Provider<_JsonRpcProviderImpl> {
  final String _rpcUrl;

  /// Create new [JsonRpcProvider] from [rpcUrl].
  ///
  /// If [rpcUrl] is `null`, [JsonRpcProvider] will instantiate with default rpc, i.e. `http:/\/localhost:8545`.
  ///
  /// ---
  ///
  /// ```dart
  /// final localRpcProvider = JsonRpcProvider();
  /// final binanceRpcProvider = JsonRpcProvider('https://bsc-dataseed.binance.org/');
  ///
  /// print(localRpcProvider); // JsonRpcProvider: http://localhost:8545/
  /// print(binanceRpcProvider); // JsonRpcProvider: https://bsc-dataseed.binance.org/
  /// ```
  factory JsonRpcProvider([String? rpcUrl]) {
    if (rpcUrl != null) {
      assert(rpcUrl.isNotEmpty, 'Rpc url must not be empty');
      return JsonRpcProvider._(_JsonRpcProviderImpl(rpcUrl), rpcUrl);
    }
    return JsonRpcProvider._(_JsonRpcProviderImpl(), '');
  }

  JsonRpcProvider._(_JsonRpcProviderImpl impl, this._rpcUrl) : super._(impl);

  /// Rpc url that [this] is connected to.
  String get rpcUrl => _rpcUrl;

  /// Returns a list of all account addresses managed by [this] provider.
  Future<List<String>> listAccounts() async =>
      (await promiseToFuture<List>(callMethod(impl, 'listAccounts', [])))
          .cast<String>();

  @override
  String toString() => 'JsonRpcProvider: $rpcUrl';
}

/// A Provider is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality.
///
/// The ethers.js library provides several options which should cover the vast majority of use-cases, but also includes the necessary functions and classes for sub-classing if a more custom configuration is necessary.
class Provider<T extends _ProviderImpl> extends Interop<T> {
  const Provider._(T impl) : super.internal(impl);

  /// Returns a Future which will stall until the [Network] has heen established, ignoring errors due to the target node not being active yet.
  ///
  /// This can be used for testing or attaching scripts to wait until the node is up and running smoothly.
  Future<Network> get ready async =>
      Network._(await call<_NetworkImpl>('ready'));

  /// Direct Ethers provider [method] call with [args] to access Blockchain data.
  Future<T> call<T>(String method, [List<dynamic> args = const []]) async {
    switch (T) {
      case BigInt:
        return (await call<BigNumber>(method, args)).toBigInt as T;
      default:
        return promiseToFuture<T>(callMethod(impl, method, args));
    }
  }

  /// Returns the balance of [address] as of the [blockTag].
  ///
  /// ---
  ///
  /// ```dart
  /// final balance = await getBalance('0xfooBar');
  ///
  /// print(balance); // 10000000000000
  /// print(balance is BigInt); // true
  /// ```
  Future<BigInt> getBalance(String address, [dynamic blockTag]) => call<BigInt>(
        'getBalance',
        blockTag != null ? [address, blockTag] : [address],
      );

  /// Get the [Block] from the network by [blockNumber], where the [Block.transactions] is a list of transaction hashes.
  ///
  /// ---
  ///
  /// ```dart
  /// final block = await provider!.getBlock(2000000);
  ///
  /// print(block);
  /// // Block: 2000000 0x9d2e2d20 mined at 2020-11-06T21:22:24.000 with diff 2
  /// print(block.transaction.first);
  /// // 0x99598d22288ba2ed229cf965a7e0279a8df3d61d48f779d2ce5e3ab84788c10c
  /// ```
  Future<Block> getBlock(int blockNumber) async =>
      Block._(await call<_BlockImpl>('getBlock', [blockNumber]));

  /// Returns the block number (or height) of the most recently mined block.
  Future<int> getBlockNumber() => call<int>('getBlockNumber');

  /// Get the [BlockWithTransaction] at [blockNumber] from the network, where the [BlockWithTransaction.transactions] is an Array of [TransactionResponse].
  ///
  /// ---
  ///
  /// ```dart
  /// final block = await provider!.getBlockWithTransaction(2000000);
  ///
  /// print(block);
  /// // Block: 2000000 0x9d2e2d20 mined at 2020-11-06T21:22:24.000 with diff 2
  /// print(block.transaction.first);
  /// // Transaction: 0x99598d22 from 0xC5D2A96c with value 39090000000000000000 and data 0x7ff36ab500000...
  /// print(block.transactions.first is TransactionResponse); // true
  /// ```
  Future<BlockWithTransaction> getBlockWithTransaction(int blockNumber) async =>
      BlockWithTransaction._(
        await call<_BlockWithTransactionImpl>(
          'getBlockWithTransactions',
          [blockNumber],
        ),
      );

  /// Returns the contract code of [address] as of the [blockTag] block height. If there is no contract currently deployed, the result is `0x`.
  Future<String> getCode(String address, [dynamic blockTag]) => call<String>(
      'getCode', blockTag == null ? [address] : [address, blockTag]);

  /// Returns the current gas price.
  Future<BigInt> getGasPrice() => call<BigInt>('getGasPrice');

  /// Get the lastest [Block] from the network.
  Future<Block> getLastestBlock() async =>
      Block._(await call<_BlockImpl>('getBlock', []));

  /// Get the lastest [BlockWithTransaction] from the network.
  Future<BlockWithTransaction> getLastestBlockWithTransaction() async =>
      BlockWithTransaction._(await call<_BlockWithTransactionImpl>(
          'getBlockWithTransactions', []));

  /// Returns the List of [Log] matching the [filter].
  ///
  /// Keep in mind that many backends will discard old events, and that requests which are too broad may get dropped as they require too many resources to execute the query.
  ///
  /// ---
  ///
  /// ```dart
  /// // Create new BUSD BEP20 Token filter for specific topics
  /// final filter = Filter(
  ///   address: '0xe9e7cea3dedca5984780bafc599bd69add087d56',
  ///   topics: [
  ///     '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
  ///     '0x0000000000000000000000002caa4694cb7daf7d49a198dc1103c06d4991ae52',
  ///   ],
  /// );
  ///
  /// // Query logs for specified filter
  /// final logs = await provider!.getLogs(filter);
  ///
  /// print(logs.length); // 8
  /// print(logs.first); // Log: 3 topics from 0x2ad2e409
  /// print(logs.first is Log); // true
  /// ```
  Future<List<Log>> getLogs(EventFilter filter) async =>
      (await call<List>('getLogs', [filter.impl]))
          .cast<_LogImpl>()
          .map((e) => Log._(e))
          .toList();

  /// Returns the [Network] that [this] is connected to.
  Future<Network> getNetwork() async =>
      Network._(await call<_NetworkImpl>('getNetwork'));

  /// Returns the `Bytes32` value of the position [pos] at [address], as of the [blockTag].
  Future<String> getStorageAt(String address, int pos, [dynamic blockTag]) =>
      call<String>('getStorageAt',
          blockTag == null ? [address, pos] : [address, pos, blockTag]);

  /// Returns the [TransactionResponse] with [hash] or `null` if the transaction is unknown.
  ///
  /// If a transaction has not been mined, this method will search the transaction pool.
  ///
  /// Various backends may have more restrictive transaction pool access (e.g. if the gas price is too low or the transaction was only recently sent and not yet indexed) in which case this method may also return `null`.
  ///
  /// ---
  ///
  /// ```dart
  /// final transaction = await provider!.getTransaction(
  ///     '0x4e04def628cfd0c7786febaef8fbe832fc30eae54a4fba25bf46022c439ab39d');
  ///
  /// print(transaction); // Transaction: 0x4e04def6 from 0x1dFCD06a with value 0 and data 0x876cb21700000...
  /// print(transaction != null); // true
  /// print(transaction is TransactionResponse); // true
  /// ```
  Future<TransactionResponse?> getTransaction(String hash) async {
    final response =
        await call<_TransactionResponseImpl?>('getTransaction', [hash]);
    if (response != null) return TransactionResponse._(response);
  }

  /// Returns the number of transactions [address] has ever sent, as of [blockTag].
  ///
  /// This value is required to be the nonce for the next transaction from address sent to the network.
  Future<int> getTransactionCount(String address, [dynamic blockTag]) =>
      call<int>(
        'getTransactionCount',
        blockTag != null ? [address, blockTag] : [address],
      );

  /// Returns the [TransactionReceipt] for [hash] or `null` if the transaction has not been mined.
  ///
  /// To stall until the transaction has been mined, consider the [waitForTransaction] method.
  ///
  /// ---
  ///
  /// ```dart
  /// final transaction = await provider!.getTransactionReceipt(
  ///     '0x4e04def628cfd0c7786febaef8fbe832fc30eae54a4fba25bf46022c439ab39d');
  ///
  /// print(transaction); // TransactionReceipt: 0x4e04def6 from 0x1dFCD06a with 618 confirmations and 8 logs
  /// print(transaction != null); // true
  /// print(transaction is TransactionReceipt); // true
  /// ```
  Future<TransactionReceipt?> getTransactionReceipt(String hash) async {
    final receipt =
        await call<_TransactionReceiptImpl?>('getTransactionReceipt', [hash]);
    if (receipt != null) return TransactionReceipt._(receipt);
  }

  /// Add a [listener] to be triggered for each [event].
  on(dynamic event, Function listener) {
    assert(event is String || event is _EventFilterImpl,
        'Event type must be valid.');
    return callMethod(impl, 'on', [
      event is EventFilter ? event.impl : event,
      allowInterop(listener),
    ]);
  }

  /// Add a [listener] to be triggered for each new [Block];
  void onBlock(void Function(int blockNumber) listener) =>
      on('block', listener);

  /// Add a [listener] to be triggered once for [event].
  once(dynamic event, Function listener) {
    assert(event is String || event is _EventFilterImpl,
        'Event type must be valid.');
    return callMethod(impl, 'on', [
      event is EventFilter ? event.impl : event,
      allowInterop(listener),
    ]);
  }

  /// Add a [listener] to be triggered once for new [Block];
  void onceBlock(void Function(int blockNumber) listener) =>
      on('block', listener);

  /// Add a [listener] to be triggered once for [filter];
  void onceFilter(EventFilter filter, Function listener) =>
      on(filter.impl, listener);

  /// Add a [listener] to be triggered for [filter];
  void onFilter(EventFilter filter, Function listener) =>
      on(filter.impl, listener);

  /// Returns the result of executing the transaction, using call.
  ///
  /// A call does not require any ether, but cannot change any state. This is useful for calling getters on Contracts.
  Future<T> rawCall<T>(String to, String data, [dynamic blockTag]) =>
      promiseToFuture<T>(callMethod(
        this,
        'call',
        blockTag != null
            ? [_RawTxParamsImpl(to: to, data: data), blockTag]
            : [_RawTxParamsImpl(to: to, data: data)],
      ));

  /// Submits transaction [data] to the network to be mined.
  ///
  /// The transaction must be signed, and be valid (i.e. the nonce is correct and the account has sufficient balance to pay for the transaction).
  ///
  /// ```dart
  /// await provider!.sendTransaction("0xf86e808502540be400825208948ba1f109551bd432803012645ac136ddd64dba72880de0b6b3a764000080820a96a0f0c5bcb11e5a16ab116c60a0e5837ae98ec36e7f217740076572e8183002edd2a01ed1b4411c2840b9793e8be5415a554507f1ea320069be6dcecabd7b9097dbd4");
  /// ```
  Future<TransactionResponse> sendTransaction(String data) async =>
      TransactionResponse._(
          await call<_TransactionResponseImpl>('sendTransaction', [data]));

  /// Returns a Future of [TransactionReceipt] which will not resolve until [transactionHash] is mined.
  ///
  /// If confirms is 0, this method is non-blocking and if the transaction has not been mined returns null.
  ///
  /// Otherwise, this method will block until the transaction has confirms blocks mined on top of the block in which is was mined.
  ///
  /// ---
  ///
  /// ```dart
  /// final transaction = await provider!.waitForTransaction('0x4e04def628cfd0c7786febaef8fbe832fc30eae54a4fba25bf46022c439ab39d');
  ///
  /// print(transaction); // TransactionReceipt: 0x4e04def6 from 0x1dFCD06a with 618 confirmations and 8 logs
  /// print(transaction is TransactionReceipt); // true
  /// ```
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

/// The Web3Provider is meant to ease moving from a web3.js based application to ethers by wrapping an existing Web3-compatible (such as a Web3HttpProvider, Web3IpcProvider or Web3WsProvider) and exposing it as an ethers.js Provider which can then be used with the rest of the library.
///
/// This may also be used to wrap a standard [EIP-1193 Provider](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1193.md).
class Web3Provider extends Provider<_Web3ProviderImpl> {
  /// Create new [Web3Provider] instance from [provider] instance.
  ///
  /// ---
  ///
  /// ```dart
  /// final web3provider = Web3Provider(ethereum!);
  /// print(web3provider); // Web3Provider:
  /// ```
  factory Web3Provider(dynamic provider) {
    assert(provider != null, 'Provider must not be null.');
    assert(
        provider is Interop &&
            (provider is Ethereum || provider is WalletConnectProvider),
        'Provider type must be valid.');
    return Web3Provider._(
      _Web3ProviderImpl((provider as Interop).impl),
    );
  }

  /// Create new [Web3Provider] instance from [ethereum] instance.
  ///
  /// ---
  ///
  /// ```dart
  /// final web3provider = Web3Provider.fromEthereum(ethereum!);
  /// print(web3provider); // Web3Provider:
  /// ```
  factory Web3Provider.fromEthereum(Ethereum ethereum) =>
      Web3Provider._(_Web3ProviderImpl(ethereum.impl));

  /// Create new [Web3Provider] instance from [walletConnect] instance.
  ///
  /// ---
  ///
  /// ```dart
  /// Web3Provider? web3provider;
  ///
  /// final wc = WalletConnectProvider.binance();
  /// await wc.connect();
  ///
  /// if (wc.connected) web3provider = Web3Provider.fromWalletConnect(wc);
  ///
  /// print(web3provider); // Web3Provider:
  /// ```
  factory Web3Provider.fromWalletConnect(WalletConnectProvider walletConnect) =>
      Web3Provider._(_Web3ProviderImpl(walletConnect.impl));

  const Web3Provider._(_Web3ProviderImpl impl) : super._(impl);

  /// Connect [this] to create [Signer] object.
  Signer getSigner() => Signer._(impl.getSigner());

  @override
  String toString() => 'Web3Provider:';
}
