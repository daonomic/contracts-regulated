pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./HasInvestor.sol";


/**
 * @title Represents regulation rule (law)
 */
contract RegulationRule is HasInvestor {
    /**
     * @dev Regulated tokens should call this to check if investor can receive tokens
     */
    function canReceive(address _address, uint256 _amount, Investor memory _investor) view public returns (bool);

    /**
     * @dev Regulated tokens should call this to check if investor can send tokens
     */
    function canSend(address _address, uint256 _amount, Investor memory _investor) view public returns (bool);



    /**
     * @dev only for tests. web3 doesn't support tuple encoding
     */
    function canReceiveTest(address _address, uint256 _amount, uint16 _jurisdiction, bytes30 _data) view public returns (bool) {
        return canReceive(_address, _amount, Investor(_jurisdiction, _data));
    }

    /**
     * @dev only for tests. web3 doesn't support tuple encoding
     */
    function canSendTest(address _address, uint256 _amount, uint16 _jurisdiction, bytes30 _data) view public returns (bool) {
        return canSend(_address, _amount, Investor(_jurisdiction, _data));
    }
}
