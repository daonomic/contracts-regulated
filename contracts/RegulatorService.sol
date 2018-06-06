pragma solidity ^0.4.23;

contract RegulatorService {
    function canReceive(address _address, uint256 amount) constant public returns (bool);
    function canSend(address _address, uint256 amount) constant public returns (bool);
    function canMint(address _to, uint256 amount) constant public returns (bool);
    function canTransfer(address _from, address _to, uint256 amount) constant public returns (bool);
}
