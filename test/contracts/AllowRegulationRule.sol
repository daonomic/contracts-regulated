pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "../../contracts/RegulationRule.sol";

contract AllowRegulationRule is RegulationRule {
    function checkMint(address _address, uint256 _amount, Investor investor) public returns (bool) {
        return true;
    }

    function checkTransferFrom(address _address, uint256 _amount, Investor _investor) public returns (bool) {
        return true;
    }

    function checkTransferTo(address _address, uint256 _amount, Investor _investor) public returns (bool) {
        return true;
    }
}
