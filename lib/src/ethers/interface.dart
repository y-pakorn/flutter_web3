part of ethers;

/// Format types of Interface
enum FormatTypes {
  /// ```dart
  /// '''
  /// [
  ///   {
  ///     "type": "function",
  ///     "name": "balanceOf",
  ///     "constant":true,
  ///     "stateMutability": "view",
  ///     "payable":false, "inputs": [
  ///       { "type": "address", "name": "owner"}
  ///     ],
  ///     "outputs": [
  ///       { "type": "uint256", "name": "balance"}
  ///     ]
  ///   },
  /// ]
  /// '''
  /// ```
  json,

  /// ```dart
  /// [
  /// 'function balanceOf(address owner) view returns (uint256)',
  /// ]
  /// ```
  minimal,

  /// ```dart
  /// [
  /// 'function balanceOf(address) view returns (uint256 balance)',
  /// ]
  /// ```
  full,
}

/// The Interface Class abstracts the encoding and decoding required to interact with contracts on the Ethereum network.
///
/// Many of the standards organically evolved along side the Solidity language, which other languages have adopted to remain compatible with existing deployed contracts.
///
/// The EVM itself does not understand what the ABI is. It is simply an agreed upon set of formats to encode various types of data which each contract can expect so they can interoperate with each other.
class Interface extends Interop<_InterfaceImpl> {
  /// Create a new Interface from a JSON string or object representing [abi].
  ///
  /// The abi may be a JSON string or the parsed Object (using JSON.parse) which is emitted by the Solidity compiler (or compatible languages).
  ///
  /// The abi may also be a Human-Readable Abi, which is a format the Ethers created to simplify manually typing the ABI into the source and so that a Contract ABI can also be referenced easily within the same source file.
  factory Interface(dynamic abi) {
    assert(abi is List<String> || abi is String, 'ABI must be valid type');
    return Interface._(_InterfaceImpl(abi));
  }

  Interface._(_InterfaceImpl impl) : super.internal(impl);

  /// Return the formatted [Interface].
  ///
  /// [types] must be from [FormatTypes] variable.
  ///
  /// If the format type is json a single string is returned, otherwise an Array of the human-readable strings is returned.
  dynamic format([FormatTypes? types]) =>
      types != null ? impl.format(types.impl) : impl.format();

  /// Format into [FormatTypes.full].
  ///
  /// ---
  ///
  /// ```dart
  /// [
  /// 'function balanceOf(address owner) view returns (uint256 balance)',
  /// ]
  /// ```
  List<String> formatFull() => (format(FormatTypes.full) as List).cast();

  /// Format into [FormatTypes.json].
  ///
  /// ---
  ///
  /// ```dart
  /// '''
  /// [
  ///   {
  ///     "type": "function",
  ///     "name": "balanceOf",
  ///     "constant":true,
  ///     "stateMutability": "view",
  ///     "payable":false, "inputs": [
  ///       { "type": "address", "name": "owner"}
  ///     ],
  ///     "outputs": [
  ///       { "type": "uint256"}
  ///     ]
  ///   },
  /// ]
  /// '''
  /// ```
  String formatJson() => format(FormatTypes.json);

  /// Format into [FormatTypes.minimal].
  ///
  /// ---
  ///
  /// ```dart
  /// [
  /// 'function balanceOf(address) view returns (uint256)',
  /// ]
  /// ```
  List<String> formatMinimal() => (format(FormatTypes.minimal) as List).cast();

  /// Return the topic hash for [event].
  ///
  /// ---
  ///
  /// ```dart
  /// iface.getEventTopic("Transfer");
  /// // '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  ///
  /// iface.getEventTopic("Transfer(address, address, uint)");
  /// // '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  /// ```
  String getEventTopic(String event) => impl.getEventTopic(event);

  /// Return the sighash (or Function Selector) for [function].
  ///
  /// ---
  ///
  /// ```dart
  /// iface.getSighash("balanceOf");
  /// // '0x70a08231'
  ///
  /// iface.getSighash("balanceOf(address)");
  /// // '0x70a08231'
  /// ```
  String getSighash(String function) => impl.getSighash(function);

  @override
  String toString() => 'Interface: ${format(FormatTypes.minimal)}';
}

extension _FormatTypesExtImpl on FormatTypes {
  dynamic get impl {
    switch (this) {
      case FormatTypes.json:
        return _FormatTypesImpl.json;
      case FormatTypes.minimal:
        return _FormatTypesImpl.minimal;
      case FormatTypes.full:
        return _FormatTypesImpl.full;
    }
  }
}
