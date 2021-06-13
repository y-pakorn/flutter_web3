import 'dart:convert';

import 'package:flutter_web3_provider/ethers.dart';

import 'ethereum.dart';

BigInt bigNumberToBigInt(BigNumber bigNumber) =>
    BigInt.parse(bigNumber.toString());

extension BigNumberExt on BigNumber {
  BigInt get toBigInt => bigNumberToBigInt(this);
}

AbiCoder get abiCoder => Utils.defaultAbiCoder;

Contract defaultContractWithSigner(String address, List<String> abi) =>
    Contract(address, abi, provider!.getSigner());

dynamic convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));
