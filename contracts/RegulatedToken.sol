pragma solidity ^0.4.23;

import "@daonomic/tokens/contracts/MintableTokenImpl.sol";
import "./Regulator.sol";

contract RegulatedToken is MintableTokenImpl {
    Regulator public regulator;

    constructor(Regulator _regulator) {
        this.regulator = _regulator;
    }

    function mint(address _to, uint256 _amount) public returns (bool) {
        regulator.onMint(_to, _amount);
        return super.mint(_to, _amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        regulator.onTransferFrom(msg.sender, _to, _value);
        regulator.onTransferTo(msg.sender, _to, _value);
        return super.transfer(_to, _value);
    }
}
