const TRIBESToken = artifacts.require("./TRIBESToken.sol");
const SafeMath = artifacts.require("./openzeppelin/contracts/math/SafeMath.sol");

module.exports = function(deployer, network, accounts) {
  let overwrite = true;
  var systemWallet = accounts[7]
  let tokenName = "TRIBES";
  let tokenSymbol = "TRBX";

  switch (network) {
    case 'development':
      overwrite = true;
      break;
    default:
        throw new Error ("Unsupported network");
  }

  deployer.then (async () => {
      await deployer.link(SafeMath, TRIBESToken);
      return deployer.deploy(TRIBESToken, tokenName, tokenSymbol, systemWallet, {overwrite: overwrite});
  }).then(() => {
      return TRIBESToken.deployed();
  }).catch((err) => {
      console.error(err);
      process.exit(1);
  });
};
