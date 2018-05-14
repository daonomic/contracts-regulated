pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./KycProvider.sol";
import "@daonomic/util/contracts/Secured.sol";

/**
 * @title KYC provider implementation
 * @dev Represents KYC oracle. Owner or Operator can set data for every investor after offchain data validation
 */
contract KycProviderImpl is Secured, KycProvider {
    mapping(address => Investor) data;
    event DataChange(address indexed addr, uint16 jurisdiction, bytes30 data);

    function resolve(address _address) public returns (Investor) {
        return data[_address];
    }

    function setData(address _address, uint16 _jurisdiction, bytes30 _data) ownerOr("operator") public {
        setDataInternal(_address, _jurisdiction, _data);
    }

    function setDataInternal(address _address, uint16 _jurisdiction, bytes30 _data) internal {
        data[_address] = Investor(_jurisdiction, _data);
        emit DataChange(_address, _jurisdiction, _data);
    }
}
