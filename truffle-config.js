const HDWalletProvider = require('@truffle/hdwallet-provider')
const dotenv = require("dotenv")
dotenv.config()

const mnemonic = process.env.MNEMONIC;
const rpc_id = process.env.FANTOM_RPC_ID;

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1", // Ganache
            port: 7545,
            network_id: "*",
        },
        fantom: {
            provider: () => new HDWalletProvider(mnemonic, `https://rpc.ankr.com/fantom_testnet`),
            network_id: 4002, // fantom testnet id
            confirmations: 2,
            timeoutBlocks: 9999999,
            skipDryRun: true,
            networkCheckTimeout: 999999999
        },
    },

    mocha: {},

    compilers: {
        solc: {
            version: "0.8.16",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 1500
                }
            }
        }
    },

    plugins: ["truffle-contract-size"],
};