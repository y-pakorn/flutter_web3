@JS("WalletConnectProvider")
library wallet_connect_provider;

import 'dart:core';

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:meta/meta.dart';

import '../ethereum/ethereum.dart';
import '../ethereum/utils.dart';

part 'interop.dart';

@internal
_WalletConnectProviderImpl getWalletConnectImpl(WalletConnectProvider wc) =>
    wc._impl;

/// Function to convert Dart rpc map into JS rpc map.
dynamic _convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);

/// Web3 Provider for Wallet Connect connection, typically used in mobile phone connection.
class WalletConnectProvider implements _WalletConnectProviderImpl {
  final _WalletConnectProviderImpl _impl;

  /// Instantiate [WalletConnectProvider] using [infuraId].
  factory WalletConnectProvider.fromInfura(
    String infuraId, {
    String? network,
    String? bridge,
    bool? qrCode,
    int? chainId,
    int? networkId,
    List<String>? mobileLinks,
  }) =>
      WalletConnectProvider._(
        _WalletConnectProviderImpl(
          _WalletConnectProviderOptionsImpl(
            infuraId: infuraId,
            network: network,
            bridge: bridge,
            qrCode: qrCode,
            chainId: chainId,
            networkId: networkId,
            qrcodeModalOptions: mobileLinks != null
                ? _QrcodeModalOptionsImpl(mobileLinks: mobileLinks)
                : null,
          ),
        ),
      );

  /// Instantiate [WalletConnectProvider] using [rpc].
  factory WalletConnectProvider.fromRpc(
    Map<int, String> rpc, {
    String? network,
    String? bridge,
    bool? qrCode,
    required int chainId,
    int? networkId,
    List<String>? mobileLinks,
  }) {
    assert(rpc.containsKey(chainId), 'Chain id must be in rpc map.');
    return WalletConnectProvider._(
      _WalletConnectProviderImpl(
        _WalletConnectProviderOptionsImpl(
          rpc: _convertRpc(rpc),
          network: network,
          bridge: bridge,
          qrCode: qrCode,
          chainId: chainId,
          networkId: networkId,
          qrcodeModalOptions: mobileLinks != null
              ? _QrcodeModalOptionsImpl(mobileLinks: mobileLinks)
              : null,
        ),
      ),
    );
  }

  const WalletConnectProvider._(this._impl);

  /// Accounts which is at provider disposal.
  @override
  List<String> get accounts => _impl.accounts;

  /// Main network chain id.
  @override
  String get chainId => _impl.chainId;

  /// `true` if [this] is connected successfully to rpc provider.
  @override
  bool get connected => _impl.connected;

  /// `true` if [this] is connecting successfully to rpc provider.
  @override
  bool get isConnecting => _impl.isConnecting;

  /// Chain id and rpc url map.
  Map<int, String> get rpc => (convertToDart(getProperty(_impl, 'rpc')) as Map)
      .map((key, value) => MapEntry(int.parse(key), value.toString()));

  /// Main network rpc url.
  @override
  String get rpcUrl => _impl.rpcUrl;

  /// Connected wallet metadata, contains serveral information about connected provider.
  @override
  WalletMeta get walletMeta => WalletMeta._internal(_impl.walletMeta);

  /// Enable session and try to connect to provider. (triggers QR Code modal)
  Future<void> connect() => promiseToFuture(callMethod(_impl, 'enable', []));

  /// Close provider session.
  Future<void> disconnect() =>
      promiseToFuture(callMethod(_impl, 'disconnect', []));

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  @override
  int listenerCount([String? eventName]) => _impl.listenerCount(eventName);

  /// Returns the list of Listeners for the [eventName] events.
  @override
  List listeners(String eventName) => _impl.listeners(eventName);

  /// Remove a [listener] for the [eventName] event. If no [listener] is provided, all listeners for [eventName] are removed.
  off(String eventName, [Function? listener]) => callMethod(_impl, 'off',
      listener != null ? [eventName, allowInterop(listener)] : [eventName]);

  /// Add a [listener] to be triggered for each [eventName] event.
  on(String eventName, Function listener) =>
      callMethod(_impl, 'on', [eventName, allowInterop(listener)]);

  /// Add a [listener] to be triggered for each accountsChanged event.
  onAccountsChanged(void Function(List<String> accounts) listener) => on(
      'accountsChanged',
      (List<dynamic> accs) => listener(accs.map((e) => e.toString()).toList()));

  /// Add a [listener] to be triggered for only the next [eventName] event, at which time it will be removed.
  once(String eventName, Function listener) =>
      callMethod(_impl, 'once', [eventName, allowInterop(listener)]);

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
  onDisconnect(void Function(ProviderRpcError error) listeners) =>
      on('disconnect', (ProviderRpcError error) => listeners(error));

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
  @override
  removeAllListeners([String? eventName]) =>
      _impl.removeAllListeners(eventName);

  @override
  String toString() => connected
      ? 'connected to $rpcUrl($chainId) with $accounts'
      : 'not connected to $rpcUrl($chainId)';

  /// Instantiate [WalletConnectProvider] object with `Binance Mainnet` rpc and QR code enabled, ready to connect.
  static WalletConnectProvider binance() => WalletConnectProvider.fromRpc(
        {56: 'https://bsc-dataseed.binance.org/'},
        chainId: 56,
        network: 'binance',
      );
}

/// Metadata information of specific wallet provider.
class WalletMeta implements _WalletMetaImpl {
  final _WalletMetaImpl _impl;

  const WalletMeta._internal(this._impl);

  /// Description of wallet.
  @override
  String get description => _impl.description;

  /// List wallet's icons.
  @override
  List<String> get icons => _impl.icons.cast<String>();

  /// Full name of wallet.
  @override
  String get name => _impl.name;

  /// Url of wallet.
  @override
  String get url => _impl.url;

  @override
  String toString() => '$name on $url';
}
