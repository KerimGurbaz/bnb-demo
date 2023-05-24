const CarRentalPlatform = artifacts.require("CarRentalPlatform");
contract("CarRentalPlatform", accounts =>{
  let carRentalPlatform;
  const owner =  accounts[0];
  const user1 =  accounts[1];

  beforeEach(async ()=>{
    carRentalPlatform = await CarRentalPlatform.new();
  });


  descripe("Add user and car", ()=>{
    it("adds a new user", async()=>{
      await carRentalPlatform.addUser("Alice", "Smith", {from:user1});
      const user = await carRentalPlatform.getUser(user1);
      assert.equal(user.name, "Alice", "Problem with user name");
      assert.equal(user.lastname, "Smith", "Problem with user lastname");
    });

    it("adds a car ", async()=>{
      await carRentalPlatform.addCar("Tesla Model S", "example url", 10, 50000, {from:owner});
      const car = await carRentalPlatform.getCar(1);
      assert.equal(car.name, "Tesla Model S", "Problem with car name");
      assert.equal(car.imgUrl, "example url", "Problem with img url");
      assert.equal(car.rentFee, 10, "Problem with rent fee");
      assert.equal(car.saleFee, 50000, "Problem with sale fee");

    });
  });

  describe("Check out and check in car", ()=>{
    it("Check out  a car", async()=>{
      await carRentalPlatform.addUser("Alice", "Smith", {from:user1});
      await carRentalPlatform.addCar("Tesla Model S", "example url", 10, 50000, {from:owner});
      await carRentalPlatform.checkOut(1, {from:user1});

      const user = await carRentalPlatform.getUser(user1);
      assert.equal(user.rentedCarId, 1, "User could not check out the car");
    });

    it("Checks in  a car", async()=>{
      await carRentalPlatform.addUser("Alice", "Smith", {from:user1});
      await carRentalPlatform.addCar("Tesla Model S", "example url", 10, 50000, {from:owner});
      await carRentalPlatform.checkOut(1, {from:user1});
      await new Promise((resolve)=>setTimeout(resolve, 600000)); // 1 min

      await carRentalPlatform.checkIn({from:user1});

      const user = await carRentalPlatform.getUser(user1);

      assert.equal(user.rentedCarId, 0, "User could not check in the car");
      assert.equal(user.debt, 10, "User debt did not get created");
  });
  });

  describe("Deposit token and make payment", ()=>{
    it("deposits token", async()=>{
      await carRentalPlatform.addUser("Alice", "Smith", {from:user1});
      await carRentalPlatform.deposit({from:user1, value:100}) ;
     
      const user = await carRentalPlatform.getUser(user1);
      assert.equal(user.balance, 100, "User could not deposit tokens");
    });

    it("makes a payment", async()=>{
      await carRentalPlatform.addUser("Alice", "Smith", {from:user1});
      await carRentalPlatform.addCar("Tesla Model S", "example url", 10, 50000, {from:owner});
      await carRentalPlatform.checkOut(1, {from:user1});
      await new Promise((resolve)=>setTimeout(resolve, 600000)); // 1 min
      await carRentalPlatform.checkIn({from:user1});

      await carRentalPlatform.deposit({from:user1, value:100}) ;
      await carRentalPlatform.makePayment({from:user1}) ;

      const user = await carRentalPlatform.getUser(user1);

      assert.equal(user.debt, 0, "Something went wrong while trying to make the payment");
     
  });
});



});
