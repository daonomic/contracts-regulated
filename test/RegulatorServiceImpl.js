const AllowRule = artifacts.require('AllowRegulationRule.sol');
const DenyRule = artifacts.require('DenyRegulationRule.sol');
const RegulatorServiceImpl = artifacts.require('RegulatorServiceImpl.sol');
const KycProviderImpl = artifacts.require('KycProviderImpl.sol');
const Token = artifacts.require('TestRegulatedToken.sol');

const tests = require("@daonomic/tests-common");
const awaitEvent = tests.awaitEvent;
const expectThrow = tests.expectThrow;
const randomAddress = tests.randomAddress;
const randomInt = tests.randomInt;

contract("RegulatorServiceImpl", accounts => {
	let token;
	let testing;
	let allow;
	let kyc;

	beforeEach(async () => {
		testing = await RegulatorServiceImpl.new();
		token = await Token.new(testing.address);
		allow = await AllowRule.new();
		kyc = await KycProviderImpl.new();
	});

	it("should return true if allowed by Rule", async () => {
		await testing.setKycProviders(token.address, [kyc.address]);
		await testing.setRule(token.address, 2 ^ 16 - 2, allow.address);

		var address = randomAddress();
		await kyc.setData(address, 2 ^ 16 - 2, "0x");
		assert.equal(await testing.canMint(address, 1, {from: token.address}), true);
		assert.equal(await testing.canMint(address, 1, {from: randomAddress()}), false);
		assert.equal(await testing.canMint(randomAddress(), 1, {from: token.address}), false);
	});
});
