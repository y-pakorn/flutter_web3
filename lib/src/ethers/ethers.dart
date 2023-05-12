@JS("ethers")
library ethers;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import './exception.dart';
import '../ethereum/ethereum.dart';
import '../ethereum/exception.dart';
import '../ethereum/utils.dart';
import '../interop_wrapper.dart';
import '../wallet_connect/wallet_connect.dart';

part 'access_list.dart';
part 'block.dart';
part 'contract.dart';
part 'event.dart';
part 'fee_data.dart';
part 'filter.dart';
part 'interface.dart';
part 'interop.dart';
part 'log.dart';
part 'network.dart';
part 'provider.dart';
part 'signer.dart';
part 'transaction.dart';
part 'wallet.dart';

/// Get default [AbiCoder].
AbiCoder get abiCoder => EthUtils.defaultAbiCoder;

/// Getter for default Web3Provider object.
Web3Provider? get provider =>
    Ethereum.isSupported ? Web3Provider(Ethereum.provider) : null;

/// The AbiCoder is a collection of Coders which can be used to encode and decode the binary data formats used to interoperate between the EVM and higher level libraries.
///
/// Most developers will never need to use this class directly, since the [Interface] class greatly simplifies these operations.
@JS("AbiCoder")
class AbiCoder {
  /// Decode the list [data] according to the list of [types].
  external List<dynamic> decode(List<String> types, String data);

  /// Encode the list [values] according to the list of [types].
  external String encode(List<String> types, List<dynamic> values);
}

/// Many operations in Ethereum operate on numbers which are outside the range of safe values to use in JavaScript.
///
/// A BigNumber is an object which safely allows mathematical operations on numbers of any magnitude.
///
/// Most operations which need to return a value will return a BigNumber and parameters which accept values will generally accept them.
@JS("BigNumber")
class BigNumber {
  /// Returns the value of BigNumber as a base-16, 0x-prefixed DataHexString.
  external String toHexString();

  /// Returns the value of BigNumber as a JavaScript value.
  ///
  /// This will throw an error if the value is greater than or equal to Number.MAX_SAFE_INTEGER or less than or equal to Number.MIN_SAFE_INTEGER.
  external num toNumber();

  /// Returns the value of BigNumber as a base-10 string.
  external String toString();

  /// The constructor of BigNumber cannot be called directly. Instead, Use the static BigNumber.from.
  external static BigNumber from(String num);
}

/// These utilities are used extensively within the library, but are also quite useful for application developers.
@JS("utils")
class EthUtils {
  /// An [AbiCoder] created when the library is imported which is used by the [Interface].
  external static AbiCoder get defaultAbiCoder;

  external static String arrayify(String hash);

  /// Returns a string with value grouped by 3 digits, separated by ,.
  ///
  /// ---
  ///
  /// ```dart
  /// EthUtils.commify("-1000.3000");
  /// // '-1,000.3'
  /// ```
  external static String commify(String value);

  /// The equivalent to calling `formatUnits(value, "ether")`.
  ///
  /// ---
  ///
  /// ```dart
  /// final value = BigNumber.from("1000000000000000000");
  ///
  /// EthUtils.formatEther(value);
  /// // '1.0'
  /// ```
  external static String formatEther(String value);

  /// Returns a [String] representation of [value] formatted with [unit] digits (if it is a number) or to the [unit] specified (if a string).
  ///
  /// ---
  ///
  /// ```dart
  /// final oneGwei = "1000000000";
  /// final oneEther = "1000000000000000000";
  ///
  /// EthUtils.formatUnits(oneGwei, 0);
  /// // '1000000000'
  ///
  /// EthUtils.formatUnits(oneGwei, "gwei");
  /// // '1.0'
  ///
  /// EthUtils.formatUnits(oneGwei, 9);
  /// // '1.0'
  ///
  /// EthUtils.formatUnits(oneEther);
  /// // '1.0'
  ///
  /// EthUtils.formatUnits(oneEther, 18);
  /// // '1.0'
  /// ```
  external static String formatUnits(String value, [dynamic unit = 'ether']);

  /// Returns address as a Checksum Address.
  ///
  /// If address is an invalid 40-nibble HexString or if it contains mixed case and the checksum is invalid, an INVALID_ARGUMENT Error is thrown.
  ///
  /// The value of address may be any supported address format.
  external static String getAddress(String address);

