@JS("WalletConnectProvider")
library wallet_connect_provider;

import 'dart:core';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../ethereum/ethereum.dart';
import '../ethereum/utils.dart';
import '../interop_wrapper.dart';

part 'interop.dart';

/// Function to convert Dart rpc map into JS rpc map.
dynamic _convertRpc(Map<int, String> rpcMap) => jsify(rpcMap);

/// Provider for Wallet Connect connection, typically used in mobile phone connection.
class WalletConnectProvider extends Interop<_WalletConnectProviderImpl> {
  /// Instantiate [WalletConnectProvider] using [infuraId].
  ///
  /// ---
  ///
  /// ```dart
  /// final wc = WalletConnectProvider.fromInfura('https://foo.infura.io/v3/barbaz');
  ///
  /// await wc.connect();
  ///
  /// print(wc); // WalletConnectProvider: connected to https://foo.infura.io/v3/barbaz with [0xfooBar]
  /// print(wc.connected); // true
  /// print(wc.walletMeta); // WalletMeta: Trust Wallet on https://trustwallet.com
  /// ```
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
  ///
  /// ---
  ///
  /// ```dart
  /// final wc = WalletConnectProvider.fromRpc(
  ///   {56: 'https://bsc-dataseed.binance.org/'},
  ///   chainId: 56,
  ///   network: 'binance',
  /// );
  ///
  /// await wc.connect();
  ///
  /// print(wc); // WalletConnectProvider: connected to https://bsc-dataseed.binance.org/ (56) with [0xfooBar]
  /// print(wc.connected); // true
  /// print(wc.walletMeta); // WalletMeta: Trust Wallet on https://trustwallet.com
  /// ```
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

  const WalletConnectProvider._(_WalletConnectProviderImpl impl)
      : super.internal(impl);

  /// Accounts which is at provider disposal.
  List<String> get accounts => impl.accounts;

  /// Main network chain id.
  String get chainId => impl.chainId;

  /// `true` if [this] is connected successfully to rpc provider.
  bool get connected => impl.connected;

  /// `true` if [this] is connecting successfully to rpc provider.
  bool get isConnecting => impl.isConnecting;

  /// Chain id and rpc url map.
  Map<int, String> get rpc => (convertToDart(getProperty(impl, 'rpc')) as Map)
      .map((key, value) => MapEntry(int.parse(key), value.toString()));

  /// Main network rpc url.
  String get rpcUrl => impl.rpcUrl;

  /// Connected wallet metadata, contains serveral information about connected provider.
  WalletMeta get walletMeta => WalletMeta._(impl.walletMeta);

  /// Enable session and try to connect to provider. (triggers QR Code modal)
  Future<void> connect() => promiseToFuture(callMethod(impl, 'enable', []));

  /// Close provider session.
  Future<void> disconnect() =>
      promiseToFuture(callMethod(impl, 'disconnect', []));

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

  @override
  String toString() => connected
      ? 'WalletConnectProvider: connected to $rpcUrl ($chainId) with $accounts'
      : 'WalletConnectProvider: not connected to $rpcUrl($chainId)';

  /// Instantiate [WalletConnectProvider] object with `Binance Mainnet` rpc and QR code enabled, ready to connect.
  static WalletConnectProvider binance() => WalletConnectProvider.fromRpc(
        {56: 'https://bsc-dataseed.binance.org/'},
        chainId: 56,
        network: 'binance',
      );
}

/// Metadata information of specific wallet provider.
class WalletMeta extends Interop<_WalletMetaImpl> {
  const WalletMeta._(_WalletMetaImpl impl) : super.internal(impl);

  /// Description of wallet.
  String get description => impl.description;

  /// List wallet's icons.
  List<String> get icons => impl.icons.cast<String>();

  /// Full name of wallet.
  String get name => impl.name;

  /// Url of wallet.
  String get url => impl.url;

  @override
  String toString() => 'WalletMeta: $name on $url';
}
