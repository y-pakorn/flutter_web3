@JS("window")
library ethereum;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import './utils.dart';
import '../interop_wrapper.dart';
import 'exception.dart';

part 'interop.dart';

/// Getter for default Ethereum object, cycles through available injector in environment.
Ethereum? get ethereum => Ethereum.provider;

/// Interface for connection info used by [Ethereum] method.
@JS()
@anonymous
class ConnectInfo {
  /// Chain id in hex that is currently connected to.
  external String get chainId;
}

/// Parameter for specifying currency, used in [Ethereum.walletAddChain].
class CurrencyParams extends Interop<_CurrencyParamsImpl> {
  /// Instantiate [CurrencyParams] by using [name], [symbol], and [decimals].
  ///
  /// ---
  ///
  /// ```dart
  /// // Instantiate new `CurrencyParams` object.
  /// final currency = CurrencyParams(
  ///   name: 'Binance Coin',
  ///   symbol: 'BNB',
  ///   decimals: 18,
  /// );
  /// ```
  factory CurrencyParams({
    required String name,
    required String symbol,
    required int decimals,
  }) =>
      CurrencyParams._(
          _CurrencyParamsImpl(name: name, symbol: symbol, decimals: decimals));

  const CurrencyParams._(_CurrencyParamsImpl impl) : super.internal(impl);

  int get decimals => impl.decimals;

  String get name => impl.name;

  String get symbol => impl.symbol;
}

/// A Dart Ethereum Provider API for consistency across clients and applications.
class Ethereum extends Interop<_EthereumImpl> {
  /// Ethereeum provider api used in Binance Chain Wallet.
  static Ethereum get binanceChain => Ethereum._(_binanceChain!);

  /// Modern Ethereum provider api, injected by many famous environment such as `MetaMask` or `TrustWallet`.
  static Ethereum get ethereum => Ethereum._(_ethereum!);

  /// Getter for boolean to detect Ethereum object support. without calling itself to prevent js undefined error.
  static bool get isSupported =>
      hasProperty(_window, 'ethereum') || hasProperty(_window, 'BinanceChain');

  /// Getter for default Ethereum provider object, cycles through available injector in environment.
  static Ethereum? get provider => isSupported
      ? _ethereum != null
          ? Ethereum._(_ethereum!)
          : Ethereum._(_binanceChain!)
      : null;

  /// Old web3 object, deprecated now.
  @deprecated
  static Ethereum? get web3 => _web3 != null ? Ethereum._(_web3!) : null;

  const Ethereum._(_EthereumImpl impl) : super.internal(impl);

  set autoRefreshOnNetworkChange(bool b) => impl.autoRefreshOnNetworkChange = b;

  /// Returns a hexadecimal string representing the current chain ID.
  ///
  /// Deprecated, Consider using [getChainId] instead.
  @deprecated
  String get chainId => impl.chainId;

  /// Returns first [getAccounts] item but may return unexpected value.
  ///
  /// Deprecated, Consider using [getAccounts] instead.
  @deprecated
  String? get selectedAddress => impl.selectedAddress;

  /// Returns List of accounts the node controls.
  Future<List<String>> getAccounts() async =>
      (await request<List<dynamic>>('eth_accounts'))
          .map((e) => e.toString())
          .toList();

  /// Returns chain id in [int]
  ///
  /// ---
  ///
  /// ```dart
  /// String? currentAddress;
  /// int? currentChain;
  ///
  /// connectProvider() async {
  ///   if (ethereum != null) {
  ///     final accs = await ethereum!.requestAccount();
  ///
  ///     if (accs.isNotEmpty) {
  ///       currentAddress = accs.first;
  ///       currentChain = await ethereum!.getChainId();
  ///     }
  ///   }
  /// }
  /// ```
  Future<int> getChainId() async =>
      int.parse((await request('eth_chainId')).toString());

  /// Returns `true` if the provider is connected to the current chain, and `false` otherwise.
  ///
  /// Note that this method has nothing to do with the user's accounts.
  ///
  /// You may often encounter the word `connected` in reference to whether a web3 site can access the user's accounts. In the provider interface, however, `connected` and `disconnected` refer to whether the provider can make RPC requests to the current chain.
  ///
  /// ---
  ///
  /// ```dart
  /// // To check if provider is connected to current chain
  /// ethereum!.isConnected() // true
  ///
  /// // To check if provider is connected to current chain and connected to user accounts i.e. ready to use
  /// ethereum!.isConnected() && (await getAccounts()).isNotEmpty; // true
  /// ```
  bool isConnected() => impl.isConnected();

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  int listenerCount([String? eventName]) => impl.listenerCount(eventName);

  /// Returns the list of Listeners for the [eventName] events.
  List listeners(String eventName) => impl.listeners(eventName);

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  off(String eventName, [Function? listener]) => callMethod(impl, 'off',
      listener != null ? [eventName, allowInterop(listener)] : [eventName]);

