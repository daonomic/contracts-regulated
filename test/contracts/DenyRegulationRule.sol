pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "../../contracts/RegulationRule.sol";

contract DenyRegulationRule is RegulationRule {
    function checkMint(address _address, uint256 _amount, Investor investor) public returns (bool) {
        return false;
    }

    function checkTransferFrom(address _address, uint256 _amount, Investor _investor) public returns (bool) {
        return false;
    }

    function checkTransferTo(address _address, uint256 _amount, Investor _investor) public returns (bool) {
        return false;
    }
}
