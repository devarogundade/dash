<template>
<section>
    <div class="app-width">
        <div class="container">
            <div class="form">
                <div class="from input">
                    <input type="text" v-model="address" placeholder="Address" />
                    <div class="token" v-on:click="$nuxt.$emit('pick-faucet')">
                        <img :src="coin.image" alt="" />
                        <p>{{ coin.symbol }}</p>
                    </div>
                </div>

                <div class="price">Max Allocation: {{ coin.allocation }} {{ coin.symbol }}</div>

                <div class="action" v-if="!minting" v-on:click="faucetMint()">Mint</div>
                <div class="action" v-else>Minting..</div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
import stableCoins from "../../stablecoins.json";
export default {
    data() {
        return {
            address: '',
            fusdContract: null,
            usdtContract: null,
            usdcContract: null,
            dashContract: null,
            minting: false,
            coin: stableCoins[0]
        };
    },
    async created() {
        this.$contract.init()
        this.$faucet.init()

        const address = await this.$auth.connectToMetaMask()
        if (address != null) {
            this.address = address
        }

        $nuxt.$on('contract', (contract) => {
            this.contract = contract;
        });
        $nuxt.$on('faucet', (coin) => {
            this.coin = coin
        })

        $nuxt.$on('fusd-contract', (contract) => {
            this.fusdContract = contract
        })
        $nuxt.$on('usdc-contract', (contract) => {
            this.usdcContract = contract
        })
        $nuxt.$on('usdt-contract', (contract) => {
            this.usdtContract = contract
        })
        $nuxt.$on('dash-token-contract', (contract) => {
            this.dashContract = contract
        })
    },
    methods: {
        faucetMint: async function () {
            if (this.address == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter Address',
                    message: 'Enter a valid EVM address!'
                })
                return
            }

            this.minting = true;

            try {
                if (this.coin.symbol == 'tFUSD') {
                    await this.fusdContract.faucetMint({
                        from: this.address
                    })
                }
                if (this.coin.symbol == 'tUSDC') {
                    await this.usdcContract.faucetMint({
                        from: this.address
                    })
                }

                if (this.coin.symbol == 'tUSDT') {
                    await this.usdtContract.faucetMint({
                        from: this.address
                    })
                }

                if (this.coin.symbol == 'DASH') {
                    await this.dashContract.faucetMint({
                        from: this.address
                    })
                }

                $nuxt.$emit('success', {
                    title: 'Mint Successful',
                    message: `You have successfully mint ${this.coin.allocation} ${this.coin.symbol}!`
                })
            } catch (error) {
                console.log(error);
            }

            this.minting = false
        },
    },
};
</script>

<style scoped>
section {
    min-height: 90vh;
}

.container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    padding: 200px 0;
}

.form {
    width: 450px;
    border-radius: 30px;
    padding: 40px;
    box-shadow: 0 6px 10px #ccc;
    height: fit-content;
}

.input {
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    box-shadow: 0 4px 8px #ccc;
    border-radius: 10px;
    padding: 10px;
    margin-bottom: 20px;
}

.input input {
    width: 100%;
    background: transparent;
    font-size: 20px;
    font-weight: 600;
    padding-right: 20px;
    height: 100%;
    border: none;
    outline: none;
}

.input .token {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
    cursor: pointer;
    user-select: none;
}

.token img {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    object-fit: cover;
}

.price {
    margin: 30px 0;
    text-align: center;
    font-size: 18px;
}

.action {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    background: #1900b3;
    font-size: 16px;
    cursor: pointer;
    user-select: none;
    font-weight: 600;
    color: #ff9d05;
}
</style>
