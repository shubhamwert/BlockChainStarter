import json
from web3 import HTTPProvider,Web3

ganache_link='HTTP://127.0.0.1:7545'
web3=Web3(HTTPProvider(ganache_link))
web3.enable_strict_bytes_type_checking()
def CreateContract(name,account):
    if(web3.isConnected()):
        try:
            with open('compiled_data.json','r') as f:
                m=json.load(f)
        except e:
            print('unable to load data')
            exit()
        print("json loaded...")
        abi=m["contracts/Transfer.sol:User"]['abi']
        bytecode='0x'+m["contracts/Transfer.sol:User"]['bin']
        # abi = json.loads('[{"inputs":[{"internalType":"string","name":"username","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"","type":"address"},{"indexed":false,"internalType":"uint256","name":"","type":"uint256"}],"name":"Received","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"moneyTransfered","type":"event"},{"constant":true,"inputs":[],"name":"checkBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address payable","name":"add","type":"address"}],"name":"transferMoney","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"transferSelf","outputs":[],"payable":true,"stateMutability":"payable","type":"function"}]')
        # bytecode='608060405234801561001057600080fd5b5060405161062c38038061062c8339818101604052602081101561003357600080fd5b810190808051604051939291908464010000000082111561005357600080fd5b8382019150602082018581111561006957600080fd5b825186600182028301116401000000008211171561008657600080fd5b8083526020830192505050908051906020019080838360005b838110156100ba57808201518184015260208101905061009f565b50505050905090810190601f1680156100e75780820380516001836020036101000a031916815260200191505b506040525050508060018001908051906020019061010692919061014d565b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550506101f2565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061018e57805160ff19168380011785556101bc565b828001600101855582156101bc579182015b828111156101bb5782518255916020019190600101906101a0565b5b5090506101c991906101cd565b5090565b6101ef91905b808211156101eb5760008160009055506001016101d3565b5090565b90565b61042b806102016000396000f3fe6080604052600436106100345760003560e01c80630e0d418e1461003957806386ce983514610043578063c71daccb14610087575b600080fd5b6100416100b2565b005b6100856004803603602081101561005957600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919050505061023f565b005b34801561009357600080fd5b5061009c6103cd565b6040518082815260200191505060405180910390f35b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614610157576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260218152602001806103d66021913960400191505060405180910390fd5b3373ffffffffffffffffffffffffffffffffffffffff166108fc479081150290604051600060405180830381858888f1935050505015801561019d573d6000803e3d6000fd5b507ff6de27ae64e182b95cbeb66b66be03a4d6cba6f50e80a45cdf02cbfe3eff657b333047604051808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001828152602001935050505060405180910390a1565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146102e4576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260218152602001806103d66021913960400191505060405180910390fd5b8073ffffffffffffffffffffffffffffffffffffffff166108fc349081150290604051600060405180830381858888f1935050505015801561032a573d6000803e3d6000fd5b507ff6de27ae64e182b95cbeb66b66be03a4d6cba6f50e80a45cdf02cbfe3eff657b813334604051808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001828152602001935050505060405180910390a150565b60004790509056fe796f7520617265206e6f74206f776e6572206f662074686973206163636f756e74a265627a7a72315820dcf030815f144644886392961486ecf02966b1b418e169711ade17b200a62e4664736f6c63430005100032'
        print('creating contract')
        contract_r=web3.eth.contract(abi=abi,bytecode=bytecode)
        tx_hash = contract_r.constructor(name).transact({'from':account})
        tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
        
        print(tx_receipt.contractAddress)
        contract = web3.eth.contract(
            address=tx_receipt.contractAddress,
            abi=abi,
            )
        a=contract.functions.checkBalance().call()
        print(a)
        return contract
    else:
        print("No Network \n check your blockchain connectivity")    



if __name__ == "__main__":
    name=['user1','user2']
    contract1=CreateContract(name[0],web3.eth.accounts[0])
    contract2=CreateContract(name[1],web3.eth.accounts[1])

    tx_hash=contract1.functions.transferMoney(contract2.address).transact({'from':web3.eth.accounts[1],'to':contract2.address,'gas':1000000,'value':200})
    



    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
    
    print(tx_receipt)


