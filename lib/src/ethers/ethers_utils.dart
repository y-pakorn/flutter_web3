import 'ethers.dart';

/// Get default [AbiCoder]
AbiCoder get abiCoder => Utils.defaultAbiCoder;

/// Convert JS [BigNumber] to Dart [BigInt]
BigInt bigNumberToBigInt(BigNumber bigNumber) =>
    BigInt.parse(bigNumber.toString());

/// Construct [Contract] with [Signer] from default [Provider]
Contract defaultContractWithSigner(String address, List<String> abi) =>
    Contract(address, abi, provider!.getSigner());

extension BigNumberExt on BigNumber {
  /// Convert JS [BigNumber] to Dart [BigInt]
  BigInt get toBigInt => bigNumberToBigInt(this);
}

extension BigIntExt on BigInt {
  /// Convert Dart [BigInt] to JS [BigNumber]
  BigNumber get toBigNumber => BigNumber.from(this.toString());
}
