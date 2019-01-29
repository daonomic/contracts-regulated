pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


import "../../contracts/InvestorDataProvider.sol";


contract TestInvestorDataProvider is InvestorDataProvider {
    address public investor;
    uint16 public jurisdiction;
    bytes30 public data;

    constructor(address _investor, uint16 _jurisdiction, bytes30 _data) public {
        investor = _investor;
        jurisdiction = _jurisdiction;
        data = _data;
    }

    function resolve(address _address) view public returns (Investor memory) {
        if (_address == investor) {
            return Investor(jurisdiction, data);
        } else {
            return Investor(0, 0x0);
        }
    }
}
