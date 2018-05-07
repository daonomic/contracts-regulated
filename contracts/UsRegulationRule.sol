pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

import "./RegulationRule.sol";

contract UsRegulationRule is RegulationRule {
    event Test(bytes32 test);

    function onMint(address _address, uint256 _amount, KycProvider.Investor investor) {
        emit Test(investor.data & 0x0);
    }

    function onTransferFrom(address _from, address _to, uint256 _amount, KycProvider.Investor _from) {

    }

    function onTransferTo(address _from, address _to, uint256 _amount, KycProvider.Investor _to) {

    }
}
