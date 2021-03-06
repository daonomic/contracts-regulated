pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./RegulationRule.sol";
import "./RegulatedToken.sol";
import "./RegulatorService.sol";

contract RegulatedTokenImpl is Ownable, RegulatedToken, HasInvestor, ERC20 {
    RegulatorService public regulatorService;

    event RegulatorServiceChanged(address regulatorService);

    constructor(RegulatorService _regulatorService) public {
        regulatorService = _regulatorService;
    }

    function canReceive(address _address, uint256 _amount) view public returns (bool) {
        return regulatorService.canReceive(_address, _amount);
    }

    function canSend(address _address, uint256 _amount) view public returns (bool) {
        return regulatorService.canSend(_address, _amount);
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
        emit RegulatorServiceChanged(address(_regulatorService));
    }
}
