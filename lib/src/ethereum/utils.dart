@JS()
library ethereum.utils;

import 'dart:convert';

import 'package:js/js.dart';

/// Convert JS object to Dart object to avoid type error.
dynamic convertToDart(dynamic jsObject) => _convertToDart;

/// Convert JS object to Dart object to avoid type error, same functionality as [convertToDart];
dynamic dartify(dynamic jsObject) => _convertToDart;

/// Convert JavaScript object or value to a JSON string,
///
/// optionally replacing values if a replacer function is specified or optionally including only the specified properties if a replacer array is specified.
@JS("JSON.stringify")
external String stringify(dynamic obj);

dynamic _convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));
