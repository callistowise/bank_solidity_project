pragma solidity 0.7.5;

import './ownable.sol';

interface GovernmentInterface {
    function addTransaction(address _from, address _to, uint _amount) external;
}

contract Bank is Ownable {

    GovernmentInterface governmentInstance = GovernmentInterface(0x0498B7c793D7432Cd9dB27fb02fc9cfdBAfA1Fd3);

    mapping(address => uint) balance;
    event depositDone(uint amount, address indexed depositedTo);

    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];

    }

    function withdraw(uint amount) public onlyOwner returns (uint) {
        require(balance[msg.sender] >= amount, "Withdrawal amount exceeds balance");
        balance[msg.sender] -= amount;
        msg.sender.transfer(amount);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function transfer(address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Can't transfer ETH to yourself");

        uint previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);

        governmentInstance.addTransaction(msg.sender, recipient, amount);

        assert(balance[msg.sender] == previousSenderBalance - amount);

        // event logs and checks 
    } 

    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    } 

}


