pragma solidity ^0.4.0;


contract bidder{
    string public mname;
    uint public bidamount;
    uint public currentBid;
    bool public eligibility;
    
    function setName(string name) public{
        mname=name;
    }
    function setBidAmount(uint amount) public{
        bidamount=amount;
    }
    function isEligibility() public returns(bool){
        if(bidamount>currentBid){
            currentBid=bidamount;
            return true;
        }
        else{
            return false;
        }
    }
    
    
    
}