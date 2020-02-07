#Model Class for Fund_Seeker

class FundSeeker:
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
        self.bal=self.bal+amt
        
    def addContractAddress(string):
        self.FunderContract=string
    def setContractAcc(self,Acc):
        self._account=Acc
    def __repr__(self):
        return self._name