import 'dart:async';

import 'ethers.dart';

/// Dart Class for ERC20 Contract, A standard API for tokens within smart contracts.
///
/// This standard provides basic functionality to transfer tokens, as well as allow tokens to be approved so they can be spent by another on-chain third party
class ContractERC20 {
  /// Minimal abi interface of ERC20
  static const abi = [
    'function name() view returns (string)',
    'function symbol() view returns (string)',
    'function balanceOf(address) view returns (uint)',
    'function decimals() view returns (uint)',
    'function totalSupply() view returns (uint)',
    'function allowance(address owner, address spender) external view returns (uint256)',
    'function transfer(address, uint)',
    'function transferFrom(address, address, uint)',
    'function approve(address, uint256)',
    'event Transfer(address indexed from, address indexed to, uint amount)',
    'event Approval(address indexed owner, address indexed spender, uint256 value)'
  ];

  /// Ethers Contract object.
  Contract contract;

  int _decimals = 0;

  String _name = '';

  String _symbol = '';

  BigInt _totalSupply = BigInt.zero;

  /// Instantiate ERC20 Contract using default abi.
  ///
  /// [isReadOnly] is determined by whether `providerOrSigner` is [Signer] or not.
  ContractERC20(String address, dynamic providerOrSigner)
      : assert(providerOrSigner != null, 'providerOrSigner should not be null'),
        assert(address.isNotEmpty, 'address should not be empty'),
        assert(
            EthUtils.isAddress(address), 'address should be in address format'),
        contract = Contract(address, abi, providerOrSigner);

  /// Returns the number of decimals used to get its user representation.
  ///
  /// For example, if `decimals` equals `2`, a balance of `505` tokens should
  /// be displayed to a user as `5,05` (`505 / 10 ** 2`).
  ///
  /// Tokens usually opt for a value of 18, imitating the relationship between
  /// Ether and Wei. This is the value `ERC20` uses, unless this function is
  /// overridden
  FutureOr<int> get decimals async {
    if (_decimals == 0)
      _decimals = (await contract.call<BigInt>('decimals')).toInt();
    return _decimals;
  }

  /// `true` if connected to [Provider], `false` if connected to [Signer].
  bool get isReadOnly => contract.isReadOnly;

  /// Returns the name of the token. If token doesn't have name, return empty string.
  FutureOr<String> get name async {
    try {
      if (_name.isEmpty) _name = await contract.call<String>('name');
    } catch (error) {}
    return _name;
  }

  /// Returns the symbol of the token, usually a shorter version of the name.
  FutureOr<String> get symbol async {
    if (_symbol.isEmpty) _symbol = await contract.call<String>('symbol');
    return _symbol;
  }

  /// Returns the amount of tokens in existence.
  FutureOr<BigInt> get totalSupply async {
    if (_totalSupply == BigInt.zero)
      _totalSupply = await contract.call<BigInt>('totalSupply');
    return _totalSupply;
  }

  /// Returns the remaining number of tokens that [spender] will be allowed to spend on behalf of [owner] through `transferFrom`.
  ///
  /// This is zero by default.
  Future<BigInt> allowance(String owner, String spender) async =>
      contract.call<BigInt>('allowance', [owner, spender]);

  /// [Log] of `Approval` events.
  Future<List<Event>> approvalEvents(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(
          contract.getFilter('Approval', args ?? []), startBlock, endBlock);

  /// Sets [amount] as the allowance of [spender] over the caller's tokens.
  Future<TransactionResponse> approve(String spender, BigInt amount) =>
      contract.send('approve', [spender, amount.toString()]);

  /// Returns the amount of tokens owned by [address]
  Future<BigInt> balanceOf(String address) async =>
      contract.call<BigInt>('balanceOf', [address]);

  /// Connect current [contract] with [providerOrSigner]
  void connect(dynamic providerOrSigner) {
    assert(providerOrSigner is Provider || providerOrSigner is Signer);
    contract = contract.connect(providerOrSigner);
  }

  /// Multicall of [allowance], may not be in the same block.
  Future<List<BigInt>> multicallAllowance(
      List<String> owners, List<String> spenders) async {
    assert(owners.isNotEmpty, 'Owner list empty');
    assert(spenders.isNotEmpty, 'Spender list empty');
    assert(owners.length == spenders.length,
        'Owner list length must be same as spender');
    return Future.wait(Iterable<int>.generate(owners.length).map(
      (e) => allowance(owners[e], spenders[e]),
    ));
  }

  /// Multicall of [balanceOf], may not be in the same block.
  Future<List<BigInt>> multicallBalanceOf(List<String> addresses) async {
    assert(addresses.isNotEmpty, 'address should not be empty');
    return Future.wait(Iterable<int>.generate(addresses.length)
        .map((e) => balanceOf(addresses[e])));
  }

  /// Emitted when the allowance of a `spender` for an `owner` is set by a call to `approve`.
  ///
  /// `value` is the new allowance.
  void onApproval(
    void Function(
      String owner,
      String spender,
      BigInt value,
      Event event,
    )
        callback,
  ) =>
      contract.on(
        'Approval',
        (String owner, String spender, BigNumber value, dynamic data) =>
            callback(
          owner,
          spender,
          value.toBigInt,
          Event.fromJS(data),
        ),
      );

  /// Emitted when `amount` tokens are moved from one account (`from`) to another (`to`).
  ///
  /// Note that `amount` may be zero.
  void onTransfer(
    void Function(
      String from,
      String to,
      BigInt amount,
      Event event,
    )
        callback,
  ) =>
      contract.on(
        'Transfer',
        (String from, String to, BigNumber amount, dynamic data) => callback(
          from,
          to,
          amount.toBigInt,
          Event.fromJS(data),
        ),
      );

  /// Transfer token from `msg.sender` to [recipient] in [amount]. Emits `Transfer` events when called.
  Future<TransactionResponse> transfer(String recipient, BigInt amount) =>
      contract.send('transfer', [recipient, amount.toString()]);

  /// [Log] of `Transfer` events.
  Future<List<Event>> transferEvents(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(
          contract.getFilter('Transfer', args ?? []), startBlock, endBlock);

  /// Transfer token from [sender] to [recipient] in [amount]. Emits `Transfer` events when called.
  Future<TransactionResponse> transferFrom(
          String sender, String recipient, BigInt amount) =>
      contract.send('transferFrom', [sender, recipient, amount.toString()]);
}
