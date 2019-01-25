pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";

contract AllowRegulationRule is RegulationRule {
    function canReceive(address /*_address*/, uint256 /*_amount*/, Investor memory /*_investor*/) view public returns (bool) {
        return true;
    }

    function canSend(address /*_address*/, uint256 /*_amount*/, Investor memory /*_investor*/) view public returns (bool) {
        return true;
    }
}
