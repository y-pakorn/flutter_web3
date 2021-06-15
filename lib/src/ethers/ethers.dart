@JS("ethers")
library ethers;

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import '../ethereum/ethereum.dart';

/// Getter for default Web3Provider object.
Web3Provider? get provider => ethereum != null ? Web3Provider(ethereum!) : null;

/// The AbiCoder is a collection of Coders which can be used to encode and decode the binary data formats used to interoperate between the EVM and higher level libraries.
///
/// Most developers will never need to use this class directly, since the [Interface] class greatly simplifies these operations.
@JS("AbiCoder")
class AbiCoder {
  external String decode(List<String> types, String data);

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
  external int toNumber();

  /// Returns the value of BigNumber as a base-10 string.
  external String toString();

  /// The constructor of BigNumber cannot be called directly. Instead, Use the static BigNumber.from.
  external static BigNumber from(String num);
}

/// A Contract is an abstraction of code that has been deployed to the blockchain.
///
/// A Contract may be sent transactions, which will trigger its code to be run with the input of the transaction data.
@JS("Contract")
class Contract {
  /// Contruct Contract object for invoking smart contract method.
  ///
  /// Use [Provider] in [providerOrSigner] for read-only contract calls, or use [Signer] for read-write contract calls.
  external Contract(String address, dynamic abi, dynamic providerOrSigner);

  /// This is the ABI as an [Interface].
  external Interface get interface;

  /// If a [Provider] was provided to the constructor, this is that provider. If a [Signer] was provided that had a [Provider], this is that provider.
  external Provider get provider;

  /// If a [Signer] was provided to the constructor, this is that signer.
  external Signer get signer;

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  external int listenerCount([String? eventName]);

  /// Returns the list of Listeners for the [eventName] events.
  external List<dynamic> listeners(String eventName);

  /// Internal, use [offEvent] instead.
  @internal
  external off(String eventName, [Function? func]);

  /// Internal, use [onEvent] instead.
  @internal
  external on(String eventName, Function func);

  /// Internal, use [onceEvent] instead.
  @internal
  external once(String eventName, Function func);

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  external removeAllListeners([String? eventName]);
}

@JS('constants')
class EtherConstants {
  /// The Address Zero, which is 20 bytes (40 nibbles) of zero.
  @JS('AddressZero')
  // ignore: non_constant_identifier_names
  external static String get AddressZero;

  /// The Ether symbol,
  @JS('EtherSymbol')
  // ignore: non_constant_identifier_names
  external static String get EtherSymbol;

  /// The Hash Zero, which is 32 bytes (64 nibbles) of zero.
  @JS('HashZero')
  // ignore: non_constant_identifier_names
  external static String get HashZero;
}

/// Format types of Interface
@JS('utils.FormatTypes')
class FormatTypes {
  /// Example
  /// [{"type":"function","name":"balanceOf","constant":true,"stateMutability":"view","payable":false,"inputs":[{"type":"address"}],"outputs":[{"type":"uint256"}]}]
  external static dynamic json;

  /// Example
  /// [
  /// 'function balanceOf(address owner) view returns (uint256)',
  /// ]
  external static dynamic full;

  /// Example
  /// [
  /// 'function balanceOf(address) view returns (uint256)',
  /// ]
  external static dynamic minimal;
}

/// The Interface Class abstracts the encoding and decoding required to interact with contracts on the Ethereum network.
///
/// Many of the standards organically evolved along side the Solidity language, which other languages have adopted to remain compatible with existing deployed contracts.
///
/// The EVM itself does not understand what the ABI is. It is simply an agreed upon set of formats to encode various types of data which each contract can expect so they can interoperate with each other.
@JS("utils.Interface")
class Interface {
  /// Create a new Interface from a JSON string or object representing abi.
  ///
  /// The abi may be a JSON string or the parsed Object (using JSON.parse) which is emitted by the Solidity compiler (or compatible languages).
  ///
  /// The abi may also be a Human-Readable Abi, which is a format the Ethers created to simplify manually typing the ABI into the source and so that a Contract ABI can also be referenced easily within the same source file.
  external Interface(dynamic abi);

  /// Return the formatted [Interface].
  ///
  /// [types] must be from [FormatTypes] variable.
  ///
  /// If the format type is json a single string is returned, otherwise an Array of the human-readable strings is returned.
  external dynamic format([dynamic types]);
}

/// The JSON-RPC API is a popular method for interacting with Ethereum and is available in all major Ethereum node implementations (e.g. Geth and Parity) as well as many third-party web services (e.g. INFURA)
@JS("providers.JsonRpcProvider")
class JsonRpcProvider extends Provider {
  external JsonRpcProvider(String rpcUrl);
}

/// A Provider is an abstraction of a connection to the Ethereum network, providing a concise, consistent interface to standard Ethereum node functionality.
///
/// The ethers.js library provides several options which should cover the vast majority of use-cases, but also includes the necessary functions and classes for sub-classing if a more custom configuration is necessary.
@JS("providers")
class Provider {}

@JS("signer.Signer")
class Signer {
  external static bool isSigner(Object object);
}

/// These utilities are used extensively within the library, but are also quite useful for application developers.
@JS("utils")
class Utils {
  /// An [AbiCoder] created when the library is imported which is used by the [Interface].
  external static AbiCoder get defaultAbiCoder;

  external static String arrayify(String hash);

  /// Returns a string with value grouped by 3 digits, separated by ,.
  external static String commify(String value);

  /// Returns a string representation of value formatted with unit digits (if it is a number) or to the unit specified (if a string).
  external static BigNumber formatUnits(String value, [String unit = 'ether']);

  /// Returns address as a Checksum Address.
  ///
  /// If address is an invalid 40-nibble HexString or if it contains mixed case and the checksum is invalid, an INVALID_ARGUMENT Error is thrown.
  ///
  /// The value of address may be any supported address format.
  external static String getAddress(String address);

  /// Returns true if address is valid (in any supported format).
  external static bool isAddress(String address);

  external static String verifyMessage(String hash, String sig);
}

/// The Web3Provider is meant to ease moving from a web3.js based application to ethers by wrapping an existing Web3-compatible (such as a Web3HttpProvider, Web3IpcProvider or Web3WsProvider) and exposing it as an ethers.js Provider which can then be used with the rest of the library.
///
/// This may also be used to wrap a standard [EIP-1193 Provider](link-eip-1193].
@JS("providers.Web3Provider")
class Web3Provider extends Provider {
  external Web3Provider(Ethereum eth);

  external Signer getSigner();
}
