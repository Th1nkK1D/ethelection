pragma solidity ^0.4.24;

// Voter contract class
contract Voter {
    // enum and struct declaration
    enum CitizenState { notpermitted, waiting, redeemed, voted }

    struct CitizenData {
        CitizenState state;
        bytes32 key;
    }

    // Public variable, can access with autogen getter
    uint public totalCitizens;
    uint public totalCandidates;
    uint[4] public citizenStateCount;

    // Private function for internal use
    mapping (uint=>CitizenData) private citizenList;
    mapping (uint=>uint) private candidateList;

    // Event declaration  
    event Redeem(uint indexed citId, bytes32 key);
    event Vote(uint indexed citId, bytes32 key, uint canId);

    // Constructor initialize contract when deployed
    constructor(uint[] citizens, uint[] candidates) public {
        // Init counter
        totalCitizens = citizens.length;
        totalCandidates = candidates.length;
        citizenStateCount[uint256(CitizenState.waiting)] = totalCitizens;

        // Init citizenList
        for (uint32 i = 0; i < totalCitizens; i++) {
            citizenList[citizens[i]] = CitizenData(CitizenState.waiting, "");
        }

        // Init candidateList
        for (i = 0; i < totalCandidates; i++) {
            candidateList[candidates[i]] = 0;
        }
    }

    // Debugging function

    function getCitizenState(uint citId) public view returns(CitizenState) {
        return citizenList[citId].state;
    }

    function getCitizenKey(uint citId) public view returns(bytes32) {
        return citizenList[citId].key;
    }

    // Manipulating function

    function redeemToken(uint citId, bytes32 key) public returns(bool success) {
        // Check permission
        if (citizenList[citId].state != CitizenState.waiting) return false;

        // Update citizen state and key
        citizenList[citId].state = CitizenState.redeemed;
        citizenList[citId].key = key;

        // Update counter
        citizenStateCount[uint256(CitizenState.waiting)]--;
        citizenStateCount[uint256(CitizenState.redeemed)]++;

        emit Redeem(citId, citizenList[citId].key);

        return true;
    }

    function vote(uint citId, bytes32 key, uint canId) public returns(bool success) {
        // Check permission and key
        if (citizenList[citId].state != CitizenState.redeemed || citizenList[citId].key != key) return false;

        // Increment candidate vote and update citizen state
        candidateList[canId]++;
        citizenList[citId].state = CitizenState.voted;

        // Update counter
        citizenStateCount[uint256(CitizenState.redeemed)]--;
        citizenStateCount[uint256(CitizenState.voted)]++;

        emit Vote(citId, citizenList[citId].key, canId);

        return true;
    }

    // View function

    function getCandidateVote(uint citId) public view returns(uint) {
        return candidateList[citId];
    }
}