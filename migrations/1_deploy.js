/* contracts */
const Dash = artifacts.require("Dash");
const DashToken = artifacts.require("DashToken");
const FUSD = artifacts.require("FUSD");
const USDT = artifacts.require("USDT");
const USDC = artifacts.require("USDC");

/* fantom testnet */
module.exports = async function(deployer) {
    // deploy dash token
    await deployer.deploy(DashToken, "Dash Token", "DASH")

    // deploy dash smart contract
    await deployer.deploy(Dash, DashToken.address)

    // deploy stable coins
    await deployer.deploy(FUSD)
    await deployer.deploy(USDT)
    await deployer.deploy(USDC)
};