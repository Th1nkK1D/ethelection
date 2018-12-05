import { default as Web3 } from 'web3';
import { default as contract } from 'truffle-contract'

import voter_artifacts from '../build/contracts/Voter.json'

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"))

let accountAddress = ''

web3.eth.getAccounts(function (err, accs) {
  if (err != null) {
    console.log('There was an error fetching your accounts.')
    return
  }

  if (accs.length === 0) {
    console.log("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
    return
  }

  accountAddress = accs[0]

})

const Voter = contract(voter_artifacts)

Voter.setProvider(web3.currentProvider)

export { Voter, accountAddress }