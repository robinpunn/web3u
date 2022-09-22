// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

// Deployed to Goerli at 0x3A5Ffde5eC7921f1cAbC2973e86D8C201f994a6c

contract BuyMeACoffee {
   // Event to emit when a Memo is created 
   event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
   );

   // Memo struct
   struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
   }

   // List of all memos recieved from friends
   Memo[] memos;

   // Address of contract deployer
   address payable owner;

   // Deploy logic 
   constructor() {
        owner = payable(msg.sender);
   }

   /** 
    * @dev buy a coffee for contract owner
    * @param _name name of the coffee buyer
    * @param _message a nice message fromt he coffee buyer
    */
   function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "can't buy coffee with 0 eth");

        // Add the memo to storage
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a log event when a new memo is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
   }

   /** 
   * @dev send the balance stored in this contract to owner
   */ 
   function withdrawTips() public {
        require(owner.send(address(this).balance));
   }

   /** 
   * @dev retrieve all the memos reveived and stored on the blockchain
   */ 
   function getMemos() public view returns(Memo[] memory) {
        return memos;
   }
}
