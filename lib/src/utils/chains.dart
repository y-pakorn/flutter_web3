enum Chains {
  Mainnet,
  Kovan,
  Rinkeby,
  Gorli,
  Ropsten,
  XDai,
  Polygon,
  Mumbai,
  BSCMainnet,
  BSCTestnet,
}

extension ChainExtension on Chains {
  static const _info = {
    Chains.Mainnet: {
      'multicall': '0xeefba1e63905ef1d7acba5a8513c70307c1ce441',
    },
    Chains.Gorli: {
      'multicall': '0x77dca2c955b15e9de4dbbcf1246b4b85b651e50e',
    },
    Chains.Ropsten: {
      'multicall': '0x53c43764255c17bd724f74c4ef150724ac50a3ed',
    },
    Chains.Kovan: {
      'multicall': '0x2cc8688c5f75e365aaeeb4ea8d6a480405a48d2a',
    },
    Chains.Rinkeby: {
      'multicall': '0x42ad527de7d4e9d9d011ac45b31d8551f8fe9821',
    },
    Chains.XDai: {
      'multicall': '0xb5b692a88bdfc81ca69dcb1d924f59f0413a602a',
    },
    Chains.Polygon: {
      'multicall': '0x11ce4B23bD875D7F5C6a31084f55fDe1e9A87507',
    },
    Chains.Mumbai: {
      'multicall': '0x08411ADd0b5AA8ee47563b146743C13b3556c9Cc',
    },
    Chains.BSCMainnet: {
      'multicall': '0x41263cba59eb80dc200f3e2544eda4ed6a90e76c',
    },
    Chains.BSCTestnet: {
      'multicall': '0xae11C5B5f29A6a25e955F0CB8ddCc416f522AF5C',
    },
  };

  String? get multicallAddress => _info[this]!['multicall'];
}
