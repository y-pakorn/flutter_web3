import 'ethers.dart';

AbiCoder get abiCoder => Utils.defaultAbiCoder;

BigInt bigNumberToBigInt(BigNumber bigNumber) =>
    BigInt.parse(bigNumber.toString());

Contract defaultContractWithSigner(String address, List<String> abi) =>
    Contract(address, abi, provider!.getSigner());

extension BigNumberExt on BigNumber {
  BigInt get toBigInt => bigNumberToBigInt(this);
}
