pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";

contract AllowRegulationRule is RegulationRule {
    function canReceive(address /*_address*/, uint256 /*_amount*/, Investor /*investor*/) constant public returns (bool) {
        return true;
    }

    function canSend(address /*_address*/, uint256 /*_amount*/, Investor /*_investor*/) constant public returns (bool) {
        return true;
    }
}