  /// Add a [listener] to be triggered for each [eventName] event.
  on(String eventName, Function listener) =>
      callMethod(impl, 'on', [eventName, allowInterop(listener)]);

  /// Add a [listener] to be triggered for each accountsChanged event.
  onAccountsChanged(void Function(List<String> accounts) listener) => on(
      'accountsChanged',
      (List<dynamic> accs) => listener(accs.map((e) => e.toString()).toList()));

  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  once(String eventName, Function listener) =>
      callMethod(impl, 'once', [eventName, allowInterop(listener)]);

  /// Add a [listener] to be triggered for each chainChanged event.
  onChainChanged(void Function(int chainId) listener) =>
      on('chainChanged', (dynamic cId) => listener(int.parse(cId.toString())));

  /// Add a [listener] to be triggered for each connect event.
  ///
  /// This event is emitted when it first becomes able to submit RPC requests to a chain.
  ///
  /// We recommend using a connect event handler and the [Ethereum.isConnected] method in order to determine when/if the provider is connected.
  onConnect(void Function(ConnectInfo connectInfo) listener) =>
      on('connect', listener);

  /// Add a [listener] to be triggered for each disconnect event.
  ///
  /// This event is emitted if it becomes unable to submit RPC requests to any chain. In general, this will only happen due to network connectivity issues or some unforeseen error.
  ///
  /// Once disconnect has been emitted, the provider will not accept any new requests until the connection to the chain has been re-restablished, which requires reloading the page. You can also use the [Ethereum.isConnected] method to determine if the provider is disconnected.
  onDisconnect(void Function(ProviderRpcError error) listener) =>
      on('disconnect', (ProviderRpcError error) => listener(error));

  /// Add a [listener] to be triggered for each message event [type].
  ///
  /// The MetaMask provider emits this event when it receives some message that the consumer should be notified of. The kind of message is identified by the type string.
  ///
  /// RPC subscription updates are a common use case for the message event. For example, if you create a subscription using `eth_subscribe`, each subscription update will be emitted as a message event with a type of `eth_subscription`.
  onMessage(void Function(String type, dynamic data) listener) => on(
      'message',
      (ProviderMessage message) =>
          listener(message.type, convertToDart(message.data)));

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  removeAllListeners([String? eventName]) => impl.removeAllListeners(eventName);

  /// Use request to submit RPC requests with [method] and optionally [params] to Ethereum via MetaMask or provider that is currently using.
  ///
  /// Returns a Future of generic type that resolves to the result of the RPC method call.
  Future<T> request<T>(String method, [dynamic params]) async {
    try {
      switch (T) {
        case BigInt:
          return BigInt.parse(await request<String>(method, params)) as T;
        default:
          return await promiseToFuture<T>(
            callMethod(
              impl,
              'request',
              [
                _RequestArgumentsImpl(
                    method: method, params: params != null ? params : [])
              ],
            ),
          );
      }
    } catch (error) {
      final err = convertToDart(error);
      switch (err['code']) {
        case 4001:
          throw EthereumUserRejected();
        default:
          if (err['message'] != null)
            throw EthereumException(err['code'], err['message'], err['data']);
          else
            rethrow;
      }
    }
  }

  /// Request/Enable the accounts from the current environment.
  ///
  /// Returns List of accounts the node controls.
  ///
  /// This method will only work if you’re using the injected provider from a application like Metamask, Status or TrustWallet.
  ///
  /// It doesn’t work if you’re connected to a node with a default Web3.js provider (WebsocketProvider, HttpProvidder and IpcProvider).
  ///
  /// ---
  ///
  /// ```dart
  /// String? currentAddress;
  /// int? currentChain;
  ///
  /// // Handle `requestAccount` and store accounts and chain information
  /// connectProvider() async {
  ///   if (ethereum != null) {
  ///     final accs = await ethereum!.requestAccount();
  ///
  ///     if (accs.isNotEmpty) {
  ///       currentAddress = accs.first;
  ///       currentChain = await ethereum!.getChainId();
  ///     }
  ///   }
  /// }
  /// ```
  Future<List<String>> requestAccount() async =>
      (await request<List<dynamic>>('eth_requestAccounts')).cast<String>();

  @override
  String toString() => isSupported
      ? isConnected() && selectedAddress != null
          ? 'Ethereum: connected to chain ${int.tryParse(chainId)} with $selectedAddress'
          : 'Ethereum: not connected to chain ${int.tryParse(chainId)}'
      : 'Ethereum: provider not supported';

