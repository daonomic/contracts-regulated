pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./HasInvestor.sol";

/**
 * @title KYC provider
 * @dev Represents KYC oracle. Every KYC provider should implement this to work with security tokens
 */
contract KycProvider is HasInvestor {

    event InvestorCheck(address addr);

    /**
     * @dev resolve investor address
     * @param _address Investor's Ethereum address
     * @return struct representing investor - its jurisdiction and some generic data
     */
    function resolve(address _address) constant public returns (Investor);
}
