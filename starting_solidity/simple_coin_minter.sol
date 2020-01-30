pragma solidity ^0.4.0;

contract coin{
    
    address public minter;
    mapping (address => uint) balances;
    event Sent(address from,address to,uint amt);
    function coin() public{
        minter = msg.sender;
    }
    //mint out money
    function mint(address reciever,uint amt){
        if(msg.sender != minter) return;
        else{
            balances[reciever]+=amt;
        }
    }
    function send(address reciever,uint amt){
        if(balances[msg.sender]<amt) return;
        else{
            balances[msg.sender]-=amt;
            balances[reciever]+=amt;
            Sent(msg.sender,reciever,amt);
            
            
            
            
        }
        
        
        
        
        
    }
    
    
}