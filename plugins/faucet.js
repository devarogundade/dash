import Vue from "vue"
import contract from 'truffle-contract'

import FUSDContract from "../build/contracts/FUSD.json"
import USDTContract from "../build/contracts/USDT.json"
import USDCContract from "../build/contracts/USDC.json"
import DashTokenContract from "../build/contracts/DashToken.json"

const Contracts = {
    init: async function() {
        const fusdContract = contract(FUSDContract)
        const usdtContract = contract(USDTContract)
        const usdcContract = contract(USDCContract)
        const dashContract = contract(DashTokenContract)

        if (typeof ethereum === 'undefined') {
            $nuxt.$emit('failure', {
                title: 'Failed to connect',
                message: 'Use a ethereum browser'
            })
            return
        }

        fusdContract.setProvider(ethereum)
        usdtContract.setProvider(ethereum)
        usdcContract.setProvider(ethereum)
        dashContract.setProvider(ethereum)

        try {
            fusdContract.deployed().then(instance => {
                $nuxt.$emit('fusd-contract', instance)
            })
            usdtContract.deployed().then(instance => {
                $nuxt.$emit('usdt-contract', instance)
            })
            usdcContract.deployed().then(instance => {
                $nuxt.$emit('usdc-contract', instance)
            })
            dashContract.deployed().then(instance => {
                $nuxt.$emit('dash-token-contract', instance)
            })
        } catch (error) {}
    }
}

export default ({}, inject) => {
    inject('faucet', Vue.observable({
        init: async function() {
            await Contracts.init()
        }
    }))
}
