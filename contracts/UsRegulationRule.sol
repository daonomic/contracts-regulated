pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";
import "./Jurisdictions.sol";

contract UsRegulationRule is Jurisdictions, RegulationRule {
    byte public ACCREDITED_INVESTOR = 0x80;

    function canReceive(address /*_address*/, uint256 /*_amount*/, Investor memory _investor) view public returns (bool) {
        return _investor.jurisdiction == US && (_investor.data[0] & ACCREDITED_INVESTOR) != 0;
    }

    function canSend(address /*_address*/, uint256 /*_amount*/, Investor memory /*_investor*/) view public returns (bool) {
        return true;
    }
}
