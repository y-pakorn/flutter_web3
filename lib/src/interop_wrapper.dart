import 'package:meta/meta.dart';

@internal
abstract class Interop<T> {
  /// JS Object.
  @internal
  final T impl;

  @internal
  const Interop.internal(this.impl);
}
