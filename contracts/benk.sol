// SPDX-License-Identifier: MIT
// Author: ayshptk
pragma solidity >=0.8.12;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Benk {
    // track when an address asked for a withdrawal last
    mapping(address => uint256) ledger;

    // erc20 instance
    ERC20 public benk;

    // events
    event GaveMonies(address indexed to, uint256 amount);
    event GotMonies(address indexed from, uint256 amount);

    // superadmin
    address deployer;

    // sets drip rate
    uint256 public dripAmount = 0.1 ether;
    uint256 public dripInterval = 60 minutes;

    // sets the superadmin
    constructor() {
        deployer = msg.sender;
    }

    // deposit monies into the contract
    function fund() external payable {
        emit GotMonies(msg.sender, msg.value);
    }

    // drip monies from the contract
    function drip() external {
        require(address(this).balance >= dripAmount, "insufficient balance");
        require(eligible(), "you're being timed out, try later");

        benk.transfer(msg.sender, dripAmount);
        ledger[msg.sender] = block.timestamp;

        emit GaveMonies(msg.sender, dripAmount);
    }

    // ka-ching!
    function cashout() public {
        require(msg.sender == deployer, "fuck u.");
        address payable addr = payable(address(msg.sender));
        selfdestruct(addr);
    }

    // check if the address is eligible to drip
    function eligible() public view returns (bool) {
        return ledger[msg.sender] <= block.timestamp - dripInterval;
    }

    // change superadmin
    function changeAdmin(address newAdmin) public {
        require(msg.sender == deployer, "fuck u.");
        deployer = newAdmin;
    }

    // change drip rate
    function changeDripAmount(uint256 newAmount) public {
        require(msg.sender == deployer, "fuck u.");
        dripAmount = newAmount;
    }

    // change drip interval
    function changeDripInterval(uint256 newInterval) public {
        require(msg.sender == deployer, "fuck u.");
        dripInterval = newInterval;
    }
}
