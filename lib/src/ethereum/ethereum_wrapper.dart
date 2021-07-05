import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../objects/objects.dart';
import 'ethereum.dart';
import 'ethereum_utils.dart';

extension EthereumExtension on EthereumBase {
  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  once(String eventName, Function listener) =>
      callMethod(this, 'once', [eventName, allowInterop(listener)]);

  /// Add a [listener] to be triggered for each [eventName] event.
  on(String eventName, Function listener) =>
      callMethod(this, 'on', [eventName, allowInterop(listener)]);

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  off(String eventName, [Function? listener]) => callMethod(this, 'off',
      listener != null ? [eventName, allowInterop(listener)] : [eventName]);

  /// Add a [listener] to be triggered for each accountsChanged event.
  onAccountsChanged(void Function(List<String> accounts) listener) => on(
      'accountsChanged',
      (List<dynamic> accs) => listener(accs.map((e) => e.toString()).toList()));

  /// Add a [listener] to be triggered for each chainChanged event.
  onChainChanged(void Function(int chainId) listener) =>
      on('chainChanged', (dynamic cId) => listener(int.parse(cId.toString())));

  /// Add a [listener] to be triggered for each disconnect event.
  ///
  /// This event is emitted if it becomes unable to submit RPC requests to any chain. In general, this will only happen due to network connectivity issues or some unforeseen error.
  ///
  /// Once disconnect has been emitted, the provider will not accept any new requests until the connection to the chain has been re-restablished, which requires reloading the page. You can also use the [Ethereum.isConnected] method to determine if the provider is disconnected.
  onDisconnect(void Function(ProviderRpcError error) listeners) =>
      on('disconnect', (ProviderRpcError error) => listeners(error));

  /// Add a [listener] to be triggered for each connect event.
  ///
  /// This event is emitted when it first becomes able to submit RPC requests to a chain.
  ///
  /// We recommend using a connect event handler and the [Ethereum.isConnected] method in order to determine when/if the provider is connected.
  onConnect(void Function(ConnectInfo connectInfo) listener) =>
      on('connect', listener);

  /// Add a [listener] to be triggered for each message event.
  ///
  /// The MetaMask provider emits this event when it receives some message that the consumer should be notified of. The kind of message is identified by the type string.
  ///
  /// RPC subscription updates are a common use case for the message event. For example, if you create a subscription using `eth_subscribe`, each subscription update will be emitted as a message event with a type of `eth_subscription`.
  onMessage(void Function(String type, dynamic data) listener) => on(
      'message',
      (ProviderMessage message) =>
          listener(message.type, convertToDart(message.data)));

  /// Use request to submit RPC requests to Ethereum via MetaMask or provider that is currently using.
  ///
  /// Returns a Future of type [T] that resolves to the result of the RPC method call.
  Future<T> request<T>(String method, [dynamic params]) =>
      promiseToFuture<T>(callMethod(this, 'request', [
        params != null
            ? RequestArguments(method: method, params: params)
            : RequestArguments(method: method)
      ]));

  /// Creates a confirmation asking the user to add the specified chain to MetaMask.
  ///
  /// The user may choose to switch to the chain once it has been added.
  ///
  /// As with any method that causes a confirmation to appear, wallet_addEthereumChain should only be called as a result of direct user action, such as the click of a button.
  Future<void> walletAddChain(List<ChainParams> chainList) =>
      request('wallet_addEthereumChain', chainList);

  /// Requests that the user tracks the token in MetaMask.
  ///
  /// Returns [bool] `true` if token is successfully added.
  ///
  /// Most Ethereum wallets support some set of tokens, usually from a centrally curated registry of tokens. wallet_watchAsset enables web3 application developers to ask their users to track tokens in their wallets, at runtime. Once added, the token is indistinguishable from those added via legacy methods, such as a centralized registry.
  Future<bool> walletWatchAssets(WatchAssetOptions options,
          [String type = 'ERC20']) =>
      request<bool>(
          'wallet_watchAsset', WatchAssetParams(type: type, options: options));

  /// Request/Enable the accounts from the current environment.
  ///
  /// Returns List of accounts the node controls.
  ///
  /// This method will only work if you’re using the injected provider from a application like Metamask, Status or TrustWallet.
  ///
  /// It doesn’t work if you’re connected to a node with a default Web3.js provider (WebsocketProvider, HttpProvidder and IpcProvider).
  Future<List<String>> requestAccount() async =>
      (await request<List<dynamic>>('eth_requestAccounts'))
          .map((e) => e.toString())
          .toList();

  /// Returns List of accounts the node controls.
  Future<List<String>> getAccounts() async =>
      (await request<List<dynamic>>('eth_accounts'))
          .map((e) => e.toString())
          .toList();

  /// Returns chain id in [int]
  Future<int> getChainId() async =>
      int.parse((await request('eth_chainId')).toString());
}
