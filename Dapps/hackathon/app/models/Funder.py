#Model Class for Funder
class Funder:
    def __init__(self,name:str,account):
        self._name=name
        self._account=account

    def getName(self):
        return self._name

    
    def getAcc(self):
        return self._account
    
    def setAccbalance(bal):
        self.bal=bal

    def addMoney(amt):
        self.bal=amt

    def addContractAddress(string):
        self.FunderContract=string
    def __repr__(self):
        return '<Funder Object with name : {}'.format(self.name)