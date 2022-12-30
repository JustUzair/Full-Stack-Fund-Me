# Test Net used : goerli

Deployed Site : [Fund-Me](https://uzair-fund-me.netlify.app/)

# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

# Important

Create a 'constants.js' file in Html-FundMe folder

- add the contract abi from compiled contract
- add the contract's address after deployment

# Environment variables (.env) file

- GOERLI_RPC_URL= GET IT FROM https://dashboard.alchemy.com/apps
- PRIVATE_KEY=YOUR_WALLET_PRIVATE_KEY
- ETHERSCAN_API_KEY=''
- COINMARKETCAP_API_KEY=''
