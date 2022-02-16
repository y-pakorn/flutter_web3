part of ethers;

class ConstructorFragment<T extends _ConstructorFragmentImpl>
    extends Fragment<T> {
  /// Creates a new [ConstructorFragment] from any compatible [source].
  factory ConstructorFragment.from(dynamic source) => ConstructorFragment._(
        _ConstructorFragmentImpl.from(source is Interop ? source.impl : source)
            as T,
      );

  const ConstructorFragment._(T impl) : super._(impl);

  /// This is the gas limit that should be used during deployment. It may be `null`.
  BigInt? get gas => impl.gas?.toBigInt;

  /// This is whether the constructor may receive ether during deployment as an endowment (i.e. msg.value != 0).
  bool get payable => impl.payable;

  /// This is the state mutability of the constructor. It can be any of:
  /// - nonpayable
  /// - payable
  String get stateMutability => impl.stateMutability;
}

class EventFragment extends Fragment<_EventFragmentImpl> {
  /// Creates a new [EventFragment] from any compatible [source].
  factory EventFragment.from(dynamic source) => EventFragment._(
        _EventFragmentImpl.from(source is Interop ? source.impl : source),
      );

  const EventFragment._(_EventFragmentImpl impl) : super._(impl);

  /// This is whether the event is anonymous. An anonymous Event does not inject its topic hash as topic0 when creating a log.
  bool get anonymous => impl.anonymous;

  @override
  String format([FormatTypes? type]) {
    return toString();
  }

  @override
  String toString() {
    return 'EventFragment: $name anonymous: $anonymous';
  }
}

/// An ABI is a collection of Fragments.
class Fragment<T extends _FragmentImpl> extends Interop<T> {
  /// Creates a new [Fragment] sub-class from any compatible [source].
  factory Fragment.from(dynamic source) => Fragment._(
      _FragmentImpl.from(source is Interop ? source.impl : source) as T);

  const Fragment._(T impl) : super.internal(impl);

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

class FunctionFragment extends ConstructorFragment<_FunctionFragmentImpl> {
  /// Creates a new [FunctionFragment] from any compatible [source].
  factory FunctionFragment.from(dynamic source) => FunctionFragment._(
        _FunctionFragmentImpl.from(source is Interop ? source.impl : source),
      );

  const FunctionFragment._(_FunctionFragmentImpl impl) : super._(impl);

  /// This is whether the function is constant (i.e. does not change state). This is `true` if the state mutability is `pure` or `view`.
  bool get constant => impl.constant;

  /// A list of the Function output parameters.
  List<ParamType> get outputs =>
      impl.outputs.cast<_ParamTypeImpl>().map((e) => ParamType._(e)).toList();

  /// This is the state mutability of the constructor. It can be any of:
  /// - nonpayable
  /// - payable
  /// - pure
  /// - view
  String get stateMutability => impl.stateMutability;

  @override
  String format([FormatTypes? type]) {
    return toString();
  }

  @override
  String toString() {
    return 'FunctionFragment: $name constant: $constant stateMutability: $stateMutability';
  }
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
