import 'dart:convert';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_web3_provider/ethereum.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedAddress;

  Future<void> init() async {
    var accounts = await promiseToFuture(
        ethereum.request(RequestParams(method: 'eth_requestAccounts')));
    print(accounts);
    String se = ethereum.selectedAddress;
    print("selectedAddress: $se");
    setState(() {
      selectedAddress = se;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  var nonce = 0;
  var spender = "0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B";

  var _eip712DomainType = [
    {
      "name": "name",
      "type": "string",
    },
    {
      "name": "version",
      "type": "string",
    },
    {
      "name": "chainId",
      "type": "uint256",
    },
    {
      "name": "verifyingContract",
      "type": "address",
    },
  ];

  var _permitType = [
    {
      "name": "holder",
      "type": "address",
    },
    {
      "name": "spender",
      "type": "address",
    },
    {
      "name": "nonce",
      "type": "uint256",
    },
    {
      "name": "allowance",
      "type": "uint256",
    },
  ];

  var _eip712Domain = {
    "name": "Dai Stablecoin",
    "version": "1",
    "chainId": 42,
    "verifyingContract": "0xaE036c65C649172b43ef7156b009c6221B596B8b",
  };

  Future<void> makeSigningRequest() async {
    var message = {
      "holder": selectedAddress,
      "spender": spender,
      "nonce": nonce,
      "allowance": 20,
    };
    var typedData = jsonEncode({
      "types": {
        "EIP712Domain": _eip712DomainType,
        "Permit": _permitType,
      },
      "primaryType": "Permit",
      "domain": _eip712Domain,
      "message": message,
    });

    print(typedData);

    String signature = await promiseToFuture(ethereum.request(RequestParams(
        method: 'eth_signTypedData_v3', params: [selectedAddress, typedData])));
    print(signature);
    String r = signature.substring(0, 66);
    String s = "0x" + signature.substring(66, 130);
    String vHexa = "0x" + signature.substring(130, 132);
    String v = int.parse(vHexa).toString();

    print(r);
    print(s);
    print(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: makeSigningRequest, child: Text("Sign Message"))),
    );
  }
}



// contract EIP712Verify{
        
//     uint chainId_ = 42;
//     bytes32 public DOMAIN_SEPARATOR =   keccak256(abi.encode(
//                                         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
//                                         keccak256(bytes(name)),
//                                         keccak256(bytes(version)),
//                                         chainId_,
//                                         address(this)
//                                     ));
                                    
                                        
//     //HERE                                   
//     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 allowance)");
//     // bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
//     mapping (address => uint) public nonces;

        
//     string  public constant name     = "Dai Stablecoin";
//     string  public constant version  = "1";
//     uint256 public totalSupply;
//     //HERE
//     // --- Approve by signature ---
//     function permit(address holder, address spender, uint256 nonce, uint allowance,
//                      uint8 v, bytes32 r, bytes32 s) public view returns (address)
//     {
//         bytes32 digest =
//             keccak256(abi.encodePacked(
//                 "\x19\x01",
//                 DOMAIN_SEPARATOR,
//                 keccak256(abi.encode(PERMIT_TYPEHASH,
//                                      holder,
//                                      spender,
//                                      nonce, 
//                                      allowance
//                                      ))
//         ));

//         require(holder != address(0), "Dai/invalid-address-0");
//         require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
//         require(nonce == nonces[holder], "Dai/invalid-nonce");
//         return ecrecover(digest, v, r, s);
//     }
// }