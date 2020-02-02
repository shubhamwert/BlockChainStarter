import json
from web3 import Web3
wen_link="http://127.0.0.1:8545"

web3 = Web3(Web3.HTTPProvider(wen_link))

print(web3.isConnected())
print(web3.eth.blockNumber)
account = "0xfB3Fd7CC57F22a92a69ecb3CA552447e05b930cF"
balance = web3.eth.getBalance(account)
print(web3.fromWei(balance, "ether"))
web3.eth.defaultAccount=web3.eth.accounts[0]
abi=json.loads('[{"constant":true,"inputs":[],"name":"hello","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"yourName","type":"string"}],"name":"set","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"inputs":[],"type":"constructor","payable":true,"stateMutability":"payable"}]')
web3.eth.defaultAccount = web3.eth.accounts[0]
address="0x167Db62A13143e2eF3346efBbDeEC5327B83ec3B"
address = web3.toChecksumAddress(address)

private_key = '0xdf96bf816ca845b3e1802a116e863fed8bead8f1178546f741641ad2c40d3283'
contract = web3.eth.contract(address=address, abi=abi)
m=contract.functions.set("insein").transact()

web3.eth.waitForTransactionReceipt(m)
print(contract.functions.hello().call())

