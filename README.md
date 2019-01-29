# Contracts for Regulated Tokens 

Regulated tokens essentially are ERC-20 tokens, but with additional checks for transfer/transferFrom functions.
These checks must be carried out to comply with different laws regarding securities in different countries.

# How it works

1. Investor identification is done using one or more Investor Data provider (https://github.com/daonomic/contracts-regulated/blob/master/contracts/InvestorDataProvider.sol)
2. After that different jurisdiction regulation rules are applied. If all checks pass, then transfer is allowed

![contracts](https://raw.githubusercontent.com/0v1se/draw/master/restricted.png)

# Investor Data provider

Investor Data provider is Oracle which has one function:

```solidity
    /**
     * @dev resolve investor address
     * @param _address Investor's Ethereum address
     * @return struct representing investor - its jurisdiction and some generic data
     */
    function resolve(address _address) public returns (Investor);
```

investor is declared as following:
```solidity
    struct Investor {
        uint16 jurisdiction;
        bytes30 data;
    }
```

- jurisdiction is jurisdiction id. Currently supported jurisdictions are stored here: https://github.com/daonomic/contracts-regulated/blob/master/contracts/Jurisdictions.sol
- data is arbitrary data (specific for investor's jurisdiction, for example, for US 1st bit of information tells if investor is accredited)

This data should be stored on-chain. 

## Supported providers
Our platform supports any KYC provider available:
- issuer can check investor's status by himself
- or select any present KYC provider (platform supports any KYC provider available with little or no development)

# Regulation rules

Excerpt from https://github.com/daonomic/contracts-regulated/blob/master/contracts/RegulationRule.sol:
```solidity
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
```

RegulationRule should define any logic specific for investor's jurisdiction. For example, if investor is from US, he must be accredited investor to buy tokens
(https://github.com/daonomic/contracts-regulated/blob/master/contracts/UsRegulationRule.sol)

# Support for Exchanges

One more function needed to provide better UX with regulated tokens exchange: Exchange should filter investors who can buy/sell regulated tokens. This can be done through simple check function:

```solidity
    /**
     * @dev Check if investor is able to receive token
     */
    function ableToReceive(address _address, uint256 _amount) constant public returns (bool);
```

Exchange should create/fill orders only for investors passing this check. Otherwise orders will fail on the fill step
