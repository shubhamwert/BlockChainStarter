pragma solidity ^0.5.15;
//Fund Seeker Contract
contract Funders{
    enum Stage{ Init, Vote, Done}
        Stage public stage=Stage.Init;
    
    function initiateWithdrawal(address add) public  { }
    function isAllowedToWithDraw(address id) public payable returns(bool){   }
    
}
contract Fundi{
    struct Person{
    uint8 id;
    string userName;
    address account;
    uint collected_money;
    } 
    enum Stage{ Init, Vote, Done}
        Stage public stage=Stage.Init;
    
    bool public canTakeMoney=false;
    Person public FundSeeker;
    event Receive(uint value);
    Funders contract_funder;
    constructor(string memory name) public payable{
        FundSeeker.id = 0;
        FundSeeker.userName = name;
        FundSeeker.account = msg.sender;
        FundSeeker.collected_money = 0;
    }
    modifier onlyAuth(){
        require(msg.sender == FundSeeker.account,"please use owner account");
        _;
    }
    modifier canWithdraw(){
        require(canTakeMoney,"you dont have sufficent Balance");
        _;
    }
    function getCollectedMoney() public onlyAuth returns(uint){
        FundSeeker.collected_money = address(this).balance;
        return FundSeeker.collected_money;
    }
    function getAccOwner() public view returns(address){
        return FundSeeker.account;
    }
    function setFundPoolAddress(address payable contract_id) public onlyAuth payable{
        contract_funder=Funders(contract_id);
        
    }
    function initiateWithdrawal_Fundi() public onlyAuth payable{
        contract_funder.initiateWithdrawal(address(this));
    }
    function checkWithdrawalStage() public onlyAuth payable{
        canTakeMoney=contract_funder.isAllowedToWithDraw(address(this));
    }
    function transfer_to_self(address payable self_acc) public onlyAuth canWithdraw payable{
        self_acc.transfer(address(this).balance);
        FundSeeker.collected_money = 0;
    }
    // receive () external payable{ }

    function() external payable { }
}
