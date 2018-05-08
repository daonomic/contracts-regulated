pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./HasInvestor.sol";
import "./KycProvider.sol";
import "./RegulationRule.sol";

contract Regulator is HasInvestor {
    /**
     * @dev Mapping from jurisdiction to RegulationRule address
     */
    mapping(address => mapping(uint128 => address)) public rules;

    /**
     * @dev Known investors
     */
    mapping(address => mapping(address => Investor)) public investors;

    /**
     * @dev Trusted KYC providers
     */
    mapping(address => address[]) public kycProviders;

    function setRule(uint128 _jurisdiction, address _address) public {
        rules[msg.sender][_jurisdiction] = _address;
    }

    function setKycProviders(address[] _kycProviders) public {
        kycProviders[msg.sender] = _kycProviders;
    }

    function onMint(address _to, uint256 _amount) public {
        Investor memory investor = getInvestor(_to);
        require(investor.jurisdiction != 0, "Investor didn't pass KYC");
        address ruleAddress = rules[msg.sender][investor.jurisdiction];
        require(ruleAddress != address(0), "Investor's jurisdiction not supported");
        RegulationRule(ruleAddress).onMint(_to, _amount, investor);
    }

    /**
     * @dev Get investor from mapping or find from KYC providers
     * @dev saves investor in investors mapping if found
     */
    function getInvestor(address _address) public returns (Investor) {
        Investor memory investor = investors[msg.sender][_address];
        if (investor.jurisdiction != 0) {
            return investor;
        }
        for (uint256 i = 0; i < kycProviders[msg.sender].length; i++) {
            investor = KycProvider(kycProviders[msg.sender][i]).resolve(_address);
            if (investor.jurisdiction != 0) {
                investors[msg.sender][_address] = investor;
                return investor;
            }
        }
        return investor;
    }
}
