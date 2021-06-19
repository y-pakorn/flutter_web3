import '../objects/objects.dart';
import '../utils.dart';
import 'ethers.dart';
import 'ethers_wrapper.dart';

/// Get default [AbiCoder].
AbiCoder get abiCoder => Utils.defaultAbiCoder;

/// Convert JS [BigNumber] to Dart [BigInt].
BigInt bigNumberToBigInt(BigNumber bigNumber) =>
    BigInt.parse(bigNumber.toString());

/// Construct [Contract] with [Signer] from default [Provider].
Contract defaultContractWithSigner(String address, List<String> abi) =>
    Contract(address, abi, provider!.getSigner());

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
  final Contract contract;

  /// True if [Signer] is attached to [contract].
  final bool isReadOnly;

  /// Instantiate ERC20 Contract using default abi.
  ///
  /// [isReadOnly] is determined by whether `providerOrSigner` is [Signer] or not.
  ContractERC20(String address, dynamic providerOrSigner)
      : assert(providerOrSigner != null, 'providerOrSigner should not be null'),
        assert(address.isNotEmpty, 'address should not be empty'),
        assert(Utils.isAddress(address), 'address should be '),
        contract = Contract(address, abi, providerOrSigner),
        isReadOnly = !(providerOrSigner is Signer);

  /// Returns the number of decimals used to get its user representation.
  ///
  /// For example, if `decimals` equals `2`, a balance of `505` tokens should
  /// be displayed to a user as `5,05` (`505 / 10 ** 2`).
  ///
  /// Tokens usually opt for a value of 18, imitating the relationship between
  /// Ether and Wei. This is the value `ERC20` uses, unless this function is
  /// overridden
  Future<int> get decimals async =>
      (await contract.call<BigNumber>('decimals')).toInt;

  /// Returns the name of the token.
  Future<String> get name => contract.call<String>('name');

  /// Returns the symbol of the token, usually a shorter version of the name.
  Future<String> get symbol => contract.call<String>('symbol');

  /// Returns the amount of tokens in existence.
  Future<BigInt> get totalSupply async =>
      (await contract.call<BigNumber>('totalSupply')).toBigInt;

  /// Returns the remaining number of tokens that [spender] will be allowed to spend on behalf of [owner] through `transferFrom`.
  ///
  /// This is zero by default.
  Future<BigInt> allowance(String owner, String spender) async =>
      (await contract.call<BigNumber>('allowance', [owner, spender])).toBigInt;

  /// Sets [amount] as the allowance of [spender] over the caller's tokens.
  Future<TransactionResponse> approve(String spender, BigInt amount) =>
      contract.send('approve', [spender, amount.toString()]);

  Future<BigInt> balanceOf(String address) async =>
      (await contract.call<BigNumber>('balanceOf', [address])).toBigInt;

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
                  String owner, String spender, BigInt value, dynamic data)
              callback) =>
      contract.on(
          'Approval',
          (String owner, String spender, BigNumber value, dynamic data) =>
              callback(owner, spender, value.toBigInt, convertToDart(data)));

  /// Emitted when `amount` tokens are moved from one account (`from`) to another (`to`).
  ///
  /// Note that `amount` may be zero.
  void onTransfer(
          void Function(String from, String to, BigInt amount, dynamic data)
              callback) =>
      contract.on(
          'Transfer',
          (String from, String to, BigNumber amount, dynamic data) =>
              callback(from, to, amount.toBigInt, convertToDart(data)));

  /// Transfer token from `msg.sender` to [recipient] in [amount]. Emits `Transfer` events when called.
  Future<TransactionResponse> transfer(String recipient, BigInt amount) =>
      contract.send('transfer', [recipient, amount.toString()]);

  /// Transfer token from [sender] to [recipient] in [amount]. Emits `Transfer` events when called.
  Future<TransactionResponse> transferFrom(
          String sender, String recipient, BigInt amount) =>
      contract.send('transfer', [sender, recipient, amount.toString()]);

  /// [Log] of `Transfer` events.
  Future<List<Log>> transferLogs(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(
          contract.getFilter('Transfer', args ?? []), startBlock, endBlock);

  /// [Log] of `Approval` events.
  Future<List<Log>> approvalLogs(
          [List<dynamic>? args, dynamic startBlock, dynamic endBlock]) =>
      contract.queryFilter(
          contract.getFilter('Approval', args ?? []), startBlock, endBlock);
}

extension BigIntExt on BigInt {
  /// Convert Dart [BigInt] to JS [BigNumber].
  BigNumber get toBigNumber => BigNumber.from(this.toString());
}

extension BigNumberExt on BigNumber {
  /// Convert JS [BigNumber] to Dart [BigInt].
  BigInt get toBigInt => BigInt.parse(this.toString());

  /// Convert JS [BigNumber] to Dart [int].
  int get toInt => int.parse(this.toString());

  /// Convert JS [BigNumber] to Dart [double].
  double get toDouble => double.parse(this.toString());
}
