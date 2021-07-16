class EthereumUnrecognizedChainException implements Exception {
  final int chainId;

  EthereumUnrecognizedChainException(this.chainId);

  @override
  String toString() =>
      'EthereumUnrecognizedChainException: Chain $chainId is not recognized, please add the chain using `walletAddChain` first';
}

class EthereumUserRejected implements Exception {
  @override
  String toString() => 'EthereumUserRejected: User rejected the request';
}
