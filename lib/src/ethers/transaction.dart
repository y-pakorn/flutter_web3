part of ethers;

class TransactionOverride extends Interop<_TransactionOverrideImpl> {
  final BigInt? _gasLimit;
  final BigInt? _gasPrice;
  final BigInt? _value;
  final int? _nonce;

  TransactionOverride(
    this._gasLimit,
    this._gasPrice,
    this._value,
    this._nonce,
  ) : super.internal(
          _TransactionOverrideImpl(
            value: _value.toString(),
            nonce: _nonce,
            gasLimit: _gasLimit.toString(),
            gasPrice: _gasPrice.toString(),
          ),
        );

  /// The maximum amount of gas this transaction is permitted to use.
  BigInt? get gasLimit => _gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  BigInt? get gasPrice => _gasPrice;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  int? get nonce => _nonce;

  /// The amount (in wei) this transaction is sending.
  BigInt? get value => _value;

  @override
  String toString() =>
      'TransactionOverride: value $value with gas limit $gasLimit and gas price $gasPrice';
}

/// A transaction request describes a transaction that is to be sent to the network or otherwise processed.
///
/// All fields are optional and may be a promise which resolves to the required type.
class TransactionRequest extends Interop<_TransactionRequestImpl> {
  final String? _data;
  final BigInt? _gasLimit;
  final BigInt? _gasPrice;
  final int? _nounce;
  final String? _to;
  final BigInt? _value;

  TransactionRequest(
    this._data,
    this._gasLimit,
    this._gasPrice,
    this._nounce,
    this._to,
    this._value,
  ) : super.internal(
          _TransactionRequestImpl(
            to: _to,
            data: _data,
            value: _value.toString(),
            nonce: _nounce,
            gasLimit: _gasLimit.toString(),
            gasPrice: _gasPrice.toString(),
          ),
        );

  @override
  String toString() =>
      'TransactionRequest: to $to with value $value and data $data';

  /// The transaction data.
  String? get data => _data;

  /// The maximum amount of gas this transaction is permitted to use.
  BigInt? get gasLimit => _gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  BigInt? get gasPrice => _gasPrice;

  String? get method => impl.method;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  int? get nonce => _nounce;

  /// The address (or ENS name) this transaction it to.
  String? get to => _to;

  /// The amount (in wei) this transaction is sending.
  BigInt? get value => _value;
}

/// A generic object to represent a transaction.
class Transaction<T extends _TransactionImpl> extends Interop<T> {
  const Transaction._(T impl) : super.internal(impl);

  ///The chain ID for transaction. This is used as part of EIP-155 to prevent replay attacks on different networks.
  ///
  ///For example, if a transaction was made on ropsten with an account also used on homestead, it would be possible for a transaction signed on ropsten to be executed on homestead, which is likely unintended.
  ///
  ///There are situations where replay may be desired, however these are very rare and it is almost always recommended to specify the chain ID.
  int get chainId => impl.chainId;

  /// The data for transaction. In a contract this is the call data.
  String get data => impl.data;

  /// The address transaction is from.
  String get from => impl.from;

  /// The gas limit for transaction.
  ///
  /// An account must have enough ether to cover the gas (at the specified gasPrice).
  ///
  /// Any unused gas is refunded at the end of the transaction, and if there is insufficient gas to complete execution, the effects of the transaction are reverted, but the gas is fully consumed and an out-of-gas error occurs.
  BigInt get gasLimit => impl.gasLimit.toBigInt;

  /// The price (in wei) per unit of gas for transaction.
  BigInt get gasPrice => impl.gasPrice.toBigInt;

  /// The transaction hash, which can be used as an identifier for transaction. This is the keccak256 of the serialized RLP encoded representation of transaction.
  String get hash => impl.hash;

  /// The nonce for transaction.
  ///
  /// Each transaction sent to the network from an account includes this, which ensures the order and non-replayability of a transaction.
  ///
  /// This must be equal to the current number of transactions ever sent to the network by the from address.
  int get nounce => impl.nounce;

  /// The r portion of the elliptic curve signatures for transaction.
  ///
  /// This is more accurately, the x coordinate of the point r (from which the y can be computed, along with v).
  String get r => impl.r;

  /// The s portion of the elliptic curve signatures for transaction.
  String get s => impl.s;

  /// The address transaction is to.
  String? get to => impl.to;

  /// The v portion of the elliptic curve signatures for transaction.
  ///
  /// This is used to refine which of the two possible points a given x-coordinate can have, and in EIP-155 is additionally used to encode the chain ID into the serialized transaction.
  int get v => impl.v;

