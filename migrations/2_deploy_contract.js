const Voter = artifacts.require("./Voter.sol");

const citizenIds = [1001, 1002, 1003, 1004]
const candidateIds = [1, 2, 3, 4]

module.exports = function(deployer) {
  deployer.deploy(
    Voter,
    citizenIds,
    candidateIds
  );
};
