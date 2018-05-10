pragma solidity ^0.4.23;

import "@daonomic/interfaces/contracts/MintableToken.sol";

contract RegulatedToken is MintableToken {
    /**
     * @dev Check if investor is able to receive token
     */
    function ableToReceive(address _address, uint256 _amount) constant public returns (bool);
}