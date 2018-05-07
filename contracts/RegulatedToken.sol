pragma solidity ^0.4.23;

import "@daonomic/tokens/contracts/MintableTokenImpl.sol";
import "./Regulator.sol";

contract RegulatedToken is MintableTokenImpl {
    Regulator public regulator;

    constructor(Regulator _regulator) {
        regulator = _regulator;
    }

    function mint(address _to, uint256 _amount) public returns (bool) {
        return super.mint(_to, _amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        return super.transfer(_to, _value);
    }
}
