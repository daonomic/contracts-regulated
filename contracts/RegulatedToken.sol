pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "@daonomic/tokens/contracts/MintableTokenImpl.sol";
import "./RegulationRule.sol";
import "./KycProvider.sol";

contract RegulatedToken is HasInvestor, MintableTokenImpl {
    /**
     * @dev Mapping from jurisdiction to RegulationRule address
     */
    mapping(uint128 => address) public rules;

    /**
     * @dev Known investors
     */
    mapping(address => Investor) public investors;

    /**
     * @dev Trusted KYC providers
     */
    address[] public kycProviders;

    function setRule(uint128 _jurisdiction, address _address) onlyOwner public {
        rules[_jurisdiction] = _address;
    }

    function setKycProviders(address[] _kycProviders) onlyOwner public {
        kycProviders = _kycProviders;
    }

    /**
     * @dev Function to mint tokens
     * @dev Checks if investor is able to receive tokens (according to RegulationRule)
     */
    function mint(address _to, uint256 _amount) public returns (bool) {
        Investor memory investor = getInvestor(_to);
        require(investor.jurisdiction != 0, "Investor didn't pass KYC");
        address ruleAddress = rules[investor.jurisdiction];
        require(ruleAddress != address(0), "Investor's jurisdiction not supported");
        RegulationRule(ruleAddress).onMint(_to, _amount, investor);
        return super.mint(_to, _amount);
    }

    /**
     * @dev Get investor from mapping or find from KYC providers
     * @dev saves investor in investors mapping if found
     */
    function getInvestor(address _address) public returns (Investor) {
        KycProvider.Investor memory investor = investors[_address];
        if (investor.jurisdiction != 0) {
            return investor;
        }
        for (uint256 i = 0; i < kycProviders.length; i++) {
            investor = KycProvider(kycProviders[i]).resolve(_address);
            if (investor.jurisdiction != 0) {
                investors[_address] = investor;
                return investor;
            }
        }
        return investor;
    }
}
