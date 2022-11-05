/* contracts */
const Dash = artifacts.require("Dash");
const DashToken = artifacts.require("DashToken");

/* fantom testnet */
module.exports = async function(deployer) {
    // deploy dash token
    await deployer.deploy(DashToken, "Dash Token", "DASH")

    // deploy dash smart contract
    await deployer.deploy(Dash, DashToken.address)
};