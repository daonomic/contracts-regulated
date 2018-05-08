pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "../../contracts/Regulator.sol";
import "../../contracts/RegulatedToken.sol";
import "@daonomic/util/contracts/SecuredImpl.sol";
import "@daonomic/util/contracts/OwnableImpl.sol";

contract TestRegulatedToken is OwnableImpl, SecuredImpl, RegulatedToken {
    constructor(Regulator regulator) RegulatedToken(regulator) {

    }
}
