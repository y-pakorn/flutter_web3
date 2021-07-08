part of ethers;

class TransactionOverride implements _TransactionOverrideImpl {
  final _TransactionOverrideImpl _impl;

  final BigInt? _gasLimit;
  final BigInt? _gasPrice;
  final BigInt? _value;
  final int? _nonce;

  TransactionOverride(
    this._gasLimit,
    this._gasPrice,
    this._value,
    this._nonce,
  ) : _impl = _TransactionOverrideImpl(
          value: _value.toString(),
          nonce: _nonce,
          gasLimit: _gasLimit.toString(),
          gasPrice: _gasPrice.toString(),
        );

  /// The maximum amount of gas this transaction is permitted to use.
  @override
  BigInt? get gasLimit => _gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  @override
  BigInt? get gasPrice => _gasPrice;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  @override
  int? get nonce => _nonce;

  /// The amount (in wei) this transaction is sending.
  @override
  BigInt? get value => _value;
}

/// A transaction request describes a transaction that is to be sent to the network or otherwise processed.
///
/// All fields are optional and may be a promise which resolves to the required type.
class TransactionRequest implements _TransactionRequestImpl {
  final _TransactionRequestImpl _impl;

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
  ) : _impl = _TransactionRequestImpl(
          to: _to,
          data: _data,
          value: _value.toString(),
          nonce: _nounce,
          gasLimit: _gasLimit.toString(),
          gasPrice: _gasPrice.toString(),
        );

  @override
  String toString() => 'to $to with value $value and data $data';

  /// The transaction data.
  @override
  String? get data => _data;

  /// The maximum amount of gas this transaction is permitted to use.
  @override
  BigInt? get gasLimit => _gasLimit;

  /// The price (in wei) per unit of gas this transaction will pay.
  @override
  BigInt? get gasPrice => _gasPrice;

  @override
  String? get method => _impl.method;

  /// The nonce for this transaction. This should be set to the number of transactions ever sent from this address.
  @override
  int? get nonce => _nounce;

  /// The address (or ENS name) this transaction it to.
  @override
  String? get to => _to;

  /// The amount (in wei) this transaction is sending.
  @override
  BigInt? get value => _value;
}

/// A generic object to represent a transaction.
class Transaction implements _TransactionImpl {
  final _TransactionImpl _txImpl;

  const Transaction._(this._txImpl);

  ///The chain ID for transaction. This is used as part of EIP-155 to prevent replay attacks on different networks.
  ///
  ///For example, if a transaction was made on ropsten with an account also used on homestead, it would be possible for a transaction signed on ropsten to be executed on homestead, which is likely unintended.
  ///
  ///There are situations where replay may be desired, however these are very rare and it is almost always recommended to specify the chain ID.
  @override
  int get chainId => _txImpl.chainId;

  /// The data for transaction. In a contract this is the call data.
  @override
  String get data => _txImpl.data;

  /// The address transaction is from.
  @override
  String get from => _txImpl.from;

  /// The gas limit for transaction.
  ///
  /// An account must have enough ether to cover the gas (at the specified gasPrice).
  ///
  /// Any unused gas is refunded at the end of the transaction, and if there is insufficient gas to complete execution, the effects of the transaction are reverted, but the gas is fully consumed and an out-of-gas error occurs.
  @override
  BigInt get gasLimit => (_txImpl.gasLimit as BigNumber).toBigInt;

  /// The price (in wei) per unit of gas for transaction.
  @override
  BigInt get gasPrice => (_txImpl.gasPrice as BigNumber).toBigInt;

  /// The transaction hash, which can be used as an identifier for transaction. This is the keccak256 of the serialized RLP encoded representation of transaction.
  @override
  String get hash => _txImpl.hash;

  /// The nonce for transaction.
  ///
  /// Each transaction sent to the network from an account includes this, which ensures the order and non-replayability of a transaction.
  ///
  /// This must be equal to the current number of transactions ever sent to the network by the from address.
  @override
  int get nounce => _txImpl.nounce;

  /// The r portion of the elliptic curve signatures for transaction.
  ///
  /// This is more accurately, the x coordinate of the point r (from which the y can be computed, along with v).
  @override
  String get r => _txImpl.r;

  /// The s portion of the elliptic curve signatures for transaction.
  @override
  String get s => _txImpl.s;

  /// The address transaction is to.
  @override
  String? get to => _txImpl.to;

  /// The v portion of the elliptic curve signatures for transaction.
  ///
  /// This is used to refine which of the two possible points a given x-coordinate can have, and in EIP-155 is additionally used to encode the chain ID into the serialized transaction.
  @override
  int get v => _txImpl.v;

