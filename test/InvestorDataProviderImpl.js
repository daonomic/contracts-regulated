var InvestorDataProviderImpl = artifacts.require('InvestorDataProviderImpl.sol');

const tests = require("@daonomic/tests-common");
const findLog = tests.findLog;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("InvestorDataProviderImpl", accounts => {
  it("should emit InvestorCheck event", async () => {
    var kyc = await InvestorDataProviderImpl.new();

    var address = randomAddress();
    var jurisdiction = randomInt(500);
    var tx = await kyc.setData(address, jurisdiction, "0x0");

    var event = findLog(tx, "InvestorCheck");
    assert.equal(event.args.addr.toLowerCase(), address);
  });
});
