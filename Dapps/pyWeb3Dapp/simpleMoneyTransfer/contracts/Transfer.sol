pragma solidity ^0.5.6;

contract User{
    struct UserDetails{
        uint8 id;
        string name;
        address add;
    }

    address owner;
    UserDetails user;
    event moneyTransfered(address to,address from,uint value);
    event Received(address, uint);
    modifier isOwner(){
        require(msg.sender==owner,"you are not owner of this account");
        _;
    }
    function() external payable { }

    constructor(string memory username) public{
        user.name = username;
        owner = msg.sender;
    }

    function transferMoney(address payable add) public isOwner payable{
            add.transfer(msg.value);
            emit moneyTransfered(add,msg.sender,msg.value);
    }

    function transferSelf() public payable isOwner {
        msg.sender.transfer(address(this).balance);
        emit moneyTransfered(msg.sender,address(this),address(this).balance);

    }

    function checkBalance() public view returns(uint){
        return address(this).balance;
    }
    
    // receive() external payable {
    //     emit Received(msg.sender, msg.value);
    // }



}