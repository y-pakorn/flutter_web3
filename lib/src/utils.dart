import 'dart:convert';

import 'ethereum/ethereum.dart';

dynamic convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));
