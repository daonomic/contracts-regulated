pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../../contracts/RegulatedMintableTokenImpl.sol";


contract TestRegulatedToken is Ownable, RegulatedMintableTokenImpl {
    constructor(RegulatorService _regulatorService) RegulatedMintableTokenImpl (_regulatorService) public {

    }
}
