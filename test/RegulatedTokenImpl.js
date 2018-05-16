const AllowRule = artifacts.require('AllowRegulationRule.sol');
const DenyRule = artifacts.require('DenyRegulationRule.sol');
const Kyc = artifacts.require('TestKycProvider.sol');
const Token = artifacts.require('TestRegulatedToken.sol');
const RegulatorServiceImpl = artifacts.require('RegulatorServiceImpl.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("RegulatedTokenImpl", accounts => {
  async function instantiate(investor, Rule) {
    var rule = await Rule.new();
    var kyc = await Kyc.new(investor, 1, "0x0");
    var regulator = await RegulatorServiceImpl.new();
    var token = await Token.new(regulator.address);
    return {token: token, investor: investor, rule: rule, kyc: kyc, regulator: regulator};
  }

  async function prepare(investor, Rule) {
    var init = await instantiate(investor, Rule);

    await init.regulator.setKycProviders(init.token.address, [init.kyc.address]);
    await init.regulator.setRule(init.token.address, 1, init.rule.address);
    return init;
  }

  it("should let mint if allowed by rule", async () => {
    var init = await prepare(randomAddress(), AllowRule);
    var tx = await init.token.mint(init.investor, 100);
//    console.log(tx.receipt.gasUsed);
  });

  it("should not let mint if denied by rule", async () => {
    var init = await prepare(randomAddress(), DenyRule);
    await expectThrow(
        init.token.mint(init.investor, 100)
    );
  });

  it("should not let mint if user didn't pass KYC", async () => {
    var init = await prepare(randomAddress(), AllowRule);
    await expectThrow(
        init.token.mint(randomAddress(), 100)
    );
  });

  it("should not let mint if rule not found by investor jurisdiction", async () => {
    var init = await instantiate(randomAddress(), AllowRule);
    await init.regulator.setKycProviders(init.token.address, [init.kyc.address]);
    await init.regulator.setRule(init.token.address, 2, init.rule.address);
    await expectThrow(
        init.token.mint(init.investor, 100)
    );
  });

  it("should let transfer from one investor to another", async () => {
    var init = await prepare(accounts[1], AllowRule);
    var kyc = await Kyc.new(accounts[2], 1, "0x0");
    await init.regulator.setKycProviders(init.token.address, [init.kyc.address, kyc.address]);

    await init.token.mint(init.investor, 100);
    await init.token.transfer(accounts[2], 10, {from: accounts[1]});
    assert.equal(await init.token.balanceOf(accounts[1]), 90);
    assert.equal(await init.token.balanceOf(accounts[2]), 10);
  });

  it("should not let transfer to unknown investor", async () => {
    var init = await prepare(accounts[1], AllowRule);

    await init.token.mint(init.investor, 100);
    await expectThrow(
        init.token.transfer(accounts[2], 10, {from: accounts[1]})
    );
    assert.equal(await init.token.balanceOf(accounts[1]), 100);
    assert.equal(await init.token.balanceOf(accounts[2]), 0);
  });

  it("should let transferFrom from one investor to another", async () => {
    var init = await prepare(accounts[1], AllowRule);
    var kyc = await Kyc.new(accounts[2], 1, "0x0");
    await init.regulator.setKycProviders(init.token.address, [init.kyc.address, kyc.address]);

    await init.token.mint(init.investor, 100);
    await init.token.approve(accounts[0], 10, {from: accounts[1]});
    await init.token.transferFrom(accounts[1], accounts[2], 10);
    assert.equal(await init.token.balanceOf(accounts[1]), 90);
    assert.equal(await init.token.balanceOf(accounts[2]), 10);
  });

  it("should not let transferFrom to unknown investor", async () => {
    var init = await prepare(accounts[1], AllowRule);

    await init.token.mint(init.investor, 100);
    await init.token.approve(accounts[0], 10, {from: accounts[1]});
    await expectThrow(
        init.token.transferFrom(accounts[1], accounts[2], 10)
    );
    assert.equal(await init.token.balanceOf(accounts[1]), 100);
    assert.equal(await init.token.balanceOf(accounts[2]), 0);
  });

  it("should check if investor is able to receive tokens", async () => {
    var init = await prepare(randomAddress(), AllowRule);

    assert.equal(await init.token.ableToReceive(init.investor, 100), true);
    assert.equal(await init.token.ableToReceive(randomAddress(), 100), false);
  });
});
