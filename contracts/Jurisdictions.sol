pragma solidity ^0.4.23;

/**
 * @title Jurisdictions
 * @dev Enumerates known jurisdictions
 */
contract Jurisdictions {
    uint16 constant US = 1;
    uint16 constant ALLOWED = 2**16 -2;
    uint16 constant OTHER = 2**16 - 1;
}
