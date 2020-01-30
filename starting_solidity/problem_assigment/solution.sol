    pragma solidity >=0.4.22 <0.6.0;
    
    contract Auction{
        
        struct Item{
            uint itemId;
            uint[] itemToken;
            
        }
        
        struct Person{
            uint8 person_id;
            uint remainingTokens;
            address addr;
        }
        
        mapping (address =>Person) public tokenDetails;
        
        Person[4] bidders;
        
        Item[3] public items;
        
        address[3] public winner;
        address public owner;
        
        modifier isOwner(){
            require(msg.sender == owner);
            _;
        }
        
        uint8 bidderCount=0;
        constructor() public payable{
            owner=msg.sender;
            
            uint[] memory emptyArray;
            for(uint8 i=0;i<3;i++){
                items[i] = Item({itemId:i,itemToken:emptyArray});
            }
            
             
        }
        function Register(address bidderAddress) public isOwner payable{
            bidders[bidderCount].person_id=bidderCount;
            bidders[bidderCount].addr=bidderAddress;
            bidders[bidderCount].remainingTokens=5;
            tokenDetails[bidderAddress]=bidders[bidderCount];
            assert(tokenDetails[bidderAddress].remainingTokens != 0);
            bidderCount++;
            
            
        }
        function bid(uint _itemId,uint _count) public payable{
            if(tokenDetails[msg.sender].remainingTokens < _count || tokenDetails[msg.sender].remainingTokens == 0 || _itemId > 2) revert("bidding unsuccesful");
            tokenDetails[msg.sender].remainingTokens -= _count;
            bidders[tokenDetails[msg.sender].person_id].remainingTokens=tokenDetails[msg.sender].remainingTokens;
            
            Item storage bidItem=items[_itemId];
            for(uint i=0; i<_count;i++) {
                bidItem.itemToken.push(tokenDetails[msg.sender].person_id);
                        }
            
            
                }
        function revealWinner() public{
            for(uint i=0;i<3;i++){
                Item storage currentItem=items[i];
                if(currentItem.itemToken.length != 0){
                uint randomIndex=(block.number/currentItem.itemToken.length)%currentItem.itemToken.length;
                uint winnerId = currentItem.itemToken[randomIndex];
                winner[i]=bidders[winnerId].addr;
                    
                }   
            }
        }
        function getPersonDetails(uint id) public view returns(uint,uint8,address){
                return (bidders[id].remainingTokens,bidders[id].person_id,bidders[id].addr);
    }
    
        }