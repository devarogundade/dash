/* contracts */
const Dash = artifacts.require("Dash");
const DashToken = artifacts.require("DashToken");

/* fantom testnet */
module.exports = async function(deployer) {
    await deployer.deploy(DashToken, "Dash Token", "DASH")
    await deployer.deploy(Dash, DashToken.address)
};