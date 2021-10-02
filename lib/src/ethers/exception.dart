class EthersException implements Exception {
  final String code;
  final String reason;
  final Map<String, dynamic> rawError;

  EthersException(this.code, this.reason, this.rawError);

  @override
  String toString() => 'EthersException: $code $reason';
}
