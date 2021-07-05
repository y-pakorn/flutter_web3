import 'package:js/js_util.dart';

import 'objects.dart';

extension TransactionResponseExtension on TransactionResponse {
  Future<TransactionReceipt> wait([int? confirms]) async {
    return promiseToFuture<TransactionReceipt>(
        callMethod(this, 'wait', confirms != null ? [confirms] : []));
  }
}

extension TxReceiptExtension on TransactionReceipt {
  bool get isSuccessful => status == 1;

  bool get isCreatingContract => to == null;
}
