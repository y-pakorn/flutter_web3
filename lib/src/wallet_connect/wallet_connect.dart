@JS("WalletConnectProvider")
library wallet_connect_provider;

import 'dart:core';

import 'package:js/js.dart';

import '../ethereum/ethereum.dart';
import 'wallet_connect_wrapper.dart';

@JS()
@anonymous
class QrcodeModalOptions {
  external factory QrcodeModalOptions({List<String> mobileLinks});

  external List<String> get mobileLinks;
}

@JS("default")
class WalletConnectProvider extends EthereumBase {
  ///  Create WalletConnect Provider object.
  external WalletConnectProvider(WalletConnectProviderOptions options);

  external List<String> get accounts;

  external bool get connected;

  external bool get isConnecting;
}

/// Option for creating [WalletConnectProvider].
@JS()
@anonymous
class WalletConnectProviderOptions {
  /// Required one of [infuraId] or [rpc] to be not null.
  ///
  /// [rpc] must be js object type, thus can be instantiate with [convertRpc] function or wrap [Map] with [jsify].
  external factory WalletConnectProviderOptions({
    String? infuraId,
    dynamic rpc,
    String? bridge,
    bool? qrCode,
    String? network,
    int? chainId,
    int? networkId,
    QrcodeModalOptions? qrcodeModalOptions,
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

  external QrcodeModalOptions? get qrcodeModalOptions;

  /// The RPC URL mapping should be indexed by chainId and it requires at least one value.
  ///
  /// [rpc] must be js object type, thus can be instantiate with [convertRpc] function.
  external dynamic get rpc;
}
