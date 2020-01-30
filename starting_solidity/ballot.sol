pragma solidity ^0.4.17;

contract Ballot{
    
    
    
    struct Voter{
        uint8 weight;
        bool voted;
        address delegated;
        uint vote;
        
    }
    
    struct Proposal{
        
        uint voteCount;
    }
    
    enum Stage{ Init, Reg, Vote, Done}
    Stage public stage=Stage.Init;
    
    
    address public chairperson;
    
    mapping (address => Voter) public voters;
    
    Proposal[] public proposals;
    
    uint starttime;
    
    modifier validStage(Stage requiredStage){
     require(stage==requiredStage);
     _;
    }
    event votingCompleted;
     function Ballot(uint8 _numProposals) public{
        starttime=now;
        chairperson=msg.sender;
        voters[chairperson].weight=2;
        
        proposals.length=_numProposals;
        stage=Stage.Reg;
        
    }
    function register(address toVote) public validStage(Stage.Reg){
        // if(stage != Stage.Reg){return;}
        if(msg.sender!=chairperson||voters[toVote].voted) revert();
        voters[toVote].weight=1;
        voters[toVote].voted=false;
        if(now>(starttime+20 seconds)){stage=Stage.Vote;
            starttime=now;
        }
        
    }
    
    function vote(uint8 toProposal) public validStage(Stage.Vote){
        // if(stage!=Stage.Vote) revert;
        Voter storage sender=voters[msg.sender];
        if(sender.voted||toProposal>proposals.length) revert();
        sender.voted=true;
        proposals[toProposal].voteCount+=sender.weight;
        if(now>(starttime+20 seconds)){
            stage=Stage.Done;
            votingCompleted();
        }
        
        
        
    }
        
    function winningProposal() public constant returns (uint8  _winningProposal){
        if(stage!=Stage.Done){revert();}
        uint winningVoteCount=0;
        for(uint8 prop=0;prop<proposals.length;prop++){
            if(proposals[prop].voteCount>winningVoteCount){
                winningVoteCount=proposals[prop].voteCount;
                _winningProposal=prop;
                
            }
            
        }
        
    
    }
    
    
}
