import 'dart:async';

import '../ethers/ethers.dart';

/// Dart Class for ERC1155 Contract, A standard API for fungibility-agnostic and gas-efficient tokens within smart contracts.
class ContractERC1155 {
  /// Minimal abi interface of ERC20
  static const abi = [
    'function balanceOf(address,uint) view returns (uint)',
    'function balanceOfBatch(address[],uint[]) view returns (uint[])',
    'function uri(uint) view returns (string)',
    'function isApprovedForAll(address owner, address spender) view returns (bool)',
    'function setApprovedForAll(address spender, bool approved)',
    'function safeTransferFrom(address, address, uint, uint, bytes)',
    'function safeBatchTransferFrom(address, address, uint[], uint[], bytes)',
    'event ApprovalForAll(address indexed account, address indexed operator, bool approved)',
    'event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values)',
    'event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value)',
  ];

  /// Ethers Contract object.
  Contract contract;

  String _uri = '';

  /// Instantiate ERC1155 Contract using default abi.
  ///
  /// [isReadOnly] is determined by whether `providerOrSigner` is [Signer] or not.
  ContractERC1155(String address, dynamic providerOrSigner)
      : assert(providerOrSigner != null, 'providerOrSigner should not be null'),
        assert(address.isNotEmpty, 'address should not be empty'),
        assert(
            EthUtils.isAddress(address), 'address should be in address format'),
        contract = Contract(address, abi, providerOrSigner);

  /// [Log] of `ApprovalForAll` events.
  Future<List<Event>> approvalForAllEvents(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(contract.getFilter('ApprovalForAll', args ?? []),
          startBlock, endBlock);

  /// Returns the amount of tokens [id] owned by [address]
  Future<BigInt> balanceOf(String address, int id) async =>
      contract.call<BigInt>('balanceOf', [address, id]);

  /// Returns the amount of tokens [id] owned by [address]
  Future<List<BigInt>> balanceOfBatch(
          List<String> address, List<int> id) async =>
      (await contract.call<List>('balanceOfBatch', [address, id]))
          .cast<BigNumber>()
          .map((e) => e.toBigInt)
          .toList();

  /// Connect current [contract] with [providerOrSigner]
  void connect(dynamic providerOrSigner) {
    assert(providerOrSigner is Provider || providerOrSigner is Signer);
    contract = contract.connect(providerOrSigner);
  }

  /// Returns `true` if [spender] is approved to transfer [owner] tokens
  Future<bool> isApprovedForAll(String owner, String spender) async =>
      contract.call<bool>('isApprovedForAll', [owner, spender]);

  /// Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to `approved`.
  void onApprovalForAll(
    void Function(
      String account,
      String operator,
      Event event,
    )
        callback,
  ) =>
      contract.on(
        'ApprovalForAll',
        (String account, String operator, dynamic data) => callback(
          account,
          operator,
          Event.fromJS(data),
        ),
      );

  /// Equivalent to multiple `TransferSingle` events, where `operator`, `from` and `to` are the same for all transfers.
  void onTransferBatch(
    void Function(
      String operator,
      String from,
      String to,
      Event event,
    )
        callback,
  ) =>
      contract.on(
        'TransferBatch',
        (String operator, String from, String to, dynamic data) => callback(
          operator,
          from,
          to,
          Event.fromJS(data),
        ),
      );

  /// Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
  void onTransferSingle(
    void Function(
      String operator,
      String from,
      String to,
      Event event,
    )
        callback,
  ) =>
      contract.on(
        'TransferSingle',
        (String operator, String from, String to, dynamic data) => callback(
          operator,
          from,
          to,
          Event.fromJS(data),
        ),
      );

  /// Batched version of [safeTransferFrom].
  Future<TransactionResponse> safeBatchTransferFrom(
    String from,
    String to,
    List<int> id,
    List<BigInt> amount,
    String data,
  ) =>
      contract.send('safeBatchTransferFrom',
          [from, to, id, amount.map((e) => e.toString()).toList(), data]);

  /// Transfers [amount] tokens of token type [id] from [from] to [to].
  Future<TransactionResponse> safeTransferFrom(
    String from,
    String to,
    int id,
    BigInt amount,
    String data,
  ) =>
      contract.send('safeTransferFrom', [from, to, id, amount, data]);

  /// Grants or revokes permission to [spender] to transfer the caller's tokens, according to [approved],
  Future<TransactionResponse> setApprovedForAll(
          String spender, bool approved) =>
      contract.send('setApprovedForAll', [spender, approved]);

  /// [Log] of `TransferBatch` events.
  Future<List<Event>> transferBatchEvents(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(contract.getFilter('TransferBatch', args ?? []),
          startBlock, endBlock);

  /// [Log] of `TransferSingle` events.
  Future<List<Event>> transferSingleEvents(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(contract.getFilter('TransferSingle', args ?? []),
          startBlock, endBlock);

  /// Returns the URI for token type [id].
  ///
  /// This will also replace `{id}` in original uri fetched by [id].
  FutureOr<String> uri(int id) async {
    if (_uri.isEmpty) _uri = await contract.call<String>('uri', [id]);
    return _uri.replaceAll('{id}', id.toString());
  }
}
