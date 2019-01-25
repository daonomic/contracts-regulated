pragma solidity ^0.5.0;

contract RegulatorService {
    function canReceive(address _address, uint256 amount) view public returns (bool);
    function canSend(address _address, uint256 amount) view public returns (bool);
    function canMint(address _to, uint256 amount) view public returns (bool);
    function canTransfer(address _from, address _to, uint256 amount) view public returns (bool);
}
