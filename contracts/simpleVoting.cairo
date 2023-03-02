#[contract] //Keyword to show that it's a Cairo contract
 
//mod - keyword defining a module
mod Voting {
    use starknet::get_caller_address; //Import libraries/packages and use them
    use starknet::ContractAddress;

    struct Storage {
        //Define name(type "felt") and a map(LegacyMap::<a,b>) for storing the proposal votes
        name: felt,
        proposalVotes: LegacyMap<u256, u256>,
    }

    //Initialise a default proposal
    #[constructor]
    fn constructor(_name: felt, _propNum: u256) {
        
        //Initialise the proposal with 0 votes
        //Initialise the "name" variable
        //HINT: Use "::write" 
        proposalVotes::write(_propNum, 0);
        name::write(_name);
    }

    #[external]
    fn addProposals(_propNum: u256) {
        //Write to the proposal map
        proposalVotes::write(_propNum, 0);
    }

    #[external]
    fn voteOnProposal(_propNum: u256) {
        let voter = get_caller_address();
        
        //Read the proposalVotes mapping and increment by 1
        //HINT: Use "::read"
        let mut votes = proposalVotes::read(_propNum);
        votes += 1;
        
        //Write the updated value here
        proposalVotes::write(_propNum, votes);
    }

    #[view]
    fn getVotesForProposal(_propNum: u256) -> felt {
      proposalVotes::read(_propNum)
    }

    //TODO - Add a function to compare two given proposals and return the one with higher votes
    #[external]
    fn compareProposalVotes(_propNum1: u256, _propNum2: u256) -> felt {
        let votes1 = proposalVotes::read(_propNum1);
        let votes2 = proposalVotes::read(_propNum2);
        if votes1 > votes2 {
            return _propNum1;
        } else {
            return _propNum2;
        }
    }

}
