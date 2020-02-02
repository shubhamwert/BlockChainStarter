import json
from web3 import Web3,HTTPProvider
weblink="http://127.0.0.1:7545"
w3=Web3(Web3.HTTPProvider(weblink))
with open("data.json", 'r') as f:
     datastore = json.load(f)
     abi = datastore["abi"]
     contract_address = datastore["contract_address"]
print(w3.isConnected())
w3.eth.defaultAccount = w3.eth.accounts[1]
user = w3.eth.contract(address=contract_address, abi=abi)
user.functions.register('hello').transact()