@JS("WalletConnectProvider")
library wallet_connect_provider;

import 'dart:core';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import '../ethereum/ethereum.dart';
import '../ethereum/ethereum_utils.dart';

part 'interop.dart';
part 'utils.dart';

class WalletConnectProvider implements _WalletConnectProviderImpl {
  final _WalletConnectProviderImpl _impl;

  factory WalletConnectProvider.fromInfura(
    String infuraId, {
    String? network,
    String? bridge,
    bool? qrCode,
    int? chainId,
    int? networkId,
    List<String>? mobileLinks,
  }) =>
      WalletConnectProvider._internal(
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

  factory WalletConnectProvider.fromRpc(
    Map<int, String> rpc, {
    String? network,
    String? bridge,
    bool? qrCode,
    int? chainId,
    int? networkId,
    List<String>? mobileLinks,
  }) =>
      WalletConnectProvider._internal(
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
  const WalletConnectProvider._internal(this._impl);

  @override
  List<String> get accounts => _impl.accounts;

  @override
  String get chainId => _impl.chainId;

  @override
  bool get connected => _impl.connected;

  @override
  bool get isConnecting => _impl.isConnecting;

  Map<int, String> get rpc => (convertToDart(getProperty(_impl, 'rpc')) as Map)
      .map((key, value) => MapEntry(int.parse(key), value.toString()));

  @override
  String get rpcUrl => _impl.rpcUrl;

  @override
  WalletMeta get walletMeta => WalletMeta._internal(_impl.walletMeta);

  /// Enable session (triggers QR Code modal)
  Future<void> connect() => promiseToFuture(callMethod(_impl, 'enable', []));

  /// Close provider session
  Future<void> disconnect() =>
      promiseToFuture(callMethod(_impl, 'disconnect', []));

  @override
  int listenerCount([String? eventName]) => _impl.listenerCount(eventName);

  @override
  List listeners(String eventName) => _impl.listeners(eventName);

  @override
  removeAllListeners([String? eventName]) =>
      _impl.removeAllListeners(eventName);

  @override
  String toString() => connected
      ? 'connected to $rpcUrl($chainId) with $accounts'
      : 'not connected to $rpcUrl($chainId)';

  static WalletConnectProvider binance = WalletConnectProvider.fromRpc(
    {56: 'https://bsc-dataseed.binance.org/'},
    chainId: 56,
    network: 'binance',
  );
}

class WalletMeta implements _WalletMetaImpl {
  final _WalletMetaImpl _impl;

  const WalletMeta._internal(this._impl);

  @override
  String get description => _impl.description;

  @override
  List<String> get icons => _impl.icons;

  @override
  String get name => _impl.name;

  @override
  String get url => _impl.url;

  @override
  String toString() => '$name on $url';
}
