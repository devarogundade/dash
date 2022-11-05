/* contracts */
const FUSD = artifacts.require("FUSD");
const USDT = artifacts.require("USDT");
const USDC = artifacts.require("USDC");

/* fantom testnet */
module.exports = async function(deployer) {
    // deploy stable coins
    await deployer.deploy(FUSD, "Fantom USD", "tFUSD")
    await deployer.deploy(USDT, "USDC", "tUSDC")
    await deployer.deploy(USDC, "USDT", "tUSDT")
};