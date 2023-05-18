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
 uint private totatlPayments;

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
 event CarAdded(uint indexed id, string name, stringimgUrl);
}
