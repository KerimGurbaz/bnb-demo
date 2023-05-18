// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/utils/Counters.sol";
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
    uint rentedCardId;
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
}
