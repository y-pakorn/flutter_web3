class EthereumUnrecognizedChainException implements Exception {
  final int chainId;

  EthereumUnrecognizedChainException(this.chainId);
}

class EthereumUserRejected implements Exception {}