  /// The value (in wei) for transaction.
  BigInt get value => impl.value.toBigInt;

  @override
  String toString() => 'Transaction: $hash from $from with data $data';
}

class TransactionReceipt extends Interop<_TransactionReceiptImpl> {
  const TransactionReceipt._(_TransactionReceiptImpl impl)
      : super.internal(impl);

  /// `true` if this transaction is a creating contract transaction.
  bool get isCreatingContract => to == null;

  /// The block hash of the block that this transaction was included in.
  String get blockHash => impl.blockHash;

  /// The block height (number) of the block that this transaction was included in.
  int get blockNumber => impl.blockNumber;

  /// This is true if the block is in a post-Byzantium Hard Fork block.
  bool get byzantium => impl.byzantium;

  /// The number of blocks that have been mined since this transaction, including the actual block it was mined in.
  int get confirmations => impl.confirmations;

  /// If this transaction has a `null` to address, it is an init transaction used to deploy a contract,
  /// in which case this is the address created by that contract.
  String? get contractAddress => impl.contractAddress;

  /// For the block this transaction was included in,
  /// this is the sum of the gas used by each transaction in the ordered list of transactions up to (and including) this transaction.
  ///
  /// This is generally of little interest to developers.
  BigInt get cumulativeGasUsed => impl.cumulativeGasUsed.toBigInt;

  /// The address this transaction is from.
  String get from => impl.from;

  /// The amount of gas actually used by this transaction.
  BigInt get gasUsed => impl.gasUsed.toBigInt;

  /// All the logs emitted by this transaction.
  List<Log> get logs =>
      impl.logs.cast<_LogImpl>().map((e) => Log._(e)).toList();

  ///A bloom-filter, which includes all the addresses and topics included in any log in this transaction.
  String get logsBloom => impl.logsBloom;

  /// The intermediate state root of a receipt.
  ///
  /// Only transactions included in blocks before the Byzantium Hard Fork have this property, as it was replaced by the status property.
  ///
  /// The property is generally of little use to developers. At the time it could be used to verify a state transition with a fraud-proof only considering the single transaction; without it the full block must be considered.
  String? get root => impl.root;

  /// The status of a transaction is `true` is successful or `false` if it was reverted.
  ///
  /// Only transactions included in blocks post-Byzantium Hard Fork have this property.
  bool get status => impl.status == 1;

  /// The address this transaction is to.
  ///
  /// This is `null` if the transaction was an init transaction, used to deploy a contract.
  String? get to => impl.to;

  /// The hash of this transaction.
  String get transactionHash => impl.transactionHash;

  /// The index of this transaction in the list of transactions included in the block this transaction was mined in.
  int get transactionIndex => impl.transactionIndex;

  @override
  String toString() => status
      ? 'TransactionReceipt: mined $transactionHash with $confirmations confirmations and ${logs.length} logs'
      : 'TransactionReceipt: reverted $transactionHash';
}

/// A TransactionResponse includes all properties of a [Transaction] as well as several properties that are useful once it has been mined.
class TransactionResponse extends Transaction<_TransactionResponseImpl> {
  const TransactionResponse._(_TransactionResponseImpl impl) : super._(impl);

  /// The [AccessList] included in an EIP-2930 transaction, which will also have its type equal to 1.
  AccessList? get accessList =>
      impl.accessList != null ? AccessList._(impl.accessList!) : null;

  /// The hash of the block this transaction was mined in. If the block has not been mined, this is null.
  String? get blockHash => impl.blockHash;

  /// The number ("height") of the block this transaction was mined in. If the block has not been mined, this is null.
  int? get blockNumber => impl.blockNumber;

  /// The number of blocks that have been mined (including the initial block) since this transaction was mined.
  int get confirmations => impl.confirmations;

  /// The serialized transaction.
  String get raw => impl.raw;

  /// The timestamp of the block this transaction was mined in. If the block has not been mined, this is null.
  DateTime? get timestamp => impl.timestamp != null
      ? DateTime.fromMillisecondsSinceEpoch(impl.timestamp! * 1000)
      : null;

  /// The EIP-2718 type of this transaction envelope, or null for legacy transactions that do not have an envelope.
  int? get type => impl.type;

  /// Wait for this [hash] transaction to be mined with [confirms] confirmations, same as [Provider.waitForTransaction].
  Future<TransactionReceipt> wait([int? confirms]) async {
    return TransactionReceipt._(
      await promiseToFuture<_TransactionReceiptImpl>(callMethod(
        this,
        'wait',
        confirms != null ? [confirms] : [],
      )),
    );
  }
}
