pragma solidity 0.5.15;



contract Campaign{
    
    struct FundSeeker{
        address add;
        uint balanceCollected;
        
        
    }
    
    struct Funder{
        address add;
        bool hasVoted;
    }
    uint public countVote=0;
    
    address public owner;
    FundSeeker public fundseeker;
    enum Stage{ Init, Vote, Done}
        Stage public stage=Stage.Init;
    
    enum voteDetail{ Against, Favour}
        voteDetail private votD=voteDetail.Against;
    
    mapping (address => Funder) funderList;
    
    
    event MoneyTransferred(address to,address by,uint value);
    event votingDone(voteDetail v,address by);
    
    
    function() external payable {}

    modifier isRegisterd(){
        require(funderList[msg.sender].add == msg.sender,"you need to register first");
        _;
    }
    modifier isOwner(){
        require(msg.sender==owner,"You Need to be owner of this account");
        _;
    }
    
    modifier isReqStage(Stage st){
        require(stage==st,"check the stage of voting");
        _;
    }
    modifier hasalreadyVoted(){
        require(!funderList[msg.sender].hasVoted,"you have already voted");
        _;
    }
    
    modifier isFunder(){
        require(funderList[msg.sender].add==msg.sender);
        _;
    }
    
    constructor() public payable{
        owner=msg.sender;
        fundseeker.add=owner;
        fundseeker.balanceCollected=0;
        stage=Stage.Init;
        countVote=0;
    }
    
    function registerAsFunder() public{
        
        funderList[msg.sender].add = msg.sender;
        funderList[msg.sender].hasVoted = false;
        
    }
    
    function donateFunds() public payable isRegisterd{
        address(this).transfer(msg.value);
        fundseeker.balanceCollected=fundseeker.balanceCollected+msg.value;
        emit MoneyTransferred(msg.sender,address(this),msg.value);
        
    }
    function withDraw() public isOwner isReqStage(Stage.Done) payable returns(bool){
        
        if(countVote>1){msg.sender.transfer(fundseeker.balanceCollected);
            return true;
        }
        else{
            return false;
        }
        
    }
    function baln() public view returns(uint){
        return address(this).balance;
    }
    
    function initVote() public isFunder isReqStage(Stage.Init){
        stage=Stage.Vote;
    }
    function endVoting() public isFunder isReqStage(Stage.Vote){
        stage=Stage.Done;
    }
    function vote(voteDetail v) public isFunder isReqStage(Stage.Vote) hasalreadyVoted{
        
            funderList[msg.sender].hasVoted = true;
        if(v==voteDetail.Favour){
            countVote++;
        }
        emit votingDone(v,msg.sender);
        
    }
    
    
    
    
}