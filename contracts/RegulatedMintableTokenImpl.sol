pragma solidity ^0.5.0;

import "@daonomic/interfaces/contracts/HasInvestor.sol";
import "@daonomic/tokens/contracts/MintableTokenImpl.sol";
import "./RegulationRule.sol";
import "./RegulatedToken.sol";
import "./RegulatorService.sol";

contract RegulatedMintableTokenImpl is RegulatedToken, HasInvestor, MintableTokenImpl {
    RegulatorService public regulatorService;

    constructor(RegulatorService _regulatorService) public {
        regulatorService = _regulatorService;
    }

    function canReceive(address _address, uint256 _amount) view public returns (bool) {
        return regulatorService.canReceive(_address, _amount);
    }

    function canSend(address _address, uint256 _amount) view public returns (bool) {
        return regulatorService.canSend(_address, _amount);
    }

    function mint(address _to, uint256 _amount) public returns (bool) {
        require(regulatorService.canMint(_to, _amount));
        return super.mint(_to, _amount);
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(regulatorService.canTransfer(msg.sender, _to, _value));
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(regulatorService.canTransfer(_from, _to, _value));
        return super.transferFrom(_from, _to, _value);
    }

    function setRegulatorService(RegulatorService _regulatorService) onlyOwner public {
        regulatorService = _regulatorService;
    }
}