  /// Computes the EIP-191 personal message digest of [message].
  ///
  /// Personal messages are converted to UTF-8 bytes and prefixed with `\x19Ethereum Signed Message:` and the length of message.
  ///
  /// ---
  ///
  /// ```dart
  /// // Hashing a string message
  /// EthUtils.hashMessage("Hello World")
  /// // '0xa1de988600a42c4b4ab089b619297c17d53cffae5d5120d82d8a92d0bb3b78f2'
  ///
  /// // Hashing binary data (also "Hello World", but as bytes)
  /// utils.hashMessage( [ 72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100 ])
  /// // '0xa1de988600a42c4b4ab089b619297c17d53cffae5d5120d82d8a92d0bb3b78f2'
  /// ```
  external static String hashMessage(dynamic message);

  /// The Ethereum Identity function computes the `KECCAK256` hash of the text bytes.
  external static String id(String text);

  /// Returns true if address is valid (in any supported format).
  external static bool isAddress(String address);

  /// The equivalent to calling `parseUnits(value, "ether")`.
  ///
  /// ---
  ///
  /// ```dart
  /// parseEther("1.0");
  /// // { BigNumber: "1000000000000000000" }
  ///
  /// parseEther("-0.5");
  /// // { BigNumber: "-500000000000000000" }
  /// ```
  external static BigNumber parseEther(String value);

  /// Returns a [BigNumber] representation of [value], parsed with [unit] digits (if it is a number) or from the [unit] specified (if a string).
  ///
  /// ---
  ///
  /// ```dart
  /// EthUtils.parseUnits("1.0");
  /// // { BigNumber: "1000000000000000000" }
  ///
  /// EthUtils.parseUnits("1.0", "ether");
  /// // { BigNumber: "1000000000000000000" }
  ///
  /// EthUtils.parseUnits("1.0", 18);
  /// // { BigNumber: "1000000000000000000" }
  ///
  /// EthUtils.parseUnits("121.0", "gwei");
  /// // { BigNumber: "121000000000" }
  ///
  /// EthUtils.parseUnits("121.0", 9);
  /// // { BigNumber: "121000000000" }
  /// ```
  external static BigNumber parseUnits(String value, [dynamic unit = 'ether']);

  /// Returns the `KECCAK256` of the non-standard encoded [values] packed according to their respective type in [types].
  ///
  /// ---
  ///
  /// ```dart
  /// utils.solidityKeccak256([ "int16", "uint48" ], [ -1, 12 ])
  /// // '0x81da7abb5c9c7515f57dab2fc946f01217ab52f3bd8958bc36bd55894451a93c'
  /// ```
  external static String solidityKeccak256(
      List<String> types, List<dynamic> values);

  /// Returns the non-standard encoded [values] packed according to their respective type in [types].
  ///
  /// ---
  ///
  /// ```dart
  /// utils.solidityPack([ "int16", "uint48" ], [ -1, 12 ])
  /// // '0xffff00000000000c'
  ///
  /// utils.solidityPack([ "string", "uint8" ], [ "Hello", 3 ])
  /// // '0x48656c6c6f03'
  /// ```
  external static String solidityPack(List<String> types, List<dynamic> values);

  /// Returns the `SHA2-256` of the non-standard encoded [values] packed according to their respective type in [types].
  ///
  /// ---
  ///
  /// ```dart
  /// utils.soliditySha256([ "int16", "uint48" ], [ -1, 12 ])
  /// // '0xa5580fb602f6e2ba9c588011dc4e6c2335e0f5d970dc45869db8f217efc6911a'
  /// ```
  external static String soliditySha256(
      List<String> types, List<dynamic> values);

  /// Returns the address that signed [message] producing [signature].
  ///
  /// The signature may have a non-canonical v (i.e. does not need to be 27 or 28), in which case it will be normalized to compute the `recoveryParam` which will then be used to compute the address;
  /// This allows systems which use the v to encode additional data (such as EIP-155) to be used since the v parameter is still completely non-ambiguous.
  external static String verifyMessage(String message, String signature);
}

/// [BigInt] extension for converting between Dart and JS class.
extension BigIntExtension on BigInt {
  /// Convert Dart [BigInt] to JS [BigNumber].
  BigNumber get toBigNumber => BigNumber.from(this.toString());
}

/// [BigNumber] extension for converting between Dart and JS class.
extension BigNumberExtension on BigNumber {
  /// Convert JS [BigNumber] to Dart [BigInt].
  BigInt get toBigInt => BigInt.parse(this.toString());

  /// Convert JS [BigNumber] to Dart [int].
  int get toInt => int.parse(this.toString());

  /// Convert JS [BigNumber] to Dart [double].
  double get toDouble => double.parse(this.toString());
}
