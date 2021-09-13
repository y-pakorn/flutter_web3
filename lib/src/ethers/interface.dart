part of ethers;

/// Format types of Interface
enum FormatTypes {
  /// ```dart
  /// '''
  /// [
  ///   {
  ///     'type': 'function',
  ///     'name': 'balanceOf',
  ///     'constant':true,
  ///     'stateMutability': 'view',
  ///     'payable':false, 'inputs': [
  ///       { 'type': 'address', 'name': 'owner'}
  ///     ],
  ///     'outputs': [
  ///       { 'type': 'uint256', 'name': 'balance'}
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

  /// '0x70a08231'
  sighash,
}

/// An ABI is a collection of Fragments.
class Fragment extends Interop<_FragmentImpl> {
  factory Fragment.from(String source) =>
      Fragment._(_FragmentImpl.from(source));

  const Fragment._(_FragmentImpl impl) : super.internal(impl);

  /// This is the name of the Event or Function. This will be `null` for a `ConstructorFragment`.
  String? get name => impl.name;

  /// This is an array of each [ParamType] for the input parameters to the Constructor, Event of Function.
  List<ParamType> get paramType =>
      impl.inputs.cast<_ParamTypeImpl>().map((e) => ParamType._(e)).toList();

  /// This is a [String] which indicates the type of the [Fragment]. This will be one of:
  /// - constructor
  /// - event
  /// - function
  String get type => impl.type;

  /// Creates a [String] representation of the [Fragment] using the available [type] formats.
  String format([FormatTypes? type]) =>
      type != null ? impl.format(type.impl) : impl.format();

  @override
  String toString() => 'Fragment: ${format()}';
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

  const Interface._(_InterfaceImpl impl) : super.internal(impl);

  /// All the [Fragment] in the interface.
  List<Fragment> get fragments =>
      impl.fragments.cast<_FragmentImpl>().map((e) => Fragment._(e)).toList();

  /// Returns the decoded values from the result of a call for [function] (see Specifying Fragments) for the given [data].
  ///
  /// ---
  ///
  /// ```dart
  /// // Decoding result data (e.g. from an eth_call)
  /// resultData = '0x0000000000000000000000000000000000000000000000000de0b6b3a7640000';
  /// iface.decodeFunctionResult('balanceOf', resultData);
  /// // [1000000000000000000]
  /// ```
  List<dynamic> decodeFunctionResult(String function, String data) =>
      impl.decodeFunctionResult(function, data);

  /// Returns the decoded values from the result of a call for [function] (see Specifying Fragments) for the given [data].
  ///
  /// ---
  ///
  /// ```dart
  /// // Decoding result data (e.g. from an eth_call)
  /// resultData = '0x0000000000000000000000000000000000000000000000000de0b6b3a7640000';
  /// iface.decodeFunctionResult(iface.fragments.first, resultData);
  /// // [1000000000000000000]
  /// ```
  List<dynamic> decodeFunctionResultFromFragment(
          Fragment function, String data) =>
      impl.decodeFunctionResult(function.impl, data);

  /// Returns the encoded [topic] filter, which can be passed to getLogs for fragment (see Specifying Fragments) for the given [values].
  ///
  /// Each topic is a 32 byte (64 nibble) `DataHexString`.
  ///
  /// ---
  ///
  /// ```dart
  /// // Filter that matches all Transfer events
  /// iface.encodeFilterTopics('Transfer', []);
  /// // [
  /// //   '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  /// // ]
  ///
  /// // Filter that matches the sender
  /// iface.encodeFilterTopics('Transfer', [
  ///   '0x8ba1f109551bD432803012645Ac136ddd64DBA72'
  /// ]);
  /// // [
  /// //   '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
  /// //   '0x0000000000000000000000008ba1f109551bd432803012645ac136ddd64dba72'
  /// // ]
  /// ```
  List<dynamic> encodeFilterTopics(String topic,
          [List<dynamic> values = const []]) =>
      impl.encodeFilterTopics(topic, values);

  /// Returns the encoded [topic] filter, which can be passed to getLogs for fragment (see Specifying Fragments) for the given [values].
  ///
  /// Each topic is a 32 byte (64 nibble) `DataHexString`.
  ///
  /// ---
  ///
  /// ```dart
  /// // Filter that matches all Transfer events
  /// iface.encodeFilterTopics(iface.fragments.first, []);
  /// // [
  /// //   '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  /// // ]
  ///
  /// // Filter that matches the sender
  /// iface.encodeFilterTopics(iface.fragments.first, [
  ///   '0x8ba1f109551bD432803012645Ac136ddd64DBA72'
  /// ]);
  /// // [
  /// //   '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
  /// //   '0x0000000000000000000000008ba1f109551bd432803012645ac136ddd64dba72'
  /// // ]
  /// ```
  List<dynamic> encodeFilterTopicsFromFragment(Fragment topic,
          [List<dynamic> values = const []]) =>
      impl.encodeFilterTopics(topic.impl, values);

