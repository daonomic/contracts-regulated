pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./InvestorDataProvider.sol";
import "./RegulatorService.sol";
import "./RegulationRule.sol";


contract RegulatorServiceImpl is HasInvestor, RegulatorService {
    event RuleSet(address indexed token, uint16 jurisdiction, address rule);
    event InvestorDataProvidersSet(address indexed token, address[] providers);

    /**
     * @dev Mapping from jurisdiction to RegulationRule address
     */
    mapping(address => mapping(uint16 => address)) public rules;

    /**
     * @dev Trusted KYC providers
     */
    mapping(address => address[]) public investorDataProviders;

    function setRule(address _token, uint16 _jurisdiction, address _address) public {
        require(Ownable(_token).owner() == msg.sender, "not owner of the token");
        rules[_token][_jurisdiction] = _address;
        emit RuleSet(_token, _jurisdiction, _address);
    }

    function getInvestorDataProviders(address _token) view public returns (address[] memory) {
        return investorDataProviders[_token];
    }

    function setInvestorDataProviders(address _token, address[] memory _investorDataProviders) public {
        require(Ownable(_token).owner() == msg.sender, "not owner of the token");
        investorDataProviders[_token] = _investorDataProviders;
        emit InvestorDataProvidersSet(_token, _investorDataProviders);
    }

    function canReceive(address _address, uint256 _amount) view public returns (bool) {
        (Investor memory investor, RegulationRule rule) = getInvestorAndRule(_address);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.canReceive(_address, _amount, investor);
        }
    }

    function canSend(address /*_address*/, uint256 /*_amount*/) view public returns (bool) {
        return true;
    }

    function canMint(address _to, uint256 _amount) view public returns (bool) {
        (Investor memory investor, RegulationRule rule) = getInvestorAndRule(_to);
        if (investor.jurisdiction == 0) {
            return false;
        } else {
            return rule.canReceive(_to, _amount, investor);
        }
    }

    function canTransfer(address /*_from*/, address _to, uint256 _amount) view public returns (bool) {
        (Investor memory to, RegulationRule ruleTo) = getInvestorAndRule(_to);
        if (to.jurisdiction == 0) {
            return false;
        }
        return ruleTo.canReceive(_to, _amount, to);
    }

    function getInvestorAndRule(address _address) view internal returns (Investor memory, RegulationRule) {
        Investor memory investor = getInvestor(_address);
        address ruleAddress = rules[msg.sender][investor.jurisdiction];
        return (investor, RegulationRule(ruleAddress));
    }

    /**
     * @dev Get investor from mapping or find from KYC providers
     * @dev saves investor in investors mapping if found
     */
    function getInvestor(address _address) view internal returns (Investor memory) {
        address[] memory tokenInvestorDataProviders = investorDataProviders[msg.sender];
        for (uint256 i = 0; i < tokenInvestorDataProviders.length; i++) {
            Investor memory investor = InvestorDataProvider(tokenInvestorDataProviders[i]).resolve(_address);
            if (investor.jurisdiction != 0) {
                return investor;
            }
        }
    }

}