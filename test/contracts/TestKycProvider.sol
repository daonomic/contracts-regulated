pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "../../contracts/KycProvider.sol";

contract TestKycProvider is KycProvider {
    address public investor;
    uint128 public jurisdiction;
    bytes16 public data;

    constructor(address _investor, uint128 _jurisdiction, bytes16 _data) public {
        investor = _investor;
        jurisdiction = _jurisdiction;
        data = _data;
    }

    function resolve(address _address) public returns (Investor) {
        if (_address == investor) {
            return Investor(jurisdiction, data);
        } else {
            return Investor(0, 0x0);
        }
    }
}
