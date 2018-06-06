pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "@daonomic/util/contracts/Ownable.sol";
import "./KycProvider.sol";
import "./RegulatorService.sol";
import "./HasInvestor.sol";
import "./RegulationRule.sol";

contract RegulatorServiceImpl is HasInvestor, RegulatorService {
    /**
     * @dev Mapping from jurisdiction to RegulationRule address
     */
    mapping(address => mapping(uint16 => address)) public rules;

    /**
     * @dev Trusted KYC providers
     */
    mapping(address => address[]) public kycProviders;

    function setRule(address _token, uint16 _jurisdiction, address _address) public {
        Ownable(_token).checkOwner(msg.sender);
        rules[_token][_jurisdiction] = _address;
    }

    function setKycProviders(address _token, address[] _kycProviders) public {
        Ownable(_token).checkOwner(msg.sender);
        kycProviders[_token] = _kycProviders;
    }

    function canReceive(address _address, uint256 _amount) constant public returns (bool) {
        (Investor memory investor, RegulationRule rule) = getInvestorAndRule(_address);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.canReceive(_address, _amount, investor);
        }
    }

    function canSend(address _address, uint256 _amount) constant public returns (bool) {
        (Investor memory investor, RegulationRule rule) = getInvestorAndRule(_address);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.canSend(_address, _amount, investor);
        }
    }

    function canMint(address _to, uint256 _amount) constant public returns (bool) {
        (Investor memory investor, RegulationRule rule) = getInvestorAndRule(_to);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.canReceive(_to, _amount, investor);
        }
    }

    function canTransfer(address _from, address _to, uint256 _amount) constant public returns (bool) {
        (Investor memory from, RegulationRule ruleFrom) = getInvestorAndRule(_from);
        if (from.jurisdiction == 0) {
            return false;
        }
        if (!ruleFrom.canSend(_from, _amount, from)) {
            return false;
        }
        (Investor memory to, RegulationRule ruleTo) = getInvestorAndRule(_to);
        if (to.jurisdiction == 0) {
            return false;
        }
        return ruleTo.canReceive(_to, _amount, to);
    }

    function getInvestorAndRule(address _address) constant internal returns (Investor, RegulationRule) {
        Investor memory investor = getInvestor(_address);
        address ruleAddress = rules[msg.sender][investor.jurisdiction];
        return (investor, RegulationRule(ruleAddress));
    }

    /**
     * @dev Get investor from mapping or find from KYC providers
     * @dev saves investor in investors mapping if found
     */
    function getInvestor(address _address) constant internal returns (Investor) {
        address[] memory tokenKycProviders = kycProviders[msg.sender];
        for (uint256 i = 0; i < tokenKycProviders.length; i++) {
            Investor memory investor = KycProvider(tokenKycProviders[i]).resolve(_address);
            if (investor.jurisdiction != 0) {
                return investor;
            }
        }
    }

}