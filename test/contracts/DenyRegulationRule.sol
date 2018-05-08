pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "../../contracts/RegulationRule.sol";

contract DenyRegulationRule is RegulationRule {
    function onMint(address _address, uint256 _amount, Investor investor) public {
        revert();
    }

    function onTransferFrom(address _address, uint256 _amount, Investor _investor) public {
        revert();
    }

    function onTransferTo(address _address, uint256 _amount, Investor _investor) public {
        revert();
    }
}
