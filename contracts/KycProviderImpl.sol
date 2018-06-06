pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "@daonomic/util/contracts/SecuredImpl.sol";
import "@daonomic/util/contracts/OwnableImpl.sol";
import "./KycProvider.sol";

/**
 * @title KYC provider implementation
 * @dev Represents KYC oracle. Owner or Operator can set data for every investor after offchain data validation
 */
contract KycProviderImpl is OwnableImpl, SecuredImpl, KycProvider {
    mapping(address => Investor) data;
    event DataChange(address indexed addr, uint16 jurisdiction, bytes30 data);

    function resolve(address _address) constant public returns (Investor) {
        return data[_address];
    }

    function setData(address _address, uint16 _jurisdiction, bytes30 _data) ownerOr("operator") public {
        setDataInternal(_address, _jurisdiction, _data);
    }

    function setDataInternal(address _address, uint16 _jurisdiction, bytes30 _data) internal {
        data[_address] = Investor(_jurisdiction, _data);
        emit InvestorCheck(_address);
        emit DataChange(_address, _jurisdiction, _data);
    }
}
