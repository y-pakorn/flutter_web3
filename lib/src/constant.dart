/// The class that contains commonly used values.
class EthConstant {
  /// The Address Zero, which is 20 bytes (40 nibbles) of zero.
  static const ZeroAddress = '0x0000000000000000000000000000000000000000';

  /// The Hash Zero, which is 32 bytes (64 nibbles) of zero.
  static const ZeroHash =
      '0x0000000000000000000000000000000000000000000000000000000000000000';

  /// The Dead Address, normally is the address that token will be send to burn.
  static const DeadAddress = '0x000000000000000000000000000000000000dead';

  /// The Ether symbol, Ξ.
  static const EtherSymbol = 'Ξ';

  static const MaxUint256 =
      '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

  static final weiPerEther = BigInt.parse('1000000000000000000');
}
