pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";
import "./Jurisdictions.sol";

contract UsRegulationRule is Jurisdictions, RegulationRule {
    byte public ACCREDITED_INVESTOR = 0x80;

    function checkMint(address _address, uint256 _amount, KycProvider.Investor _investor) public returns (bool) {
        return _investor.jurisdiction == US && _investor.data[0] & ACCREDITED_INVESTOR != 0;
    }

    function checkTransferFrom(address _address, uint256 _amount, KycProvider.Investor _investor) public returns (bool) {
        return true;
    }

    function checkTransferTo(address _address, uint256 _amount, KycProvider.Investor _investor) public returns (bool) {
        return _investor.jurisdiction == US && _investor.data[0] & ACCREDITED_INVESTOR != 0;
    }
}
