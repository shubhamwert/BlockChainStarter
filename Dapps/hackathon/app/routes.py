from app import app
from app import contract_interface as ci
from flask import request
import json
web3=ci.web3

FunderContract=ci.readContractInfo(r'app\compiled\contracts\funder.json')
FundSeekerContract=ci.readContractInfo(r'app\compiled\contracts\fundi.json')

#test samples
owner=''
Funder=''
fundSeeker=''
contract_Funder=''
contract_FundSeeker=''



@app.route('/checkconnectivity',methods=['GET'])
def connectivity():
    return str(web3.isConnected())

@app.route('/openFundBucket',methods=['POST'])
def CreateNewBucket():
    try:
        name=request.json['name']
        account=request.json['account']
        owner=ci.CreateFunder(name,acc=account)
        contract_Funder=ci.createContract(FunderContract,'Funders',owner.getAcc())
        return json.dumps({'response':True})
    except :
        return json.dumps({'response':False})
        

@app.route('/registerAsFundSeeker',methods=['POST'])
def CreateNewFundSeeker():
    try:
        name=request.json['name']
        account=request.json['account']
        FundSeeker=ci.CreateFundSeeker(name,acc=account)
        contract_FundSeeker=ci.createContract(FundSeekerContract,'Fundi',FundSeeker.getAcc(),FundSeeker.getName())
        FundSeeker.setContractAcc(contract_FundSeeker)
        return json.dumps({'response':True})
    except :
        
        return json.dumps({'response':False})

@app.route('/registerFunder')
def CreateFunderForBucket():
        name=request.json['name']
        account=request.json['account']
        Funder=ci.CreateFunder(name,acc=account)
        user=ci.registerFunder(FunderContract,Funder)
        return json.dumps({'response':True})

@app.route('/registerFundSeeker')
def registerFundSeeker():
    

    tx=ci.registerFundSeeker(FunderContract,funder=Funder,fund_seeker=fundSeeker)
    return json.dumps({'response':True,'description':str(tx)})

@app.route('/getFundSeeker')
def getFundSeeker():

    tx=ci.getFundSeeker(FundSeekerContract,fundSeeker)
    return json.dumps({'response':True,'description':str(tx)})
@app.route('/sendMoneyToFundSeeker')
def sendMoneyToFundSeeker():
    [tx,val]=ci.sendMoneyToFundSeeker(FunderContract,Funder,fundSeeker)
    return json.dumps({'response':True,'tx':str(tx),'val':val})

@app.route('/startVotingFor')
def startVotingFor():
    ci.startVotingFor(FunderContract,Funder.getAcc(),fundSeeker.getAcc())
    return json.dumps({'response':True})

@app.route('/endVotingFor')
def endVotingFor():
    ci.endVotingFor(FunderContract,Funder.getAcc(),fundSeeker.getAcc())
    return json.dumps({'response':True})

@app.route('/voteFor')
def vote():
    vote=request.json['vote']
    ci.voteFor(FunderContract,fundSeeker,Funder,vote)


@app.route('/isAllowedToWithDraw')
def isAllowedToWithDraw():
    p=ci.isAllowedToWithDraw(FundSeekerContract,fundSeeker,fundSeeker)
    return{'response':True,'body':str(p)}

@app.route('/getCurrentFundingStageFor')
def getCurrentFundingStageFor():
    p=ci.getCurrentFundingStageFor(FunderContract,Funder,fundSeeker)
    return p