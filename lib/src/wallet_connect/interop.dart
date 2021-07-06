part of wallet_connect_provider;

@JS()
@anonymous
class _QrcodeModalOptionsImpl {
  external factory _QrcodeModalOptionsImpl({List<String> mobileLinks});

  external List<String> get mobileLinks;
}

@JS("default")
class _WalletConnectProviderImpl extends EthereumBase {
  ///  Create WalletConnect Provider object.
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
  /// Required one of [infuraId] or [rpc] to be not null.
  ///
  /// [rpc] must be js object type, thus can be instantiate with [convertRpc] function or wrap [Map] with [jsify].
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

  /// Main network chain id.
  external int? get chainId;

  /// The infuraId will support the following chainId's: Mainnet (1), Ropsten (3), Rinkeby(4), Goerli (5) and Kovan (42).
  external String? get infuraId;

  /// Main network name.
  external String? get network;

  /// Whether to enable QR Code modal
  external bool? get qrCode;

  external _QrcodeModalOptionsImpl? get qrcodeModalOptions;

  /// The RPC URL mapping should be indexed by chainId and it requires at least one value.
  ///
  /// [rpc] must be js object type, thus can be instantiate with [convertRpc] function.
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
