import Vue from "vue"

export default ({}, inject) => {
    inject('auth', Vue.observable({
        provider: null,
        accounts: [],

        connectWallet: async function() {
            if (typeof ethereum !== 'undefined') {
                $nuxt.$emit('connecting', `Connecting to metamask`)

                const address = await this.connectToMetaMask()
                if (address != null) {
                    $nuxt.$emit('connected', {
                        message: `Connected to ${address}`,
                        account: address
                    })
                } else {
                    $nuxt.$emit('failure', {
                        title: 'Failed to connect',
                        message: 'Use a ethereum browser'
                    })
                }
            } else {
                $nuxt.$emit('failure', {
                    title: 'Failed to connect',
                    message: 'Use a ethereum browser'
                })
            }
        },

        connectToMetaMask: async function() {
            try {
                await ethereum.request({
                    method: 'eth_requestAccounts'
                });
                this.provider = ethereum

                this.setUpAccountListeners(ethereum)
                await this.switchToFantomTestnet()

                this.accounts = await ethereum.enable();
                return this.accounts[0]
            } catch (error) {
                $nuxt.$emit('error', error.message)
                return null
            }
        },

        setUpAccountListeners: function(provider) {
            provider.on("accountsChanged", (accounts) => {
                this.accounts = accounts
                if (accounts.length == 0) {
                    $nuxt.$emit('disconnected')
                }
            });

            provider.on("chainChanged", (chainId) => {
                $nuxt.$emit('chain-changed', chainId)
            });
        },

        switchToFantomTestnet: async function() {
            try {
                await window.ethereum.request({
                    method: 'wallet_switchEthereumChain',
                    params: [{ chainId: '0xfa2' }],
                });
            } catch (error) {
                if (error.code === 4902) {
                    try {
                        await window.ethereum.request({
                            method: 'wallet_addEthereumChain',
                            params: [{
                                chainId: '0xfa2',
                                chainName: 'Fantom - Testnet',
                                nativeCurrency: {
                                    name: 'Fantom',
                                    symbol: 'FTM',
                                    decimals: 18
                                },
                                blockExplorerUrls: ['https://testnet.ftmscan.com'],
                                rpcUrls: ['https://fantom-testnet.public.blastapi.io'],
                            }, ],
                        });
                    } catch (addError) {
                        console.error(addError);
                    }
                }
            }
        },

    }))
}