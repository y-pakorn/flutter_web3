import 'objects.dart';

extension TxReceiptExtension on TxReceipt {
  bool get isSuccessful => status == 1;
  bool get isCreatingContract => to == null;
}
