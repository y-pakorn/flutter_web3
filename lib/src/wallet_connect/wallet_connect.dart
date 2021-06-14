@JS("WalletConnectProvider")
library wallet_connect_provider;

import 'dart:core';

import 'package:js/js.dart';

import '../ethereum/ethereum.dart';

@JS()
@anonymous
class QrcodeModalOptions {
  external factory QrcodeModalOptions({List<String> mobileLinks});

  external List<String> get mobileLinks;
}

@JS("default")
class WalletConnectProvider extends Ethereum {
  ///  Create WalletConnect Provider object.
  external WalletConnectProvider(WalletConnectProviderOptions options);
}

@JS()
@anonymous
class WalletConnectProviderOptions {
  /// Required one of [infuraId] or [rpc] to be not null.
  external factory WalletConnectProviderOptions({
    String? infuraId,
    Map<int, String>? rpc,
    String? bridge,
    bool? qrCode,
    String? network,
    int? chainId,
    int? networkId,
    QrcodeModalOptions? qrcodeModalOptions,
  });

  external String? get bridge;
  external int? get chainId;
  external String? get infuraId;
  external String? get network;
  external int? get networkId;
  external bool? get qrCode;
  external QrcodeModalOptions? get qrcodeModalOptions;
  external Map<int, String>? get rpc;
}
