class EthereumException implements Exception {
  final int code;
  final String message;
  final dynamic data;

  const EthereumException(this.code, this.message, this.data);

  @override
  String toString() => 'EthereumException: $code $message';
}

class EthereumUnrecognizedChainException extends EthereumException {
  final int chainId;

  const EthereumUnrecognizedChainException(this.chainId,
      [int code = 4902, String message = ''])
      : super(code, message, null);

  @override
  String toString() =>
      'EthereumUnrecognizedChainException: Chain $chainId is not recognized, please add the chain using `walletAddChain` first';
}

class EthereumUserRejected extends EthereumException {
  const EthereumUserRejected([int code = 4001, String message = ''])
      : super(code, message, null);

  @override
  String toString() => 'EthereumUserRejected: User rejected the request';
}
