var Rule = artifacts.require('UsRegulationRule.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("UsRegulationRule", accounts => {
  it("should let receive if investor is accredited", async () => {
    var rule = await Rule.new();
    assert.equal(await rule.canReceiveTest.call(randomAddress(), randomInt(1000), 1, "0xf"), true);
  });

  it("should not let receive if investor is not accredited", async () => {
    var rule = await Rule.new();
    assert.equal(await rule.canReceiveTest.call(randomAddress(), randomInt(1000), 1, "0x0"), false);
  });

  it("should let send to investor if accredited", async () => {
    var rule = await Rule.new();
    assert.equal(await rule.canSendTest.call(randomAddress(), randomInt(1000), 1, "0xf"), true);
  });

  it("should let send if investor is not accredited", async () => {
    var rule = await Rule.new();
    assert.equal(await rule.canSendTest.call(randomAddress(), randomInt(1000), 1, "0x0"), true);
  });
});
