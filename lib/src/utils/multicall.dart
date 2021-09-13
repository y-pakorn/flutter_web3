import '../ethers/ethers.dart';
import 'chains.dart';

class Multicall {
  static const abi = [
    'function aggregate((address, bytes)[]) view returns (uint256, bytes[])',
  ];

  Contract contract;

  Multicall(String multicallAddress, dynamic providerOrSigner)
      : assert(providerOrSigner != null, 'providerOrSigner should not be null'),
        assert(multicallAddress.isNotEmpty, 'address should not be empty'),
        assert(EthUtils.isAddress(multicallAddress),
            'address should be in address format'),
        contract = Contract(multicallAddress, abi, providerOrSigner);

  factory Multicall.fromChain(Chains chain, providerOrSigner) {
    assert(chain.multicallAddress != null,
        'Multicall not supported on this chain');
    return Multicall(chain.multicallAddress!, providerOrSigner);
  }

  Future<MulticallResult> aggregate(List<MulticallPayload> payload) async {
    assert(payload.isNotEmpty, 'payload should not be empty');

    final res = await contract.call<List>('aggregate', [
      payload.map((e) => e.serialize()).toList(),
    ]);
    return MulticallResult(
        int.parse(res[0].toString()), (res[1] as List).cast());
  }
}

class MulticallPayload {
  final String address;
  final String data;

  const MulticallPayload(this.address, this.data);

  factory MulticallPayload.fromFunctionAbi(String address, String functionAbi,
      [List<dynamic>? args]) {
    final interface = Interface([functionAbi]);
    final data = interface.encodeFunctionDataFromFragment(
        interface.fragments.first, args);
    return MulticallPayload(address, data);
  }

  factory MulticallPayload.fromInterfaceFunction(
      String address, Interface interface, String function,
      [List<dynamic>? args]) {
    final data = interface.encodeFunctionData(function, args);
    return MulticallPayload(address, data);
  }

  List<String> serialize() => [address, data];

  @override
  String toString() {
    return 'MulticallPayload: to $address with data $data';
  }
}

class MulticallResult {
  final int blockNumber;
  final List<String> returnData;

  const MulticallResult(this.blockNumber, this.returnData);

  @override
  String toString() {
    return 'MulticallResult: at block $blockNumber total ${returnData.length} item, ${returnData.take(3)}...';
  }
}
