var Rule = artifacts.require('UsRegulationRule.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("UsRegulationRule", accounts => {
  it("should let mint if investor is accredited", async () => {
    var rule = await Rule.new();
    await rule.onMint(randomAddress(), randomInt(1000), 1, "0xf");
  });

  it("should not let mint if investor is not accredited", async () => {
    var rule = await Rule.new();
    await expectThrow(
        rule.onMint(randomAddress(), randomInt(1000), 1, "0x0")
    );
  });

  it("should let transfer to investor if accredited", async () => {
    var rule = await Rule.new();
    await rule.onTransferTo(randomAddress(), randomInt(1000), 1, "0xf");
  });

  it("should not let transfer if investor is not accredited", async () => {
    var rule = await Rule.new();
    await expectThrow(
        rule.onTransferTo(randomAddress(), randomInt(1000), 1, "0x0")
    );
  });


});
