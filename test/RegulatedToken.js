var AllowRule = artifacts.require('AllowRegulationRule.sol');
var DenyRule = artifacts.require('DenyRegulationRule.sol');
var Kyc = artifacts.require('TestKycProvider.sol');
var Token = artifacts.require('TestRegulatedToken.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("RegulatedToken", accounts => {
  async function instantiate(Rule) {
    var investor = randomAddress();
    var rule = await Rule.new();
    var kyc = await Kyc.new(investor, 1, "0x0");
    var token = await Token.new();
    return {token: token, investor: investor, rule: rule, kyc: kyc};
  }

  async function prepare(Rule) {
    var init = await instantiate(Rule);

    await init.token.setKycProviders([init.kyc.address]);
    await init.token.setRule(1, init.rule.address);
    return init;
  }

  it("should let mint if allowed by rule", async () => {
    var init = await prepare(AllowRule);
    await init.token.mint(init.investor, 100);
  });

  it("should not let mint if denied by rule", async () => {
    var init = await prepare(DenyRule);
    await expectThrow(
        init.token.mint(init.investor, 100)
    );
  });

  it("should not let mint if user didn't pass KYC", async () => {
    var init = await prepare(AllowRule);
    await expectThrow(
        init.token.mint(randomAddress(), 100)
    );
  });

  it("should not let mint if no rule found", async () => {
    var init = await instantiate(AllowRule);
    await init.token.setKycProviders([init.kyc.address]);
    await init.token.setRule(2, init.rule.address);
    await expectThrow(
        init.token.mint(init.investor, 100)
    );
  });

});
