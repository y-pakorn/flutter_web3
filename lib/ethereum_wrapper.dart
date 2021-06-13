import 'dart:js';
import 'dart:js_util';

import 'ethereum.dart';
import 'objects.dart';

extension DartEthereum on Ethereum {
  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  onceEvent(String eventName, void Function(dynamic event) listener) =>
      once(eventName, allowInterop(listener));

  /// Add a [listener] to be triggered for each [eventName] event.
  onEvent(String eventName, void Function(dynamic event) listener) =>
      on(eventName, allowInterop(listener));

  /// Add a [listener] to be triggered for each accountsChanged event
  onAccountsChanged(void Function(List<String> accounts) listener) =>
      on('accountsChanged', allowInterop(listener));

  /// Add a [listener] to be triggered for each chainChanged event
  onChainChanged(void Function(String chainId) listener) =>
      on('chainChanged', allowInterop(listener));

  /// Add a [listener] to be triggered for each disconnect event
  onDisconnect(void Function(dynamic error) listener) =>
      on('disconnect', allowInterop(listener));

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  offEvent(String eventName, [void Function(dynamic event)? listener]) =>
      listener != null
          ? off(eventName, allowInterop(listener))
          : off(eventName);

  /// Use request to submit RPC requests to Ethereum via MetaMask.
  ///
  /// Returns a Future of type [T] that resolves to the result of the RPC method call.
  Future<T> dartRequest<T>(String method, [dynamic params]) =>
      promiseToFuture<T>(request(
        params != null
            ? RequestArguments(method: method, params: params)
            : RequestArguments(method: method),
      ));

  /// Creates a confirmation asking the user to add the specified chain to MetaMask.
  ///
  /// The user may choose to switch to the chain once it has been added.
  ///
  /// As with any method that causes a confirmation to appear, wallet_addEthereumChain should only be called as a result of direct user action, such as the click of a button.
  Future<void> walletAddChain(List<ChainParams> chainList) => request(
        RequestArguments(
          method: 'wallet_addEthereumChain',
          params: chainList,
        ),
      );

  /// Requests that the user tracks the token in MetaMask.
  ///
  /// Returns [bool] true if token is successfully added.
  ///
  /// Most Ethereum wallets support some set of tokens, usually from a centrally curated registry of tokens. wallet_watchAsset enables web3 application developers to ask their users to track tokens in their wallets, at runtime. Once added, the token is indistinguishable from those added via legacy methods, such as a centralized registry.
  Future<bool> walletWatchAssets(WatchAssetOptions options,
          [String type = 'ERC20']) =>
      dartRequest<bool>(
          'wallet_watchAsset', WatchAssetParams(type: type, options: options));

  /// Request/Enable the accounts from the current environment.
  ///
  /// Returns [List<String>] of accounts the node controls.
  ///
  /// This method will only work if you’re using the injected provider from a application like Metamask, Status or TrustWallet.
  ///
  /// It doesn’t work if you’re connected to a node with a default Web3.js provider (WebsocketProvider, HttpProvidder and IpcProvider).
  Future<List<String>> requestAccount() async =>
      (await dartRequest<List<dynamic>>('eth_requestAccounts'))
          .map((e) => e.toString())
          .toList();

  /// Returns [List<String>] of accounts the node controls.
  Future<List<String>> getAccounts() async =>
      (await dartRequest<List<dynamic>>('eth_accounts'))
          .map((e) => e.toString())
          .toList();

  /// Returns chain id in [int]
  Future<int> getChainId() async =>
      int.parse((await dartRequest('eth_chainId')).toString());
}
