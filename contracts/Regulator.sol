pragma solidity ^0.4.23;

contract Regulator {
    function onMint(address to, uint256 amount);
    function onTransferFrom(address from, address to, uint256 amount);
    function onTransferTo(address from, address to, uint256 amount);
}
