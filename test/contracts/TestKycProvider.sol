pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;


import "@daonomic/interfaces/contracts/KycProvider.sol";


contract TestKycProvider is KycProvider {
    address public investor;
    uint16 public jurisdiction;
    bytes30 public data;

    constructor(address _investor, uint16 _jurisdiction, bytes30 _data) public {
        investor = _investor;
        jurisdiction = _jurisdiction;
        data = _data;
    }

    function resolve(address _address) constant public returns (Investor) {
        if (_address == investor) {
            return Investor(jurisdiction, data);
        } else {
            return Investor(0, 0x0);
        }
    }
}
