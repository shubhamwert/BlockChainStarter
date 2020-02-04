from models import FundSeeker,Funder
import json
from web3 import HTTPProvider,Web3

ganache_link='HTTP://127.0.0.1:7545'
web3=Web3(HTTPProvider(ganache_link))
web3.enable_strict_bytes_type_checking()


def CreateFunder(name:str,acc):
    return Funder.Funder(name,acc)
def CreateFundSeeker(name:str,acc):
    return FundSeeker.FundSeeker(name,acc)

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
        print(consArg)
        tx_hash = contract_r.constructor(consArg).transact({'from':account})

    tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
        
    print(tx_receipt.contractAddress)
    contract = web3.eth.contract(
        address=tx_receipt.contractAddress,
        abi=abi,
            )
    return contract

def registerFunder(contract,funder:Funder.Funder):
    if not web3.isAddress(contract.address) or not web3.isConnected():
        print("error no contract address specified")
        return
    name=funder.getName()
    tx_hash=contract.functions.register(name).transact({'from':funder.getAcc(),'to':contract.address,'gas':100000})
    tx_receipt=web3.eth.waitForTransactionReceipt(tx_hash)
    print('register new Funder')

    return [tx_receipt,tx_hash]


def getFundSeeker(contract,fundSeeker:FundSeeker.FundSeeker):
    return contract.functions.FundSeeker().call

def registerFundSeeker(contract,funder:Funder.Funder,fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    tx_hash=contract.functions.registerFundi(fund_seeker.getAcc()).transact({'from':funder.getAcc(),'to':contract.address,'gas':100000})
    tx_receipt=web3.eth.waitForTransactionReceipt(tx_hash)
    print('register new fundSeeker')
    return [tx_receipt,tx_hash]


def getAllFunctionList(contract_name):
    return contract_name.all_functions()
def sendMoneyToFundSeeker(contract,from_funder:Funder.Funder,to_fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    tx_hash=contract.functions.sendFunds(to_fund_seeker.getAcc()).transact({'from':from_funder.getAcc(),'to':contract.address,'gas':100000})
    tx_receipt=web3.eth.waitForTransactionReceipt(tx_hash)
    print('Money Send to Fund_Seeker')
    return [tx_receipt,tx_hash]

#TODO:check function error. opcode not found
def getCollectedMoney(contract,fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    tx_hash=contract.functions.getCollectedMoney().transact({'from':fund_seeker.getAcc(),'to':contract.address})
    print('Collected Money {}'.format(tx_hash))
    return tx_hash


def getCurrentFundingStageFor(contract,fund_seeker:FundSeeker.FundSeeker):
    if not web3.isConnected():
        print('Not connected to blockchain')
        return
    

    return [tx_receipt,tx_hash]    

def startVotingFor(contract,initator_address,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.initateWithdrawal(fund_seeker.getAcc()).transact({'from':initator_address})


def endVotingFor(contract,stoper_address,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.endWithdrawal(fund_seeker.getAcc()).transact({'from':initator_address})

def voteFor(contract,for_fund_seeker,voter:Funder.Funder,vote:str):
    votes={'FAVOUR':1,'AGAINST':0}
    try:
        tx=contract.functions.vote(for_fund_seeker.getAcc(),votes[vote.capitalize()]).transact({'from':voter.getAcc()})
    except e:
        print("error says\n")
        prit(e)
def isAllowedToWithDraw(contract,quering,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.isAllowedToWithDraw(fund_seeker.getAcc()).call({'from':quering.getAcc()})
    print(tx)
    return tx
def getCurrentFundingStageFor(contract,quering,fund_seeker:FundSeeker.FundSeeker):
    tx=contract.functions.getStage(fund_seeker.getAcc()).call({'from':quering.getAcc()})
    print(tx)
    Stages={0:"Init",1:"Vote",2:"Done"}
    return tx