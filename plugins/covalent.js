import Vue from "vue";

export default ({ $axios }, inject) => {
    inject('covalent', Vue.observable({
        chainId: 4002, // fantom testnet chain id
        getTokenBalances: async function(address) {
            try {
                const options = {
                    method: 'GET',
                    url: `${this.chainId}/address/${address}/balances_v2/`,
                    params: {
                        'quote-currency': 'USD',
                        'format': 'JSON',
                        'nft': false,
                        'no-nft-fetch': false,
                        'key': process.env.COVALENT_API_KEY
                    }
                }

                const response = await $axios.request(options)
                return response.data
            } catch (error) {
                return null
            }
        }
    }))
}
