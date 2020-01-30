pragma solidity ^0.4.0;

contract Greet{
    string private name;
    
    function Greet() public{
        name = "hello";
    }
    
    function set(string yourName) public{
        name=yourName;
    }     
    function hello() constant public returns(string){
        return name;
    }
    
    
    
    
    
}