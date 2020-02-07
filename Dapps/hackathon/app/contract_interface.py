from app.models import FundSeeker,Funder
import json
from web3 import HTTPProvider,Web3
#links for connections
ganache_link='HTTP://127.0.0.1:7545'
web3=Web3(HTTPProvider(ganache_link))
# remove below comment to enable strict checking
# web3.enable_strict_bytes_type_checking()


#Create basic models of Funder and Fund Seeker
def CreateFunder(name:str,acc):
    return Funder.Funder(name,acc)
def CreateFundSeeker(name:str,acc):
    return FundSeeker.FundSeeker(name,acc)



#read compiled json file for abi and byte code
def readContractInfo(filename):
    with open(filename,'r') as f:
        p=json.load(f)   
    return p



#Functions to intract with smart contracts

#function to create new Contracts by passing json ,name of contract as in json , address of creator,
# and optional consArg containg arguments for constructor
def createContract(jsonFile,contract_name,account,consArg=[]):
    abi=jsonFile[contract_name]['abi']
    bytecode='0x'+jsonFile[contract_name]['bin']
    print('creating contract')
    contract_r=web3.eth.contract(abi=abi,bytecode=bytecode)
    if len(consArg)==0:
        tx_hash = contract_r.constructor().transact({'from':account})
    else:
        print(consArg)
        tx_hash = contract_r.constructor(consArg).transact({'from':account})

    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
        
    print(tx_receipt.contractAddress)
    contract = web3.eth.contract(
        address=tx_receipt.contractAddress,
        abi=abi,
            )
    return contract

#Register The Funders using this function
#passing contract and funder
def registerFunder(contract,funder:Funder.Funder):
    if not web3.isAddress(contract.address) or not web3.isConnected():
        print("error no contract address specified")
        return
    name=funder.getName()
    tx_hash=contract.functions.register(name).transact({'from':funder.getAcc(),'to':contract.address,'gas':100000})
    tx_receipt=web3.eth.waitForTransactionReceipt(tx_hash)
    print('register new Funder')

    return [tx_receipt,tx_hash]

#get account number of Fund Seeker by passing contract.
#basically returns the owner of contract Fundi
def getFundSeeker(contract,fundSeeker:FundSeeker.FundSeeker):
    return contract.functions.FundSeeker().call


#Register The Fund Seeker using this function
#passing contract and fund Seeker
#this donot create a seprate contract but register fund seeker in contract's address as fundWanter
#need transfer monety
def registerFundSeeker(contract,funder:Funder.Funder,fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    tx_hash=contract.functions.registerFundi(fund_seeker.getAcc()).transact({'from':funder.getAcc(),'to':contract.address,'gas':100000})
    tx_receipt=web3.eth.waitForTransactionReceipt(tx_hash)
    print('register new fundSeeker')
    return [tx_receipt,tx_hash]

#returns availabe functions for a contract
def getAllFunctionList(contract_name):
    return contract_name.all_functions()

#send money to FundSeeker from funder account.
#both should be registered
def sendMoneyToFundSeeker(contract,from_funder:Funder.Funder,to_fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    tx_hash=contract.functions.sendFunds(to_fund_seeker.getAcc()).transact({'from':from_funder.getAcc(),'to':contract.address,'gas':100000})
    tx_receipt=web3.eth.waitForTransactionReceipt(tx_hash)
    print('Money Send to Fund_Seeker')
    return [tx_receipt,tx_hash]

#TODO:check function error. opcode not found
#repair code in contract
def getCollectedMoney(contract,fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    tx_hash=contract.functions.getCollectedMoney().transact({'from':fund_seeker.getAcc(),'to':contract.address})
    print('Collected Money {}'.format(tx_hash))
    return tx_hash

#starts withdrawal process or voting process
def startVotingFor(contract,initator_address,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.initateWithdrawal(fund_seeker.getAcc()).transact({'from':initator_address})

#ends voting process
def endVotingFor(contract,stoper_address,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.endWithdrawal(fund_seeker.getAcc()).transact({'from':initator_address})

#vote for a particular fund Seeker. vote can be FAVOUR or AGAINST
def voteFor(contract,for_fund_seeker,voter:Funder.Funder,vote:str):
    votes={'FAVOUR':1,'AGAINST':0}  
    try:
        tx=contract.functions.vote(for_fund_seeker.getAcc(),votes[vote.capitalize()]).transact({'from':voter.getAcc()})
    except e:
        print("error says\n")
        prit(e)

#when voting is done count the votes and compare with threshold (2).return true of votes greater than 2
def isAllowedToWithDraw(contract,quering,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.isAllowedToWithDraw(fund_seeker.getAcc()).call({'from':quering.getAcc()})
    print(tx)
    return tx

#returns current funding stage for fund seeker
def getCurrentFundingStageFor(contract,quering,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.getStage(fund_seeker.getAcc()).call({'from':quering.getAcc()})
    print(tx)
    Stages={0:"Init",1:"Vote",2:"Done"}
    return tx