pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./KycProvider.sol";

/**
 * @title Represents regulation rule (law)
 */
contract RegulationRule is HasInvestor {
    /**
     * @dev Regulated tokens should call this when new tokens are minted
     */
    function checkMint(address _address, uint256 _amount, Investor investor) public returns (bool);

    /**
     * @dev Regulated tokens should call this when tokens are to be transferred from investor's account
     */
    function checkTransferFrom(address _address, uint256 _amount, Investor _investor) public returns (bool);

    /**
     * @dev Regulated tokens should call this when tokens are to be transferred to investor's account
     */
    function checkTransferTo(address _address, uint256 _amount, Investor _investor) public returns (bool);



    /**
     * @dev only for tests. web3 doesn't support tuple encoding
     */
    function checkMintTest(address _address, uint256 _amount, uint16 _jurisdiction, bytes30 _data) public returns (bool) {
        return checkMint(_address, _amount, Investor(_jurisdiction, _data));
    }

    /**
     * @dev only for tests. web3 doesn't support tuple encoding
     */
    function checkTransferFromTest(address _address, uint256 _amount, uint16 _jurisdiction, bytes30 _data) public returns (bool) {
        return checkTransferFrom(_address, _amount, Investor(_jurisdiction, _data));
    }

    /**
     * @dev only for tests. web3 doesn't support tuple encoding
     */
    function checkTransferToTest(address _address, uint256 _amount, uint16 _jurisdiction, bytes30 _data) public returns (bool) {
        return checkTransferTo(_address, _amount, Investor(_jurisdiction, _data));
    }
}
