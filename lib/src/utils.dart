import 'dart:convert';

import 'ethereum/ethereum.dart';

/// Convert JS object to Dart object to avoid type error.
dynamic convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));
