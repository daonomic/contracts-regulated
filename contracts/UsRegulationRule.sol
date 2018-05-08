pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";
import "./Jurisdictions.sol";

contract UsRegulationRule is Jurisdictions, RegulationRule {
    byte public ACCREDITED_INVESTOR = 0x80;

    function onMint(address _address, uint256 _amount, KycProvider.Investor _investor) {
        require(_investor.jurisdiction == US);
        require(_investor.data[0] & ACCREDITED_INVESTOR != 0, "investor is not accredited");
    }

    function onTransferFrom(address _address, uint256 _amount, KycProvider.Investor _investor) {

    }

    function onTransferTo(address _address, uint256 _amount, KycProvider.Investor _investor) {
        require(_investor.jurisdiction == US);
        require(_investor.data[0] & ACCREDITED_INVESTOR != 0, "investor is not accredited");
    }
}
