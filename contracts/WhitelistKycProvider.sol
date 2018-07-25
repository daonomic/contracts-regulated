pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;


import "@daonomic/util/contracts/OwnableImpl.sol";
import "@daonomic/interfaces/contracts/KycProvider.sol";
import "@daonomic/interfaces/contracts/Whitelist.sol";
import "./Jurisdictions.sol";


contract WhitelistKycProvider is Jurisdictions, OwnableImpl, Whitelist, KycProvider {
  mapping(address => bool) whitelist;

  function resolve(address _address) constant public returns (Investor) {
    if (isInWhitelist(_address)) {
      return Investor(ALLOWED, "");
    } else {
      return Investor(0, "");
    }
  }

  function isInWhitelist(address addr) constant public returns (bool) {
    return whitelist[addr];
  }

  function addToWhitelist(address[] _addresses) onlyOwner public {
    for (uint i = 0; i < _addresses.length; i++) {
      setWhitelistInternal(_addresses[i], true);
    }
  }

  function removeFromWhitelist(address[] _addresses) onlyOwner public {
    for (uint i = 0; i < _addresses.length; i++) {
      setWhitelistInternal(_addresses[i], false);
    }
  }

  function setWhitelist(address addr, bool allow) onlyOwner public {
    setWhitelistInternal(addr, allow);
  }

  function setWhitelistInternal(address addr, bool allow) internal {
    whitelist[addr] = allow;
    emit InvestorCheck(addr);
  }
}
