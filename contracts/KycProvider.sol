pragma solidity ^0.4.23;
import "./HasInvestor.sol";
pragma experimental ABIEncoderV2;

/**
 * @title KYC provider
 * @dev Represents KYC oracle. Every KYC provider should implement this to work with security tokens
 */
contract KycProvider is HasInvestor {

    /**
     * @dev resolve investor address
     * @param _address Investor's Ethereum address
     * @return struct representing investor - its jurisdiction and some generic data
     */
    function resolve(address _address) public returns (Investor);
}
