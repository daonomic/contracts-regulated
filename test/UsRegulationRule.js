var UsRegulationRule = artifacts.require('UsRegulationRule.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("UsRegulationRule", accounts => {
  let rule;

  beforeEach(async function() {
    rule = await UsRegulationRule.new();
  });


  it("should let receive if investor is accredited", async () => {
    assert.equal(await rule.canReceiveTest.call(randomAddress(), randomInt(1000), 1, "0xf0"), true);
  });

  it("should not let receive if investor is not accredited", async () => {
    assert.equal(await rule.canReceiveTest.call(randomAddress(), randomInt(1000), 1, "0x0"), false);
  });

  it("should let send to investor if accredited", async () => {
    assert.equal(await rule.canSendTest.call(randomAddress(), randomInt(1000), 1, "0xf0"), true);
  });

  it("should let send if investor is not accredited", async () => {
    assert.equal(await rule.canSendTest.call(randomAddress(), randomInt(1000), 1, "0x0"), true);
  });
});
