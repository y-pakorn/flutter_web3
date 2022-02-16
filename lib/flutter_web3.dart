import 'package:amdjs/amdjs.dart';

export './ethereum.dart';
export './ethers.dart';
export './src/constant.dart';
export './utils.dart';
export './wallet_connect.dart';

/// Static class for injecting required js module.
class FlutterWeb3 {
  /// Inject js module that required by this package by [injectionType]. Optinally [version] can be provided, otherwise `latest` is used.
  ///
  /// ---
  ///
  /// ```dart
  /// void main() async {
  ///   await FlutterWeb3.inject(FlutterWeb3InjectionTypes.ethers);
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> inject(FlutterWeb3InjectionTypes injectionType,
      [String version = 'latest']) async {
    AMDJS.verbose = false;

    await AMDJS.require(
      injectionType.module,
      jsFullPath: injectionType.path.replaceFirst(r'latest', version),
      globalJSVariableName: injectionType.variable,
    );
  }

  /// Inject all js module that required by this package at `latest` version.
  ///
  /// ---
  ///
  /// ```dart
  /// void main() async {
  ///   await FlutterWeb3.injectAll();
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> injectAll() async {
    AMDJS.verbose = false;
    await Future.wait(FlutterWeb3InjectionTypes.values.map((e) => inject(e)));
  }
}

/// Available module to inject, used in [FlutterWeb3.inject].
enum FlutterWeb3InjectionTypes {
  ethers,
  walletConnect,
}

extension _InjectionInformation on FlutterWeb3InjectionTypes {
  static const _info = {
    FlutterWeb3InjectionTypes.ethers: {
      'module': 'ethers',
      'variable': 'ethers',
      'path':
          'https://cdn.jsdelivr.net/npm/ethers@latest/dist/ethers.umd.min.js'
    },
    FlutterWeb3InjectionTypes.walletConnect: {
      'module': 'WalletConnectProvider',
      'variable': 'WalletConnectProvider',
      'path':
          'https://cdn.jsdelivr.net/npm/@walletconnect/web3-provider@latest/dist/umd/index.min.js'
    }
  };

  String get module => _info[this]!['module']!;

  String get variable => _info[this]!['variable']!;

  String get path => _info[this]!['path']!;
}
