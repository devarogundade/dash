import Vue from "vue"
import contract from 'truffle-contract'

import contractJson from "../build/contracts/Dash.json"

const Contracts = {
    init: async function() {
        const dashContract = contract(contractJson)

        if (typeof ethereum === 'undefined') {
            $nuxt.$emit('failure', {
                title: 'Failed to connect',
                message: 'Use a ethereum browser'
            })
            return
        }

        dashContract.setProvider(ethereum)

        try {
            dashContract.deployed().then(instance => {
                $nuxt.$emit('contract', instance)
            })
        } catch (error) {}
    }
}

export default ({}, inject) => {
    inject('contract', Vue.observable({
        init: async function() {
            await Contracts.init()
        }
    }))
}