  /// Creates a confirmation asking the user to add the specified chain with [chainId], [chainName], [nativeCurrency], and [rpcUrls] to MetaMask.
  ///
  /// The user may choose to switch to the chain once it has been added.
  ///
  /// As with any method that causes a confirmation to appear, `wallet_addEthereumChain` should only be called as a result of direct user action, such as the click of a button.
  ///
  /// ---
  ///
  /// ```dart
  /// // Add chain 97
  /// await ethereum!.walletAddChain(
  ///   chainId: 97,
  ///   chainName: 'Binance Testnet',
  ///   nativeCurrency: CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
  ///   rpcUrls: ['https://data-seed-prebsc-1-s1.binance.org:8545/'],
  /// );
  /// ```
  Future<void> walletAddChain({
    required int chainId,
    required String chainName,
    required CurrencyParams nativeCurrency,
    required List<String> rpcUrls,
    List<String>? blockExplorerUrls,
  }) =>
      request('wallet_addEthereumChain', [
        _ChainParamsImpl(
          chainId: '0x' + chainId.toRadixString(16),
          chainName: chainName,
          nativeCurrency: nativeCurrency.impl,
          rpcUrls: rpcUrls,
          blockExplorerUrls: blockExplorerUrls,
        )
      ]);

  /// Creates a confirmation asking the user to switch to the chain with the specified [chainId].
  ///
  /// If the specified chain ID has not been added, [unrecognizedChainHandler] will be called if not `null`.
  /// Else will throw [EthereumUnrecognizedChainException].
  ///
  /// As with any method that causes a confirmation to appear, `wallet_switchEthereumChain` should only be called as a result of direct user action, such as the click of a button.
  ///
  /// MetaMask will automatically reject the request under the following circumstances:
  /// - If the chain ID is malformed
  /// - If the chain with the specified chain ID has not been added to MetaMask
  ///
  /// ---
  ///
  /// // Switch to chain 97 and add the chain when unrecognized
  /// ```dart
  /// await ethereum!.walletSwitchChain(97, () async {
  ///   await ethereum!.walletAddChain(
  ///     chainId: 97,
  ///     chainName: 'Binance Testnet',
  ///     nativeCurrency:
  ///         CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
  ///     rpcUrls: ['https://data-seed-prebsc-1-s1.binance.org:8545/'],
  ///   );
  /// });
  ///
  /// // Or catch `EthereumUnrecognizedChainException`
  /// try {
  ///   await ethereum!.walletSwitchChain(97);
  /// } on EthereumUnrecognizedChainException {
  ///   await ethereum!.walletAddChain(
  ///     chainId: 97,
  ///     chainName: 'Binance Testnet',
  ///     nativeCurrency:
  ///         CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
  ///     rpcUrls: ['https://data-seed-prebsc-1-s1.binance.org:8545/'],
  ///   );
  /// }
  /// ```
  Future<void> walletSwitchChain(int chainId,
      [void Function()? unrecognizedChainHandler]) async {
    try {
      await request('wallet_switchEthereumChain', [
        _AddEthereumChainParameterImpl(
            chainId: '0x' + chainId.toRadixString(16)),
      ]);
    } catch (error) {
      switch (convertToDart(error)['code']) {
        case 4902:
          unrecognizedChainHandler != null
              ? unrecognizedChainHandler.call()
              : throw EthereumUnrecognizedChainException(chainId);
          break;
        default:
          rethrow;
      }
    }
  }

  /// Requests that the user tracks the token with [address], [symbol], and [decimals] in MetaMask, [decimals] is optional.
  ///
  /// Returns `true` if token is successfully added.
  ///
  /// Ethereum protocal only support [type] that is `ERC20` for now.
  ///
  /// Most Ethereum wallets support some set of tokens, usually from a centrally curated registry of tokens. `wallet_watchAsset` enables web3 application developers to ask their users to track tokens in their wallets, at runtime. Once added, the token is indistinguishable from those added via legacy methods, such as a centralized registry.
  ///
  /// ---
  ///
  /// ```dart
  /// // Watch BUSD Token
  /// await ethereum!.walletWatchAssets(
  ///   address: '0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee',
  ///   symbol: 'BUSD',
  ///   decimals: 18,
  /// );
  /// ```
  Future<bool> walletWatchAssets({
    required String address,
    required String symbol,
    required int decimals,
    String? image,
    String type = 'ERC20',
  }) =>
      request<bool>(
        'wallet_watchAsset',
        _WatchAssetParamsImpl(
          type: type,
          options: _WatchAssetOptionsImpl(
            decimals: decimals,
            symbol: symbol,
            address: address,
            image: image,
          ),
        ),
      );
}

/// Interface for provier message used by [Ethereum] method.
@JS()
@anonymous
class ProviderMessage {
  /// The data of the message.
  external dynamic get data;

  /// The type of the message.
  ///
  /// If you create a subscription using `eth_subscribe`, each subscription update will be emitted as a message event with a type of `eth_subscription`.
  external String get type;
}

/// Interface for provier error used by [Ethereum] method.
@JS()
@anonymous
class ProviderRpcError {
  external int get code;

  external dynamic get data;

  external String get message;
}
