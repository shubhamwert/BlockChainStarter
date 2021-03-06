// pragma solidity ^0.5.15;
// //Fund Seeker Contract
// contract Funders{
//     enum Stage{ Init, Vote, Done}
//         Stage public stage=Stage.Init;
    
//     function initiateWithdrawal(address add) public  { }
//     function isAllowedToWithDraw(address id) public payable returns(bool){   }
    
// }
// contract Fundi{
//     struct Person{
//     uint8 id;
//     string userName;
//     address account;
//     uint collected_money;
//     } 
//     enum Stage{ Init, Vote, Done}
//         Stage public stage=Stage.Init;
    
//     bool public canTakeMoney=false;
//     Person public FundSeeker;
//     event Receive(uint value);
//     Funders contract_funder;
//     constructor(string memory name) public payable{
//         FundSeeker.id = 0;
//         FundSeeker.userName = name;
//         FundSeeker.account = msg.sender;
//         FundSeeker.collected_money = 0;
//     }
//     modifier onlyAuth(){
//         require(msg.sender == FundSeeker.account,"please use owner account");
//         _;
//     }
//     modifier canWithdraw(){
//         require(canTakeMoney,"you dont have sufficent Balance");
//         _;
//     }
//     function getCollectedMoney() public onlyAuth returns(uint){
//         FundSeeker.collected_money = address(this).balance;
//         return FundSeeker.collected_money;
//     }
//     function getAccOwner() public view returns(address){
//         return FundSeeker.account;
//     }
//     function setFundPoolAddress(address payable contract_id) public onlyAuth payable{
//         contract_funder=Funders(contract_id);
        
//     }
//     function initiateWithdrawal_Fundi() public onlyAuth payable{
//         contract_funder.initiateWithdrawal(address(this));
//     }
//     function checkWithdrawalStage() public onlyAuth payable{
//         canTakeMoney=contract_funder.isAllowedToWithDraw(address(this));
//     }
//     function transfer_to_self(address payable self_acc) public onlyAuth canWithdraw payable{
//         self_acc.transfer(address(this).balance);
//         FundSeeker.collected_money = 0;
//     }
//     // receive () external payable{ }

//     function() external payable { }
// }


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