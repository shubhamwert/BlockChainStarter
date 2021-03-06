pragma solidity ^0.6.1;

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
        voteDetail public votD=voteDetail.Against;
    struct FundSeeker{
        uint id;
        address payable account;
        uint balance;
        Stage nstage;
        uint voteCount;
    }
    
    
    mapping (address =>FundSeeker) fund_seekers;
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
        require(funderList[msg.sender].account == msg.sender);
        _;
    }
    
    
    modifier isReqStage(address mid,Stage st){
        require(fund_seekers[mid].nstage == st,"not the required state");
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
        // fund_seekers.push(FundSeeker(countFunder,add,0,Stage.Init,0));
        fund_seekers[add].id=countFunder;
        fund_seekers[add].account=add;
        fund_seekers[add].balance=0;
        fund_seekers[add].nstage=Stage.Init;
        fund_seekers[add].voteCount=0;
        countFunder=countFunder+1;
    }    
    function sendFunds(address add) public payable isRegisterd{
        
        fund_seekers[add].account.transfer(msg.value);
        fund_seekers[add].balance = fund_seekers[add].balance+msg.value;
        emit FundsSended(fund_seekers[add].account,msg.sender,msg.value);
        
        
    }
    
    function initiateWithdrawal(address add) public isReqStage(add,Stage.Init) isRegisterd{
        fund_seekers[add].nstage=Stage.Vote;
        
    }
    
    function endWithdrawal(address add) public isReqStage(add,Stage.Vote){
        fund_seekers[add].nstage=Stage.Done;
    }
    
    function vote(address fundee_id,voteDetail v) public isReqStage(fundee_id,Stage.Vote) isRegisterd{
        if(v==voteDetail.Favour){
            fund_seekers[fundee_id].voteCount+=1;
            
        }
        funderList[msg.sender].hasVoted=true;
        // funderList[funder_id].hasVoted=true;
        
    }
    function isAllowedToWithdraw(address id) public isReqStage(id,Stage.Done) payable returns(bool){
        uint totalVotes=fund_seekers[id].voteCount;
        if(totalVotes>minVotesReq){
            return true;
        }
        
    }
}


contract Fundi{
    
    struct Person{
    uint8 id;
    string userName;
    address account;
    uint collected_money;
    } 
    bool canTakeMoney=false;
    Person public Fund_seeker;
    event Receive(uint value);
    Funders contract_funder;
    constructor(string memory name) public payable{
        Fund_seeker.id=0;
        Fund_seeker.userName=name;
        Fund_seeker.account=msg.sender;
        Fund_seeker.collected_money=0;
        
    }
    modifier onlyAuth(){
        require(msg.sender == Fund_seeker.account);
        _;
    }
    function getCollectedMoney() public onlyAuth payable returns(uint){
        emit Receive(msg.value);
        Fund_seeker.collected_money=address(this).balance;
        return Fund_seeker.collected_money;
        
        
    }
    
    function getAccOwner() public view returns(address){
        return Fund_seeker.account;
    }
    
    
    function setFundPoolAddress(address payable contract_id) public onlyAuth payable{
        contract_funder=Funders(contract_id);
        // canTakeMoney=contract_funder.isAllowedToWithdraw();
        
        
    }
    
    receive () external payable{ }
    
}




