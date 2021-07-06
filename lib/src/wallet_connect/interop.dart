part of wallet_connect_provider;

@JS()
@anonymous
class _QrcodeModalOptionsImpl {
  external factory _QrcodeModalOptionsImpl({List<String> mobileLinks});

  external List<String> get mobileLinks;
}

@JS("default")
class _WalletConnectProviderImpl extends EthereumBaseImpl {
  external _WalletConnectProviderImpl(
      _WalletConnectProviderOptionsImpl options);

  external List<String> get accounts;

  external bool get connected;

  external bool get isConnecting;

  external String get rpcUrl;

  external _WalletMetaImpl get walletMeta;
}

@JS()
@anonymous
class _WalletConnectProviderOptionsImpl {
  external factory _WalletConnectProviderOptionsImpl({
    String? infuraId,
    dynamic rpc,
    String? bridge,
    bool? qrCode,
    String? network,
    int? chainId,
    int? networkId,
    _QrcodeModalOptionsImpl? qrcodeModalOptions,
  });

  external String? get bridge;

  external int? get chainId;

  external String? get infuraId;

  external String? get network;

  external bool? get qrCode;

  external _QrcodeModalOptionsImpl? get qrcodeModalOptions;

  external dynamic get rpc;
}

@JS()
@anonymous
class _WalletMetaImpl {
  external String get description;

  external List<String> get icons;

  external String get name;

  external String get url;
}
