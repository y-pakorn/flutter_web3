import 'package:decimal/decimal.dart';

BigInt toBase(Decimal amount, int decimals) {
  Decimal baseUnit = Decimal.fromInt(10).pow(decimals);
  print("baseUnit: $baseUnit");
  Decimal inbase = amount * baseUnit;
  print("inbase: $inbase");
  return BigInt.parse(inbase.toString());
}

Decimal toDecimal(BigInt amount, int decimals) {
  Decimal baseUnit = Decimal.fromInt(10).pow(decimals);
  print("baseUnit: $baseUnit");
  var d = Decimal.parse(amount.toString());
  d = d / baseUnit;
  print("todec: $d");
  return d;
}
