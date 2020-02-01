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
    
    
    
    FundSeeker[] fund_seekers;
    uint countFunder=0;
    event FundsSended(address to,address from, uint value);
    Person[] public funderList;
    mapping (address => Person) public funderListAdd;
    address head;
    
    uint8 count=0;

    modifier isOwner(){
        require(msg.sender == head,"you are not owner");
        _;
    }
    
    modifier isReqStage(uint mid,Stage st){
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
        funderList.push(Person(count,name,msg.sender,false));
        count=count+1;
        
        }
    
    function registerFundi(address payable add) public payable{
        fund_seekers.push(FundSeeker(countFunder,add,0,Stage.Init,0));
        countFunder=countFunder+1;
    }    
    function sendFunds(uint fundi_id) public payable{
        
        fund_seekers[fundi_id].account.transfer(msg.value);
        fund_seekers[fundi_id].balance = fund_seekers[fundi_id].balance+msg.value;
        emit FundsSended(fund_seekers[fundi_id].account,msg.sender,msg.value);
        
        
    }
    
    function initiateWithdrawal(uint id) public isReqStage(id,Stage.Init){
        fund_seekers[id].nstage=Stage.Vote;
        
    }
    
    function endWithdrawal(uint id) public isReqStage(id,Stage.Vote){
        fund_seekers[id].nstage=Stage.Done;
    }
    
    function vote(uint fundee_id,uint funder_id,voteDetail v) public isReqStage(fundee_id,Stage.Vote){
        if(v==voteDetail.Favour){
            fund_seekers[fundee_id].voteCount+=1;
            
        }
        funderList[funder_id].hasVoted=true;
        
    }
    function isAllowedToWithdraw(uint id) public isReqStage(id,Stage.Done) payable returns(bool){
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




