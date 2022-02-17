// SPDX-License-Identifier: MIT
// Author: ayshptk
pragma solidity >=0.8.12;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Benk {
    mapping(address => uint256) ledger;

    ERC20 public benk;

    event GaveMonies(address indexed to, uint256 amount);
    event GotMonies(address indexed from, uint256 amount);

    address deployer;
    uint256 public dripAmount = 0.1 ether;
    uint256 public dripInterval = 60 minutes;

    constructor() {
        deployer = msg.sender;
    }

    function fund() external payable {
        emit GotMonies(msg.sender, msg.value);
    }

    function drip() external {
        require(address(this).balance >= dripAmount, "insufficient balance");
        require(eligible(), "you're being timed out, try later");

        benk.transfer(msg.sender, dripAmount);
        ledger[msg.sender] = block.timestamp;

        emit GaveMonies(msg.sender, dripAmount);
    }

    function cashout() public {
        require(msg.sender == deployer, "fuck u.");
        address payable addr = payable(address(msg.sender));
        selfdestruct(addr);
    }

    function eligible() public view returns (bool) {
        return ledger[msg.sender] <= block.timestamp - dripInterval;
    }

    function changeAdmin(address newAdmin) public {
        require(msg.sender == deployer, "fuck u.");
        deployer = newAdmin;
    }

    function changeDripAmount(uint256 newAmount) public {
        require(msg.sender == deployer, "fuck u.");
        dripAmount = newAmount;
    }

    function changeDripInterval(uint256 newInterval) public {
        require(msg.sender == deployer, "fuck u.");
        dripInterval = newInterval;
    }
}
