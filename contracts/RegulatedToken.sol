pragma solidity ^0.4.23;

import "@daonomic/interfaces/contracts/MintableToken.sol";

contract RegulatedToken is MintableToken {
    function ableToReceive(address _address, uint256 _amount) constant public returns (bool);
}