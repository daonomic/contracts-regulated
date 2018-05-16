pragma solidity ^0.4.23;

import "@daonomic/interfaces/contracts/MintableToken.sol";

contract RegulatedToken is MintableToken {
    /**
     * @dev Check if investor is able to receive tokens
     */
    function canReceive(address _address, uint256 _amount) constant public returns (bool);

    /**
     * @dev Check if investor is able to send tokens
     */
    function canSend(address _address, uint256 _amount) constant public returns (bool);
}