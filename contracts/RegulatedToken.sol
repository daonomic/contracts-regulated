pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "@daonomic/tokens/contracts/MintableTokenImpl.sol";
import "./RegulationRule.sol";
import "./KycProvider.sol";
import "./Regulator.sol";

contract RegulatedToken is HasInvestor, MintableTokenImpl {
    Regulator public regulator;

    constructor(Regulator _regulator) public {
        regulator = _regulator;
    }

    function setRule(uint128 _jurisdiction, address _address) onlyOwner public {
        regulator.setRule(_jurisdiction, _address);
    }

    function setKycProviders(address[] _kycProviders) onlyOwner public {
        regulator.setKycProviders(_kycProviders);
    }

    /**
     * @dev Function to mint tokens
     * @dev Checks if investor is able to receive tokens (according to RegulationRule)
     */
    function mint(address _to, uint256 _amount) public returns (bool) {
        regulator.onMint(_to, _amount);
        return super.mint(_to, _amount);
    }
}
