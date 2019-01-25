pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";

contract DenyRegulationRule is RegulationRule {
    function canSend(address /*_address*/, uint256 /*_amount*/, Investor memory /*_investor*/) view public returns (bool) {
        return false;
    }

    function canReceive(address /*_address*/, uint256 /*_amount*/, Investor memory /*_investor*/) view public returns (bool) {
        return false;
    }
}
