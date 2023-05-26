var CarRentalPlatform = artifacts.require("./CarRentalPlatform.sol");

module.exports = function(deployer) {
  deployer.deploy(CarRentalPlatform);
};