  /// Returns the encoded data, which can be used as the data for a transaction for [function] (see Specifying Fragments) for the given [values].
  ///
  /// ---
  ///
  /// ```dart
  /// // Encoding data for the tx.data of a call or transaction
  /// iface.encodeFunctionData('transferFrom', [
  ///   '0x8ba1f109551bD432803012645Ac136ddd64DBA72',
  ///   '0xaB7C8803962c0f2F5BBBe3FA8bf41cd82AA1923C',
  ///   '1'
  /// ]);
  /// // '0x23b872dd0000000000000000000000008ba1f109551bd432803012645ac136ddd64dba72000000000000000000000000ab7c8803962c0f2f5bbbe3fa8bf41cd82aa1923c0000000000000000000000000000000000000000000000000de0b6b3a7640000'
  /// ```
  String encodeFunctionData(String function, [List<dynamic>? values]) =>
      impl.encodeFunctionData(function, values);

  /// Returns the encoded data, which can be used as the data for a transaction for [function] (see Specifying Fragments) for the given [values].
  ///
  /// ---
  ///
  /// ```dart
  /// // Encoding data for the tx.data of a call or transaction
  /// iface.encodeFunctionData(iface.fragments.first, [
  ///   '0x8ba1f109551bD432803012645Ac136ddd64DBA72',
  ///   '0xaB7C8803962c0f2F5BBBe3FA8bf41cd82AA1923C',
  ///   '1'
  /// ]);
  /// // '0x23b872dd0000000000000000000000008ba1f109551bd432803012645ac136ddd64dba72000000000000000000000000ab7c8803962c0f2f5bbbe3fa8bf41cd82aa1923c0000000000000000000000000000000000000000000000000de0b6b3a7640000'
  /// ```
  String encodeFunctionDataFromFragment(Fragment function,
          [List<dynamic>? values]) =>
      impl.encodeFunctionData(function.impl, values);

  /// Return the formatted [Interface].
  ///
  /// [types] must be from [FormatTypes] variable.
  ///
  /// If the format type is json a single string is returned, otherwise an Array of the human-readable strings is returned.
  dynamic format([FormatTypes? type]) =>
      type != null ? impl.format(type.impl) : impl.format();

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
  ///     'type': 'function',
  ///     'name': 'balanceOf',
  ///     'constant':true,
  ///     'stateMutability': 'view',
  ///     'payable':false, 'inputs': [
  ///       { 'type': 'address', 'name': 'owner'}
  ///     ],
  ///     'outputs': [
  ///       { 'type': 'uint256'}
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
  /// iface.getEventTopic('Transfer');
  /// // '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  ///
  /// iface.getEventTopic('Transfer(address, address, uint)');
  /// // '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
  /// ```
  String getEventTopic(String event) => impl.getEventTopic(event);

  /// Return the sighash (or Function Selector) for [function].
  ///
  /// ---
  ///
  /// ```dart
  /// iface.getSighash('balanceOf');
  /// // '0x70a08231'
  ///
  /// iface.getSighash('balanceOf(address)');
  /// // '0x70a08231'
  /// ```
  String getSighash(String function) => impl.getSighash(function);

  /// Return the sighash (or Function Selector) for [fragment].
  ///
  /// ---
  ///
  /// ```dart
  /// iface.getSighash(iface.fragments.first);
  /// // '0x70a08231'
  /// ```
  String getSighashByFragment(Fragment fragment) =>
      impl.getSighash(fragment.impl);

  @override
  String toString() => 'Interface: ${format(FormatTypes.minimal)}';
}

/// A representation of a solidity parameter.
class ParamType extends Interop<_ParamTypeImpl> {
  factory ParamType.from(String source) =>
      ParamType._(_ParamTypeImpl.from(source));

  const ParamType._(_ParamTypeImpl impl) : super.internal(impl);

  /// The type of children of the array. This is `null` for any parameter which is not an array.
  ParamType? get arrayChildren =>
      impl.arrayChildren == null ? null : ParamType._(impl.arrayChildren!);

  /// The length of the array, or -1 for dynamic-length arrays. This is `null` for parameters which are not arrays.
  int? get arrayLength => impl.arrayLength;

  /// The base type of the parameter. For primitive types (e.g. `address`, `uint256`, etc) this is equal to type. For arrays, it will be the string array and for a tuple, it will be the string tuple.
  String get baseType => impl.baseType;

  ///The components of a tuple. This is `null` for non-tuple parameters.
  List<ParamType>? get components => impl.components
      ?.cast<_ParamTypeImpl>()
      .map((e) => ParamType._(e))
      .toList();

  /// Whether the parameter has been marked as indexed. This only applies to parameters which are part of an EventFragment.
  bool get indexed => impl.indexed;

  /// The local parameter name. This may be null for unnamed parameters. For example, the parameter definition `string foobar` would be `foobar`.
  String? get name => impl.name;

  /// The full type of the parameter, including tuple and array symbols. This may be `null` for unnamed parameters. For the above example, this would be `foobar`.
  String? get type => impl.type;

  /// Creates a [String] representation of the [Fragment] using the available [type] formats.
  String format([FormatTypes? type]) =>
      type != null ? impl.format(type.impl) : impl.format();

  @override
  String toString() => 'ParamType: ${format()}';
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
      case FormatTypes.sighash:
        return _FormatTypesImpl.sighash;
    }
  }
}
