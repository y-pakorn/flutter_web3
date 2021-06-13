import 'dart:convert';

import 'ethereum.dart';
import 'ethers.dart';

AbiCoder get abiCoder => Utils.defaultAbiCoder;

BigInt bigNumberToBigInt(BigNumber bigNumber) =>
    BigInt.parse(bigNumber.toString());

dynamic convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));

Contract defaultContractWithSigner(String address, List<String> abi) =>
    Contract(address, abi, provider!.getSigner());

extension BigNumberExt on BigNumber {
  BigInt get toBigInt => bigNumberToBigInt(this);
}
