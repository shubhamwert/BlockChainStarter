pragma solidity ^0.4.0;


contract simpleStorage{
    uint8 private store;
    function set(uint8 valu) public{
        store=valu;
        
    }
    function get() constant public returns(uint){
        return store;
    }
    function increament(uint8 increase) public{
        store=store+increase;
    }
    function decreament(uint8 dec) public{
        if(store>dec){
            store=store-dec;
        }
    }
    
    
    
    
}