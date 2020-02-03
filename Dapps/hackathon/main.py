from models import FundSeeker,Funder
import json
from web3 import HTTPProvider,Web3

ganache_link='HTTP://127.0.0.1:7545'
web3=Web3(HTTPProvider(ganache_link))
web3.enable_strict_bytes_type_checking()
def readContractInfo():
    with open('compiled_data.json','r') as f:
        p=json.load(f)   
    return p
def createContract(jsonFile,contract_name,account,consArg=[]):
    abi=jsonFile[contract_name]['abi']
    bytecode='0x'+jsonFile[contract_name]['bin']
    print('creating contract')
    contract_r=web3.eth.contract(abi=abi,bytecode=bytecode)
    if len(consArg)==0:
        tx_hash = contract_r.constructor().transact({'from':account})
    else:
        tx_hash = contract_r.constructor(consArg).transact({'from':account})

    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
        
    print(tx_receipt.contractAddress)
    contract = web3.eth.contract(
        address=tx_receipt.contractAddress,
        abi=abi,
            )
    return contract