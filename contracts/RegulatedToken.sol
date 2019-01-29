pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract RegulatedToken is IERC20 {
    /**
     * @dev Check if investor is able to receive tokens
     */
    function canReceive(address _address, uint256 _amount) view public returns (bool);

    /**
     * @dev Check if investor is able to send tokens
     */
    function canSend(address _address, uint256 _amount) view public returns (bool);
}