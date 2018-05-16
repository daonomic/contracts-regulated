pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "@daonomic/util/contracts/Ownable.sol";
import "./RegulatorService.sol";
import "./HasInvestor.sol";
import "./RegulationRule.sol";

contract RegulatorServiceImpl is HasInvestor, RegulatorService {
    /**
     * @dev Known investors
     */
    mapping(address => mapping(address => Investor)) public investors;

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

    function canReceive(address _address, uint256 _amount) public returns (bool) {
        var (investor, rule) = getInvestorAndRule(_address);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.check(_address, _amount, investor);
        }
    }

    function canMint(address _to, uint256 _amount) public returns (bool) {
        var (investor, rule) = getInvestorAndRule(_to);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.checkMint(_to, _amount, investor);
        }
    }

    function canTransfer(address _from, address _to, uint256 amount) public returns (bool) {
        var (from, ruleFrom) = getInvestorAndRule(_from);
        if (from.jurisdiction == 0) {
            return false;
        }
        if (!ruleFrom.checkTransferFrom(_from, _value, from)) {
            return false;
        }
        var (to, ruleTo) = getInvestorAndRule(_to);
        if (to.jurisdiction == 0) {
            return false;
        }
        return ruleTo.checkTransferTo(_to, _value, to);
    }

    function getInvestorAndRule(address _address) internal returns (Investor, RegulationRule) {
        Investor memory investor = getInvestor(_address);
        address ruleAddress = rules[msg.sender][investor.jurisdiction];
        return (investor, RegulationRule(ruleAddress));
    }

    /**
     * @dev Get investor from mapping or find from KYC providers
     * @dev saves investor in investors mapping if found
     */
    function getInvestor(address _address) internal returns (Investor) {
        Investor memory investor = investors[msg.sender][_address];
        if (investor.jurisdiction != 0) {
            return investor;
        }
        address[] memory tokenKycProviders = kycProviders[msg.sender];
        for (uint256 i = 0; i < tokenKycProviders.length; i++) {
            investor = KycProvider(tokenKycProviders[i]).resolve(_address);
            if (investor.jurisdiction != 0) {
                investors[msg.sender][_address] = investor;
                return investor;
            }
        }
        return investor;
    }

}