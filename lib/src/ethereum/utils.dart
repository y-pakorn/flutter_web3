part of ethereum;

/// Convert JS object to Dart object to avoid type error.
dynamic convertToDart(dynamic jsObject) => json.decode(stringify(jsObject));

/// Convert JS object to Dart object to avoid type error, safe functionality as [convertToDart];
dynamic dartify(dynamic jsObject) => convertToDart(jsObject);

/// Convert JavaScript object or value to a JSON string,
///
/// optionally replacing values if a replacer function is specified or optionally including only the specified properties if a replacer array is specified.
@JS("JSON.stringify")
external String stringify(dynamic obj);
