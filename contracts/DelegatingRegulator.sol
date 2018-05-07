pragma solidity ^0.4.23;

import "./Regulator.sol";
import "@daonomic/util/contracts/OwnableImpl.sol";

contract DelegatingRegulator is OwnableImpl, Regulator {
    mapping(address => uint256) public investors;
    mapping(uint256 => address) public delegates;

    function onMint(address to, uint256 amount) {
        address delegate = getDelegate(to);
        if (delegate != address(0)) {
            Regulator(delegate).onMint(to, amount);
        }
    }

    function onTransferFrom(address from, address to, uint256 amount) {
        address delegate = getDelegate(from);
        if (delegate != address(0)) {
            Regulator(delegate).onTransferFrom(from, to, amount);
        }
    }

    function onTransferTo(address from, address to, uint256 amount) {
        address delegate = getDelegate(to);
        if (delegate != address(0)) {
            Regulator(delegate).onTransferFrom(from, to, amount);
        }
    }

    function getDelegate(address investor) internal returns (address) {
        uint256 jurisdiction = investors[to];
        require(jurisdiction != 0, "investor not found");
        return delegates[jurisdiction];
    }

    function setJurisdiction(address investor, uint256 jurisdiction) onlyOwner public {
        investors[investor] = jurisdiction;
    }

    function setDelegate(uint256 jurisdiction, address delegate) onlyOwner public {
        delegates[jurisdiction] = delegate;
    }
}
