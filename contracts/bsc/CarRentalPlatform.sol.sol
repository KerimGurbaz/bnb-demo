// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract CarRentalPlatform {
 //DATA 

 //Counter
 using Counters for Counters.Counter;
 Counters.Counter private _counter;

 //Owner
 address private owner;

 //Total Payments
 uint private totalPayments;

 //user struct
 struct User{
    address walletAddress;
    string name;
    string lastname;
    uint rentedCarId;
    uint balance;
    uint debt;
    uint start;
 }

 // Car struct
 struct Car{
   uint id;
   string name;
   string imgUrl;
   Status status;
   uint rentFee;
   uint saleFee;
 }

 //enum to indicate the status of the car
 enum Status{
   Retired,
   InUse,
   Available
 }

 //events
 event CarAdded(uint indexed id, string name, string imgUrl, uint rentFee, uint saleFee);
 event CarMetadataEdited(uint indexed id, string name, string imgUrl, uint rentFee, uint saleFee);
 event CarStatusEdited(uint indexed id, Status status);
 event UserAdded(address indexed walletAddress, string name, string lastname);
 event Deposit(address indexed walletAddress, uint amount);
 event CheckOut(address indexed walletAddress, uint indexed carId);
 event CheckIn(address indexed walletAddress, uint indexed carId);
 event PaymentMade(address indexed walletAddress, uint amount);
 event BalanceWithdrawn(address indexed walletAddress, uint amount);

 //user mapping
 mapping(address => User) private users;

 //car mapping
 mapping(uint => Car) private cars;

 // constructor
 constructor(){
  owner = msg.sender;
  totalPayments = 0;
 }

 //Modifiers
 //onlyOwner
 modifier onlyOwner(){
  require(msg.sender == owner, "Only the owner can call this function");
  _;
 }

//  FUNCTIONS
//Execute functions

//Set owner #onlyOwner
function setOwner(address _newOwner) external onlyOwner{
  owner = _newOwner;
}

//addUser #nonExisting
function addUser(string calldata name, string calldata lastname) external{
  require(!isUser(msg.sender), "User already exists");
  users[msg.sender] = User(msg.sender, name, lastname, 0,0,0,0);

  emit UserAdded(msg.sender, users[msg.sender].name, users[msg.sender].lastname);

}

//addCar #onlyOwner #nonExistingCar
function addCar(string calldata name, string calldata url, uint rent, uint sale) external onlyOwner{
  _counter.increment();

  uint counter = _counter.current();
  cars[counter] = Car(counter, name, url, Status.Available, rent, sale);

  emit CarAdded(counter, cars[counter].name, cars[counter].imgUrl, cars[counter].rentFee, cars[counter].saleFee);

}

  //editCarMetadata #onlyOwner #existingCar
 function editCarMetadata(uint id, string calldata name, string calldata imgUrl, uint rentFee, uint saleFee) external onlyOwner{
  require(cars[id].id !=0, "Car with given ID does not exist");
  Car storage car = cars[id];
  if(bytes(name).length !=0){
    car.name = name;
  }
  if(bytes(imgUrl).length !=0){
    car.imgUrl = imgUrl;
  }
  if(rentFee > 0){
    car.rentFee = rentFee;
  }
  if(saleFee > 0){
    car.saleFee = saleFee;
  }

  emit CarMetadataEdited(id, car.name, car.imgUrl, car.rentFee, car.saleFee);
  }

  //editCarStatus #onlyOwner #existingCar
  function editCarStatus(uint id, Status status) external onlyOwner{
    require(cars[id].id !=0, "Car with given ID does not exist");
    cars[id].status = status;

    emit CarStatusEdited(id, status);
  }

  function checkOut(uint id) external{
    require(isUser(msg.sender), "User does not exist!");
    require(cars[id].status == Status.Available, "Car is not Available for use");
    require(users[msg.sender].rentedCarId == 0 , "User has already rented a car");
    require(users[msg.sender].debt == 0, "User has an outstanding debt!");

    users[msg.sender].start = block.timestamp;
    users[msg.sender].rentedCarId = id;
    cars[id].status = Status.InUse;

    emit CheckOut(msg.sender, id);
  }

  //checkIn #existingUser #userHasRentedACar
  function checkIn() external {
    require(isUser(msg.sender), "User does not exist");
    uint rentedCarId = users[msg.sender].rentedCarId;
    require(rentedCarId !=0, "User has not rented a car");

    uint usedSeconds = block.timestamp - users[msg.sender].start;
    uint rentFee = cars[rentedCarId].rentFee;
    users[msg.sender].debt += calculateDebt(usedSeconds, rentFee);

    users[msg.sender].rentedCarId = 0;
    users[msg.sender].start = 0;
    cars[rentedCarId].status = Status.Available;

    emit CheckIn(msg.sender, rentedCarId);

  }

  // deposit #existingUser

  function deposit() external payable{
    require(isUser(msg.sender), "User does not exist");
    users[msg.sender].balance += msg.value;

    emit Deposit(msg.sender, msg.value);
  }

  //makePayment #existingUser #existingDebt #suffiecientBalance

  function makePayment() external {
    require(isUser(msg.sender), "User does not exist");
    uint debt = users[msg.sender].debt;
    uint balance = users[msg.sender].balance;

    require(debt > 0, "User has debt to pay");
    require(balance >= debt, "User has insufficient balance");

     unchecked{
      users[msg.sender].balance -=debt; 
     }
     totalPayments += debt;
     users[msg.sender].debt = 0;

     emit PaymentMade(msg.sender, debt);
  }











}
