part of ethers;

/// To deploy a [Contract], additional information is needed that is not available on a Contract object itself.
///
/// Mainly, the bytecode (more specifically the initcode) of a contract is required.
///
/// The Contract Factory sends a special type of transaction, an initcode transaction (i.e. the to field is null, and the data field is the initcode) where the initcode will be evaluated and the result becomes the new code to be deployed as a new contract.

class ContractFactory extends Interop<_ContractFactoryImpl> {
  /// Creates a new instance of a [ContractFactory] for the contract described by the interface and bytecode initcode.
  factory ContractFactory(
      dynamic interface, String bytecode, dynamic providerOrSigner) {
    assert(
      providerOrSigner is Web3Provider ||
          providerOrSigner is JsonRpcProvider ||
          providerOrSigner is Provider ||
          providerOrSigner is Signer,
      'providerOrSigner must be Provider or Signer',
    );
    assert(
      interface is String ||
          interface is List<String> ||
          interface is Interface,
      'abi must be valid type',
    );

    return ContractFactory._(_ContractFactoryImpl(
        interface is Interface ? interface.impl : interface,
        bytecode,
        (providerOrSigner as Interop).impl));
  }

  /// Instantiate [Contract] from [provider] for read-only contract calls.
  factory ContractFactory.fromProvider(
          dynamic abi, String bytecode, Provider provider) =>
      ContractFactory._(_ContractFactoryImpl(abi, bytecode, provider.impl));

  /// Instantiate [Contract] from [provider] for read-write contract calls.
  factory ContractFactory.fromSigner(
          dynamic abi, String bytecode, Signer signer) =>
      ContractFactory._(_ContractFactoryImpl(abi, bytecode, signer.impl));

  const ContractFactory._(_ContractFactoryImpl impl) : super.internal(impl);

  /// The [Contract] interface.
  Interface get interface => impl.interface;

  /// The bytecode (i.e. initcode) that this [ContractFactory] will use to deploy the Contract.
  String get bytecode => impl.bytecode;

  /// The [Signer] (if any) this ContractFactory will use to deploy instances of the Contract to the Blockchain
  Signer? get signer => impl.signer != null ? Signer._(impl.signer!) : null;

  /// Returns a new instance of the [ContractFactory] with the same interface and bytecode, but with a different signer.
  ContractFactory connect(dynamic providerOrSigner) {
    assert(
      providerOrSigner is Web3Provider ||
          providerOrSigner is JsonRpcProvider ||
          providerOrSigner is Provider ||
          providerOrSigner is Signer,
      'providerOrSigner must be Provider or Signer',
    );

    return ContractFactory._(impl.connect((providerOrSigner as Interop).impl));
  }

  /// Return an instance of a [Contract] attached to address. This is the same as using the Contract constructor with address and this the interface and signerOrProvider passed in when creating the [ContractFactory].
  Contract attach(String address) =>
      Contract._(_ContractImpl(address, interface, signer));

  /// Returns the unsigned transaction which would deploy this Contract with args passed to the Contract's constructor.
  ///
  /// If the optional overrides is specified, they can be used to override the endowment value, transaction nonce, gasLimit or gasPrice.
  UnsignedTransaction getDeployTransaction(dynamic args,
          [TransactionOverride? override]) =>
      UnsignedTransaction._(impl.getDeployTransaction(args));

  /// Uses the signer to deploy the Contract with args passed into the constructor and returns a Contract which is attached to the address where this contract will be deployed once the transaction is mined.
  ///
  /// The transaction can be found at contract.deployTransaction, and no interactions should be made until the transaction is mined.
  ///
  /// If the optional overrides is specified, they can be used to override the endowment value, transaction nonce, gasLimit or gasPrice.
  Future<Contract> deploy(dynamic args,
          [TransactionOverride? override]) async =>
      Contract._(await promiseToFuture<_ContractImpl>(impl.deploy(args)));
}
