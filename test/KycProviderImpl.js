var KycProviderImpl = artifacts.require('KycProviderImpl.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("KycProviderImpl", accounts => {
  it("should emit InvestorCheck event", async () => {
    var kyc = await KycProviderImpl.new();

    var Event = kyc.InvestorCheck({});
    var address = randomAddress();
    var jurisdiction = randomInt(500);
    await kyc.setData(address, jurisdiction, "0x0");

    var event = await awaitEvent(Event);
    assert.equal(event.args.addr, address);
  });
});
