import 'package:meta/meta.dart';

@internal
abstract class Interop<T> {
  /// Internal JS Object, should not be used directly.
  @internal
  final T impl;

  @internal
  const Interop.internal(this.impl);
}
