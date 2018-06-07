pragma solidity ^0.4.23;

/**
 * @title Jurisdictions
 * @dev Enumerates known jurisdictions
 */
contract Jurisdictions {
    uint16 public constant US = 1;
    uint16 public constant ALLOWED = 2**16 - 2;
    uint16 public constant OTHER = 2**16 - 1;
}
