pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;


import "@daonomic/util/contracts/OwnableImpl.sol";
import "@daonomic/interfaces/contracts/KycProvider.sol";
import "@daonomic/interfaces/contracts/Whitelist.sol";
import "@daonomic/util/contracts/SecuredImpl.sol";
import "./Jurisdictions.sol";


contract WhitelistKycProvider is Jurisdictions, OwnableImpl, SecuredImpl, Whitelist, KycProvider {
  mapping(address => bool) whitelist;

  function resolve(address _address) constant public returns (Investor) {
    if (isInWhitelist(_address)) {
      return Investor(OTHER, "");
    } else {
      return Investor(0, "");
    }
  }

  function isInWhitelist(address addr) constant public returns (bool) {
    return whitelist[addr];
  }

  function addToWhitelist(address[] _addresses) ownerOr("operator") public {
    for (uint i = 0; i < _addresses.length; i++) {
      setWhitelistInternal(_addresses[i], true);
    }
  }

  function removeFromWhitelist(address[] _addresses) ownerOr("operator") public {
    for (uint i = 0; i < _addresses.length; i++) {
      setWhitelistInternal(_addresses[i], false);
    }
  }

  function setWhitelist(address addr, bool allow) ownerOr("operator") public {
    setWhitelistInternal(addr, allow);
  }

  function setWhitelistInternal(address addr, bool allow) internal {
    whitelist[addr] = allow;
    emit InvestorCheck(addr);
  }
}
