const CarRentalPlatform = artifacts.require("CarRentalPlatform");

module.exports = function (deployer) {
  deployer.deploy(CarRentalPlatform);
};
