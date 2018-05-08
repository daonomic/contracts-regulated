pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";

contract HoldingPeriodRule is RegulationRule {
    function onMint(address _address, uint256 _amount, KycProvider.Investor investor) {

    }

    function onTransfer(address ) {

    }
}
