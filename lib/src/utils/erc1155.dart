import 'dart:async';

import '../ethers/ethers.dart';

/// Dart Class for ERC1155 Contract, A standard API for fungibility-agnostic and gas-efficient tokens within smart contracts.
class ContractERC1155 {
  /// Minimal abi interface of ERC1155
  static const abi = [
    'function balanceOf(address,uint) view returns (uint)',
    'function balanceOfBatch(address[],uint[]) view returns (uint[])',
    'function uri(uint) view returns (string)',
    'function isApprovedForAll(address owner, address spender) view returns (bool)',
    'function setApprovedForAll(address spender, bool approved)',
    'function safeTransferFrom(address, address, uint, uint, bytes)',
    'function safeBatchTransferFrom(address, address, uint[], uint[], bytes)',
    'function totalSupply(uint256 id) view returns (uint256)',
    'function exists(uint256 id) view returns (bool)',
    'function burn(address account, uint256 id, uint256 value)',
    'function burnBatch(address account, uint256[] ids, uint256[] values)',
    'event ApprovalForAll(address indexed account, address indexed operator, bool approved)',
    'event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values)',
    'event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value)',
  ];

  /// Ethers Contract object.
  Contract contract;

  String _uri = '';

  /// Instantiate ERC1155 Contract using default abi if [abi] is not `null`.
  ///
  /// [isReadOnly] is determined by whether [providerOrSigner] is [Signer] or not.
  ContractERC1155(String address, dynamic providerOrSigner, [dynamic abi])
      : assert(providerOrSigner != null, 'providerOrSigner should not be null'),
        assert(address.isNotEmpty, 'address should not be empty'),
        assert(
            EthUtils.isAddress(address), 'address should be in address format'),
        contract =
            Contract(address, abi ?? ContractERC1155.abi, providerOrSigner);

  /// [Log] of `ApprovalForAll` events.
  Future<List<Event>> approvalForAllEvents(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(contract.getFilter('ApprovalForAll', args ?? []),
          startBlock, endBlock);

  /// Returns the amount of tokens [id] owned by [address]
  Future<BigInt> balanceOf(String address, int id) async =>
      contract.call<BigInt>('balanceOf', [address, id]);

  /// Returns the amount of tokens [ids] owned by [addresses]
  Future<List<BigInt>> balanceOfBatch(
          List<String> addresses, List<int> ids) async =>
      (await contract.call<List>('balanceOfBatch', [addresses, ids]))
          .cast<BigNumber>()
          .map((e) => e.toBigInt)
          .toList();

  /// Returns the amount of tokens [ids] owned by [address]
  Future<List<BigInt>> balanceOfBatchSingleAddress(
          String address, List<int> ids) async =>
      (await contract.call<List>(
        'balanceOfBatch',
        [
          List.generate(ids.length, (index) => address),
          ids,
        ],
      ))
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

/// Dart Class for ERC1155Burnable Contract that allows token holders to destroy both their own tokens and those that they have been approved to use.
class ContractERC1155Burnable extends ContractERC1155 with ERC1155Supply {
  /// Instantiate ERC1155 Contract using default abi if [abi] is not `null`.
  ///
  /// [isReadOnly] is determined by whether [providerOrSigner] is [Signer] or not.
  ContractERC1155Burnable(String address, dynamic providerOrSigner,
      [dynamic abi])
      : super(address, providerOrSigner, abi);
}

/// Dart Class for ERC1155Supply Contract that adds tracking of total supply per id to normal ERC1155.
class ContractERC1155Supply extends ContractERC1155 with ERC1155Supply {
  /// Instantiate ERC1155 Contract using default abi if [abi] is not `null`.
  ///
  /// [isReadOnly] is determined by whether [providerOrSigner] is [Signer] or not.
  ContractERC1155Supply(String address, dynamic providerOrSigner, [dynamic abi])
      : super(address, providerOrSigner, abi);
}

/// Dart Class for both [ContractERC1155Supply] and [ContractERC1155Burnable] combined.
class ContractERC1155SupplyBurnable extends ContractERC1155
    with ERC1155Supply, ERC1155Burnable {
  /// Instantiate ERC1155 Contract using default abi if [abi] is not `null`.
  ///
  /// [isReadOnly] is determined by whether [providerOrSigner] is [Signer] or not.
  ContractERC1155SupplyBurnable(String address, dynamic providerOrSigner,
      [dynamic abi])
      : super(address, providerOrSigner, abi);
}

/// Dart Mixin for ERC1155Burnable that allows token holders to destroy both their own tokens and those that they have been approved to use.
mixin ERC1155Burnable on ContractERC1155 {
  Future<TransactionResponse> burn(String address, int id, BigInt value) =>
      contract.send('burn', [address, id, value.toString()]);

  Future<TransactionResponse> burnBatch(
          String address, List<int> ids, List<BigInt> values) =>
      contract.send('burnBatch', [
        address,
        ids,
        values.map((e) => e.toString()).toList(),
      ]);
}

/// Dart Mixin for ERC1155Supply that adds tracking of total supply per id to normal ERC1155.
mixin ERC1155Supply on ContractERC1155 {
  /// Indicates weither any token exist with a given [id], or not.
  Future<bool> exists(int id) async {
    return contract.call<bool>('exists', [id]);
  }

  /// Total amount of tokens in with a given [id].
  Future<BigInt> totalSupply(int id) async {
    return contract.call<BigInt>('totalSupply', [id]);
  }
}
