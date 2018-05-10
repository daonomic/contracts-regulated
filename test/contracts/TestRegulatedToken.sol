pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "@daonomic/util/contracts/SecuredImpl.sol";
import "@daonomic/util/contracts/OwnableImpl.sol";
import "../../contracts/RegulatedTokenImpl.sol";

contract TestRegulatedToken is OwnableImpl, SecuredImpl, RegulatedTokenImpl {
}
