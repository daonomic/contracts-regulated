pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./HasInvestor.sol";

contract InvestorDataProvider is HasInvestor {
    event InvestorCheck(address addr);

    /**
     * @dev resolve investor address
     * @param _address Investor's Ethereum address
     * @return struct representing investor - its jurisdiction and some generic data
     */
    function resolve(address _address) view public returns (Investor memory);
}
