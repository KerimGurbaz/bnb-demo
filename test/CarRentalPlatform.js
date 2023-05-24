const CarRentalPlatform = artifacts.require("CarRentalPlatform");
contract("CarRentalPlatform", accounts =>{
  let CarRentalPlatform;
  const owner =  accounts[0];
  const user1 =  accounts[1];

  beforeEach(async ()=>{
    CarRentalPlatform = await CarRentalPlatform.new();
  });
})