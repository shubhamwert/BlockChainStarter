pragma solidity ^0.4.21;

contract Funders{
    struct Person{
    uint8 id;
    string userName;
    address account;
    bool hasVoted;
    
    }
    uint minVotesReq=2;
    enum Stage{ Init, Vote, Done}
        Stage public stage=Stage.Init;
    
    enum voteDetail{ Against, Favour}
        voteDetail private votD=voteDetail.Against;
    struct FundSeeker{
        uint id;
        address payable account;
        uint balance;
        Stage nstage;
        uint voteCount;
    }
    
    
    mapping (address =>FundSeeker) fundWanter;
    uint countFunder=0;
    event FundsSended(address to,address from, uint value);
    // Person[] public funderList;
    mapping (address => Person) funderList;
    // mapping (address => Person) public funderListAdd;
    address head;
    
    uint8 count=0;

    modifier isOwner(){
        require(msg.sender == head,"you are not owner");
        _;
    }
    modifier isRegisterd(){
        require(funderList[msg.sender].account == msg.sender,"you need to register first");
        _;
    }
    
    
    modifier isReqStage(address mid,Stage st){
        require(fundWanter[mid].nstage == st,"not in the required state");
        _;
        
    }
    
    modifier hasalreadyVoted(){
        require(!funderList[msg.sender].hasVoted,"you have already voted");
        _;
    }
    
    // modifier hasSufficentBalance(){
    //     require(address(this).balance>=msg.value,"insufficent balance");
    //     _;
    // }
    
    
    constructor() public payable{
        head=msg.sender;
        }
    

    receive () external payable{ }
    function register(string memory name) public {
        // funderList.push(Person(count,name,msg.sender,false));
        funderList[msg.sender].id=count;
        funderList[msg.sender].userName=name;
        funderList[msg.sender].account=msg.sender;
        funderList[msg.sender].hasVoted=false;
        
        count=count+1;
        
        }
    
    function registerFundi(address payable add) public isRegisterd payable{
        // fundWanter.push(FundSeeker(countFunder,add,0,Stage.Init,0));
        fundWanter[add].id=countFunder;
        fundWanter[add].account=add;
        fundWanter[add].balance=0;
        fundWanter[add].nstage=Stage.Init;
        fundWanter[add].voteCount=0;
        countFunder=countFunder+1;
    }    
    function sendFunds(address add) public payable isRegisterd{
        
        fundWanter[add].account.transfer(msg.value);
        fundWanter[add].balance = fundWanter[add].balance+msg.value;
        emit FundsSended(fundWanter[add].account,msg.sender,msg.value);
        
        
    }
    
    function initiateWithdrawal(address add) public isReqStage(add,Stage.Init) {
        fundWanter[add].nstage=Stage.Vote;
        
    }
    
    function endWithdrawal(address add) public isReqStage(add,Stage.Vote){
        fundWanter[add].nstage=Stage.Done;
    }
    
    function vote(address fundeeAddress,voteDetail v) public isReqStage(fundeeAddress,Stage.Vote) isRegisterd hasalreadyVoted{
        if(v==voteDetail.Favour){
            fundWanter[fundeeAddress].voteCount+=1;
            
        }
        funderList[msg.sender].hasVoted=true;
        // funderList[funder_id].hasVoted=true;
        
    }
    function isAllowedToWithdraw(address id) public isReqStage(id,Stage.Done) payable returns(bool){
        uint totalVotes=fundWanter[id].voteCount;
        if(totalVotes>=minVotesReq){
            return true;
        }
        return false;
    }
}


contract Fundi{
    
    struct Person{
    uint8 id;
    string userName;
    address account;
    uint collected_money;
    } 
    bool canTakeMoney=true;
    Person public FundSeeker;
    event Receive(uint value);
    Funders contract_funder;
    constructor(string memory name) public payable{
        FundSeeker.id=0;
        FundSeeker.userName=name;
        FundSeeker.account=msg.sender;
        FundSeeker.collected_money=0;
        
    }
    modifier onlyAuth(){
        require(msg.sender == FundSeeker.account,"please use owner account");
        _;
    }
    modifier canWithdraw(){
        require(canTakeMoney,"you dont have sufficentBalance");
        _;
    }
    function getCollectedMoney() public onlyAuth payable returns(uint){
        emit Receive(msg.value);
        FundSeeker.collected_money=address(this).balance;
        return FundSeeker.collected_money;
        
        
    }
    
    function getAccOwner() public view returns(address){
        return FundSeeker.account;
    }
    
    
    function setFundPoolAddress(address payable contract_id) public onlyAuth payable{
        contract_funder=Funders(contract_id);
        // canTakeMoney=contract_funder.isAllowedToWithdraw();
        
        
    }
    function initiateWithdrawal_Fundi() public onlyAuth payable{
        contract_funder.initiateWithdrawal(msg.sender);
    }
    
    function tranfer_to_self(address payable self_acc) public onlyAuth canWithdraw payable{
        
        self_acc.transfer(address(this).balance);
        FundSeeker.collected_money=0;
        
    }
    
    receive () external payable{ }
    
}




