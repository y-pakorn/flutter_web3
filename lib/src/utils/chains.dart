import 'package:flutter_web3/src/ethereum/ethereum.dart';

enum Chains {
  Mainnet,
  Ropsten,
  Rinkeby,
  XDai,
  Polygon,
  Mumbai,
  BSCMainnet,
  BSCTestnet,
}

extension ChainExtension on Chains {
  static const _info = {
    Chains.Mainnet: {
      'name': 'Ethereum Mainnet',
      'chain': 'ETH',
      'network': 'mainnet',
      'rpc': [],
      'nativeCurrency': {'name': 'Ether', 'symbol': 'ETH', 'decimals': 18},
      'chainId': 1,
      "explorers": ["https://etherscan.io/"],
      'multicall': '0xeefba1e63905ef1d7acba5a8513c70307c1ce441',
    },
    Chains.Ropsten: {
      "name": "Ethereum Testnet Ropsten",
      "chain": "ETH",
      "network": "ropsten",
      "rpc": [],
      "nativeCurrency": {
        "name": "Ropsten Ether",
        "symbol": "ROP",
        "decimals": 18
      },
      "chainId": 3,
      "explorers": ["https://ropsten.etherscan.io/"],
      'multicall': '0x53c43764255c17bd724f74c4ef150724ac50a3ed',
    },
    Chains.Rinkeby: {
      "name": "Ethereum Testnet Rinkeby",
      "chain": "ETH",
      "network": "rinkeby",
      "rpc": [],
      "nativeCurrency": {
        "name": "Rinkeby Ether",
        "symbol": "RIN",
        "decimals": 18
      },
      "chainId": 4,
      "explorers": ["https://rinkeby.etherscan.io/"],
      'multicall': '0x42ad527de7d4e9d9d011ac45b31d8551f8fe9821',
    },
    Chains.XDai: {
      "name": "xDAI Chain",
      "chain": "XDAI",
      "network": "mainnet",
      "rpc": [
        "https://rpc.xdaichain.com",
        "https://xdai.poanetwork.dev",
        "http://xdai.poanetwork.dev",
        "https://dai.poa.network",
      ],
      "nativeCurrency": {"name": "xDAI", "symbol": "xDAI", "decimals": 18},
      "chainId": 100,
      "explorers": ["https://blockscout.com/xdai/mainnet/"],
      'multicall': '0xb5b692a88bdfc81ca69dcb1d924f59f0413a602a',
    },
    Chains.Polygon: {
      "name": "Matic(Polygon) Mainnet",
      "chain": "Matic(Polygon)",
      "network": "mainnet",
      "rpc": ['https://polygon-rpc.com/'],
      "nativeCurrency": {"name": "Matic", "symbol": "MATIC", "decimals": 18},
      "chainId": 137,
      "explorers": ["https://polygonscan.com/"],
      'multicall': '0x11ce4B23bD875D7F5C6a31084f55fDe1e9A87507',
    },
    Chains.Mumbai: {
      "name": "Matic(Polygon) Testnet Mumbai",
      "chain": "Matic(Polygon)",
      "network": "testnet",
      "rpc": ["https://rpc-mumbai.matic.today"],
      "faucets": ["https://faucet.matic.network/"],
      "nativeCurrency": {"name": "Matic", "symbol": "tMATIC", "decimals": 18},
      "chainId": 80001,
      "explorers": ["https://mumbai.polygonscan.com/"],
      'multicall': '0x08411ADd0b5AA8ee47563b146743C13b3556c9Cc',
    },
    Chains.BSCMainnet: {
      "name": "Binance Smart Chain Mainnet",
      "chain": "BSC",
      "network": "mainnet",
      "rpc": [
        "https://bsc-dataseed1.binance.org",
        "https://bsc-dataseed2.binance.org",
        "https://bsc-dataseed3.binance.org",
        "https://bsc-dataseed4.binance.org",
      ],
      "nativeCurrency": {
        "name": "Binance Chain Native Token",
        "symbol": "BNB",
        "decimals": 18
      },
      "chainId": 56,
      "explorers": ["https://bscscan.com"],
      'multicall': '0x41263cba59eb80dc200f3e2544eda4ed6a90e76c',
    },
    Chains.BSCTestnet: {
      "name": "Binance Smart Chain Testnet",
      "chain": "BSC",
      "network": "Chapel",
      "rpc": [
        "https://data-seed-prebsc-1-s1.binance.org:8545",
        "https://data-seed-prebsc-2-s1.binance.org:8545",
        "https://data-seed-prebsc-1-s2.binance.org:8545",
        "https://data-seed-prebsc-2-s2.binance.org:8545",
        "https://data-seed-prebsc-1-s3.binance.org:8545",
        "https://data-seed-prebsc-2-s3.binance.org:8545"
      ],
      "faucets": ["https://testnet.binance.org/faucet-smart"],
      "nativeCurrency": {
        "name": "Binance Chain Native Token",
        "symbol": "tBNB",
        "decimals": 18
      },
      "chainId": 97,
      "explorers": ["https://testnet.bscscan.com"],
      'multicall': '0xae11C5B5f29A6a25e955F0CB8ddCc416f522AF5C',
    },
  };

  String? get multicallAddress => _info[this]!['multicall'] as String?;

  String get name => _info[this]!['name'] as String;

  String get chain => _info[this]!['chain'] as String;

  String get network => _info[this]!['network'] as String;

  int get chainId => _info[this]!['chainId'] as int;

  List<String> get rpc => _info[this]!['rpc'] as List<String>;

  List<String> get explorers => _info[this]!['explorers'] as List<String>;

  List<String>? get faucets => _info[this]!['faucets'] as List<String>?;

  CurrencyParams get nativeCurrency {
    final info = _info[this]!['nativeCurrency']! as Map<String, dynamic>;
    return CurrencyParams(
        name: info['name'], symbol: info['symbol'], decimals: info['decimals']);
  }
}