  /// The value (in wei) for transaction.
  @override
  BigInt get value => (_txImpl.value as BigNumber).toBigInt;

  @override
  String toString() => '$hash from $from with data $data';
}

class TransactionReceipt implements _TransactionReceiptImpl {
  final _TransactionReceiptImpl _impl;

  const TransactionReceipt._(this._impl);

  /// `true` if this transaction is a creating contract transaction.
  bool get isCreatingContract => to == null;

  /// The block hash of the block that this transaction was included in.
  @override
  String get blockHash => _impl.blockHash;

  /// The block height (number) of the block that this transaction was included in.
  @override
  int get blockNumber => _impl.blockNumber;

  /// This is true if the block is in a post-Byzantium Hard Fork block.
  @override
  bool get byzantium => _impl.byzantium;

  /// The number of blocks that have been mined since this transaction, including the actual block it was mined in.
  @override
  int get confirmations => _impl.confirmations;

  /// If this transaction has a `null` to address, it is an init transaction used to deploy a contract,
  /// in which case this is the address created by that contract.
  @override
  String? get contractAddress => _impl.contractAddress;

  /// For the block this transaction was included in,
  /// this is the sum of the gas used by each transaction in the ordered list of transactions up to (and including) this transaction.
  ///
  /// This is generally of little interest to developers.
  @override
  BigNumber get cumulativeGasUsed => _impl.cumulativeGasUsed;

  /// The address this transaction is from.
  @override
  String get from => _impl.from;

  /// The amount of gas actually used by this transaction.
  BigInt get gasUsed => (_impl.gasUsed as BigNumber).toBigInt;

  /// All the logs emitted by this transaction.
  @override
  List<Log> get logs =>
      _impl.logs.cast<_LogImpl>().map((e) => Log._(e)).toList();

  ///A bloom-filter, which includes all the addresses and topics included in any log in this transaction.
  @override
  String get logsBloom => _impl.logsBloom;

  /// The intermediate state root of a receipt.
  ///
  /// Only transactions included in blocks before the Byzantium Hard Fork have this property, as it was replaced by the status property.
  ///
  /// The property is generally of little use to developers. At the time it could be used to verify a state transition with a fraud-proof only considering the single transaction; without it the full block must be considered.
  @override
  String? get root => _impl.root;

  /// The status of a transaction is `true` is successful or `false` if it was reverted.
  ///
  /// Only transactions included in blocks post-Byzantium Hard Fork have this property.
  @override
  bool get status => (_impl.status as int) == 1;

  /// The address this transaction is to.
  ///
  /// This is `null` if the transaction was an init transaction, used to deploy a contract.
  @override
  String? get to => _impl.to;

  /// The hash of this transaction.
  @override
  String get transactionHash => _impl.transactionHash;

  /// The index of this transaction in the list of transactions included in the block this transaction was mined in.
  @override
  int get transactionIndex => _impl.transactionIndex;

  @override
  String toString() => status
      ? 'mined $transactionHash with $confirmations confirmations'
      : 'reverted $transactionHash';
}

/// A TransactionResponse includes all properties of a [Transaction] as well as several properties that are useful once it has been mined.
class TransactionResponse extends Transaction
    implements _TransactionResponseImpl {
  final _TransactionResponseImpl _impl;

  const TransactionResponse._(this._impl) : super._(_impl);

  /// The [AccessList] included in an EIP-2930 transaction, which will also have its type equal to 1.
  @override
  AccessList? get accessList =>
      _impl.accessList != null ? AccessList._(_impl.accessList!) : null;

  /// The hash of the block this transaction was mined in. If the block has not been mined, this is null.
  @override
  String? get blockHash => _impl.blockHash;

  /// The number ("height") of the block this transaction was mined in. If the block has not been mined, this is null.
  @override
  int? get blockNumber => _impl.blockNumber;

  /// The number of blocks that have been mined (including the initial block) since this transaction was mined.
  @override
  int get confirmations => _impl.confirmations;

  /// The serialized transaction.
  @override
  String get raw => _impl.raw;

  /// The timestamp of the block this transaction was mined in. If the block has not been mined, this is null.
  @override
  DateTime? get timestamp => _impl.timestamp != null
      ? DateTime.fromMillisecondsSinceEpoch(_impl.timestamp * 1000)
      : null;

  /// The EIP-2718 type of this transaction envelope, or null for legacy transactions that do not have an envelope.
  @override
  int? get type => _impl.type;

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
