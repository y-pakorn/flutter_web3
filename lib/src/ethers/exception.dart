class EthersException {
  final int? code;
  final String? message;

  EthersException(this.code, this.message);

  @override
  String toString() => 'EthersException: $code $message';
}
