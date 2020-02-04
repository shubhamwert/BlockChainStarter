pragma solidity ^0.5.15;

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
    // Funders contract_funder;
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
    // function setFundPoolAddress(address payable contract_id) public onlyAuth payable{
    //     contract_funder=Funders(contract_id);
    //     // canTakeMoney=contract_funder.isAllowedToWithdraw();
    // }
    // function initiateWithdrawal_Fundi() public onlyAuth payable{
    //     contract_funder.initiateWithdrawal(msg.sender);
    // }
    function transfer_to_self(address payable self_acc) public onlyAuth canWithdraw payable{
        self_acc.transfer(address(this).balance);
        FundSeeker.collected_money = 0;
    }
    // receive () external payable{ }

    function() external payable { }
}
