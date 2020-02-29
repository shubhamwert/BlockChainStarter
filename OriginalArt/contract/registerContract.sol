pragma solidity ^0.5.14;

contract RegisterArt{
    
    address public mContractAddress;
    address public payable owner;
    uint public originalPrice;
    uint public currentPrice;
    
    
    modifier isOwner(){
        require(msg.sender==owner,"YOU ARE NOT OWNER")
        _;
    }
    constructor(uint price) public{
        owner=msg.sender;
        mContractAddress=address(this);
        currentPrice=price;
        originalPrice=price;

    }    
    
    
    function setPriceBid(uint price) isOwner {
        currentPrice=price;
        
    }
    
    function getPriceBid() public returns(uint){
        return currentPrice;
    }
    
    function getOriginalPrice() returns(uint){
        return originalPrice;
    }
    function getOwner() returns(address){
        return owner;
    }
    
    function transferOwnership(address payable newOwner) isOwner{
        owner=newOwner
    }
    
    
}