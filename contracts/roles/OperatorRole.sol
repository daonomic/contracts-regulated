pragma solidity ^0.5.0;


import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract OperatorRole is Ownable {
    using Roles for Roles.Role;

    event OperatorAdded(address indexed account);
    event OperatorRemoved(address indexed account);

    Roles.Role private _operators;

    constructor () internal {
        _addOperator(msg.sender);
    }

    modifier onlyOperator() {
        require(isOperator(msg.sender));
        _;
    }

    function isOperator(address account) public view returns (bool) {
        return _operators.has(account);
    }

    function addOperator(address account) public onlyOwner {
        _addOperator(account);
    }

    function removeOperator(address account) public onlyOwner {
        _removeOperator(account);
    }

    function _addOperator(address account) internal {
        _operators.add(account);
        emit OperatorAdded(account);
    }

    function _removeOperator(address account) internal {
        _operators.remove(account);
        emit OperatorRemoved(account);
    }
}
