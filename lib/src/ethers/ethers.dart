@JS("ethers")
library ethers;

import 'package:js/js.dart';

import '../ethereum/ethereum.dart';

/// Getter for default Web3Provider object.
Web3Provider? get provider => ethereum != null ? Web3Provider(ethereum!) : null;

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

/// A Contract is an abstraction of code that has been deployed to the blockchain.
///
/// A Contract may be sent transactions, which will trigger its code to be run with the input of the transaction data.
@JS("Contract")
class Contract {
  /// Contruct Contract object for invoking smart contract method.
  ///
  /// Use [Provider] in [providerOrSigner] for read-only contract calls, or use [Signer] for read-write contract calls.
  external Contract(String address, dynamic abi, dynamic providerOrSigner);

  /// This is the address (or ENS name) the contract was constructed with.
  external String get address;

  /// This is the ABI as an [Interface].
  external Interface get interface;

  /// If a [Provider] was provided to the constructor, this is that provider. If a [Signer] was provided that had a [Provider], this is that provider.
  external Provider get provider;

  /// If a [Signer] was provided to the constructor, this is that signer.
  external Signer? get signer;

  ///Returns a new instance of the [Contract], but connected to [Provider] or [Signer].
  ///
  ///By passing in a [Provider], this will return a downgraded Contract which only has read-only access (i.e. constant calls).
  ///
  ///By passing in a [Signer]. this will return a Contract which will act on behalf of that signer.
  external Contract connect(dynamic providerOrSigner);

  /// Returns the number of listeners for the [eventName] events. If no [eventName] is provided, the total number of listeners is returned.
  external int listenerCount([String? eventName]);

  /// Returns the list of Listeners for the [eventName] events.
  external List<dynamic> listeners(String eventName);

  /// Remove all the listeners for the [eventName] events. If no [eventName] is provided, all events are removed.
  external removeAllListeners([String? eventName]);
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
  /// EthUtils.commify("-1000.3000");
  /// // '-1,000.3'
  external static String commify(String value);

  /// The equivalent to calling `formatUnits(value, "ether")`.
  ///
  /// ---
  ///
  /// final value = BigNumber.from("1000000000000000000");
  ///
  /// EthUtils.formatEther(value);
  /// // '1.0'
  external static String formatEther(String value);

  /// Returns a [String] representation of [value] formatted with [unit] digits (if it is a number) or to the [unit] specified (if a string).
  ///
  /// ---
  ///
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
  /// Hashing a string message
  /// EthUtils.hashMessage("Hello World")
  /// // '0xa1de988600a42c4b4ab089b619297c17d53cffae5d5120d82d8a92d0bb3b78f2'
  ///
  /// Hashing binary data (also "Hello World", but as bytes)
  /// utils.hashMessage( [ 72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100 ])
  /// // '0xa1de988600a42c4b4ab089b619297c17d53cffae5d5120d82d8a92d0bb3b78f2'
  external static String hashMessage(dynamic message);

  /// The Ethereum Identity function computes the `KECCAK256` hash of the text bytes.
  external static String id(String text);

  /// Returns true if address is valid (in any supported format).
  external static bool isAddress(String address);

  /// The equivalent to calling `parseUnits(value, "ether")`.
  ///
  /// ---
  ///
  /// parseEther("1.0");
  /// // { BigNumber: "1000000000000000000" }
  ///
  /// parseEther("-0.5");
  /// // { BigNumber: "-500000000000000000" }
  external static BigNumber parseEther(String value);

  /// Returns a [BigNumber] representation of [value], parsed with [unit] digits (if it is a number) or from the [unit] specified (if a string).
  ///
  /// ---
  ///
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
  external static BigNumber parseUnit(String value, [dynamic unit = 'ether']);

  /// Returns the `KECCAK256` of the non-standard encoded [values] packed according to their respective type in [types].
  ///
  /// ---
  ///
  /// utils.solidityKeccak256([ "int16", "uint48" ], [ -1, 12 ])
  /// // '0x81da7abb5c9c7515f57dab2fc946f01217ab52f3bd8958bc36bd55894451a93c'
  external static String solidityKeccak256(
      List<String> types, List<dynamic> values);

  /// Returns the non-standard encoded [values] packed according to their respective type in [types].
  ///
  /// ---
  ///
  /// utils.solidityPack([ "int16", "uint48" ], [ -1, 12 ])
  /// // '0xffff00000000000c'
  ///
  /// utils.solidityPack([ "string", "uint8" ], [ "Hello", 3 ])
  /// // '0x48656c6c6f03'
  external static String solidityPack(List<String> types, List<dynamic> values);

  /// Returns the `SHA2-256` of the non-standard encoded [values] packed according to their respective type in [types].
  ///
  /// ---
  ///
  /// utils.soliditySha256([ "int16", "uint48" ], [ -1, 12 ])
  /// // '0xa5580fb602f6e2ba9c588011dc4e6c2335e0f5d970dc45869db8f217efc6911a'
  external static String soliditySha256(
      List<String> types, List<dynamic> values);

  external static String verifyMessage(String hash, String sig);
}

/// Format types of Interface
@JS('utils.FormatTypes')
class FormatTypes {
  /// [{"type":"function","name":"balanceOf","constant":true,"stateMutability":"view","payable":false,"inputs":[{"type":"address"}],"outputs":[{"type":"uint256"}]}]
  external static dynamic json;

  /// [
  /// 'function balanceOf(address owner) view returns (uint256)',
  /// ]
  external static dynamic full;

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

/// A Signer in ethers is an abstraction of an Ethereum Account, which can be used to sign messages and transactions and send signed transactions to the Ethereum Network to execute state changing operations.
///
/// The available operations depend largely on the sub-class used.
///
/// For example, a Signer from MetaMask can send transactions and sign messages but cannot sign a transaction (without broadcasting it).
@JS("signer.Signer")
class Signer {
  /// Returns `true` if an only if object is a [Signer].
  external static bool isSigner(Object object);
}

/// The Web3Provider is meant to ease moving from a web3.js based application to ethers by wrapping an existing Web3-compatible (such as a Web3HttpProvider, Web3IpcProvider or Web3WsProvider) and exposing it as an ethers.js Provider which can then be used with the rest of the library.
///
/// This may also be used to wrap a standard [EIP-1193 Provider](link-eip-1193].
@JS("providers.Web3Provider")
class Web3Provider extends Provider {
  external Web3Provider(EthereumBase eth);

  /// Connect this to create new [Signer] object.
  external Signer getSigner();
}
