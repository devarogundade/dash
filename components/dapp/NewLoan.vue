<template>
<section>
    <Progress v-if="fetching" />
    <div class="i-app-width">
        <div class="container" v-if="liquidity">
            <div class="form">
                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        Loan
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'" v-on:click="tab = 2">
                        Provider
                    </div>
                </div>

                <div class="detail">
                    <div class="label">
                        <p>Available:</p>
                        <p>{{ $utils.fromWei(liquidity.amount) }} FUSD</p>
                    </div>
                    <div class="label">
                        <p>Take Out:</p>
                        <p>{{ $utils.fromWei(liquidity.minTakeOut) }} ~ {{ $utils.fromWei(liquidity.maxTakeOut) }} FUSD</p>
                    </div>
                    <div class="label">
                        <p>Minimum Credit Score:</p>
                        <p>{{ liquidity.minScore }}</p>
                    </div>
                    <div class="label">
                        <p>Duration:</p>
                        <p>{{ liquidity.minDays }} ~ {{ liquidity.maxDays }} days</p>
                    </div>
                    <div class="label">
                        <p>Interest per 24h:</p>
                        <p>{{ $utils.fromWei(liquidity.interestRate) }} DASH</p>
                    </div>
                </div>

                <div class="from input">
                    <input type="number" v-model="loan.amount" placeholder="Amount" />
                    <div class="token">
                        <img :src="coin.image" alt="" />
                        <p>{{ coin.symbol }}</p>
                    </div>
                </div>

                <div class="to input">
                    <input type="number" v-model="loan.duration" placeholder="Duration" />
                    <div class="token">
                        <p>Days</p>
                    </div>
                </div>

                <div class="price">1 FUSD = $1.00</div>

                <div class="action" v-if="!taking" v-on:click="takeLoan()">Take Loan</div>
                <div class="action" v-else>Taking..</div>
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
            tab: 1,
            liquidity: null,
            liquidityId: this.$route.params.liquidity,
            loan: {
                amount: '',
                duration: ''
            },
            contract: null,
            taking: false,
            coin: stableCoins[0],
            address: null,
            user: null,
            fetching: true
        };
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        this.getLiquidity()
        this.getUser()

        this.$contract.init();
        $nuxt.$on('contract', (contract) => {
            this.contract = contract;
        });
        $nuxt.$on('coin', (coin) => {
            this.coin = coin
        })
    },
    methods: {
        getUser: async function () {
            this.user = await this.$firestore.fetch('users', this.$auth.accounts[0].toUpperCase())
        },

        getLiquidity: async function () {
            this.liquidity = await this.$firestore.fetch('liquidities', this.liquidityId)

            if (this.liquidity == null) {
                $nuxt.$emit('failure', {
                    title: 'Liquidity does not exits',
                    message: 'This liquidity might have been closed!'
                })
            }
            this.fetching = false
        },

        takeLoan: async function () {
            if (this.contract == null) return
            if (this.loan.amount == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter loan amount',
                    message: 'Field is required'
                })
                return
            }
            if (this.loan.duration == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter loan duration',
                    message: 'Field is required'
                })
                return
            }
            if (this.user && this.user.activeLoan) {
                $nuxt.$emit('failure', {
                    title: 'You ca\'t take more loans',
                    message: 'You have an outstanding loan'
                })
                return
            }

            this.taking = true;

            try {
                const trx = await this.contract.takeLoan(
                    this.liquidityId,
                    this.$utils.toWei(this.loan.amount),
                    this.liquidity.address.toLowerCase(),
                    this.loan.duration, {
                        from: this.address
                    }
                );

                $nuxt.$emit('trx', trx)
                $nuxt.$emit('success', {
                    title: 'Loan has been taken',
                    message: 'You have successfully took a new loan!'
                })

                // reset inputs
                this.loan = {
                    amount: '',
                    duration: ''
                }
            } catch (error) {
                console.log(error);
            }

            this.taking = false
        },
    },
};
</script>

<style scoped>
.container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    padding: 50px 0;
}

.form {
    width: 450px;
    border-radius: 30px;
    padding: 40px;
    box-shadow: 0 6px 10px #ccc;
    height: fit-content;
}

.tabs {
    display: flex;
    align-items: center;
    border-radius: 10px;
    width: fit-content;
    margin-bottom: 40px;
}

.tabs .item {
    height: 40px;
    min-width: 60px;
    padding: 0 20px;
    display: flex;
    align-items: center;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
}

.item-active {
    background: #000;
    color: #ffffff;
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

.label {
    font-size: 16px;
    margin-bottom: 4px;
    font-weight: 600;
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
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    color: #ff9d05;
}

.detail {
    margin-bottom: 20px;
    border: 1px #ccc solid;
    border-radius: 10px;
}

.detail .label {
    border-bottom: 1px #ccc solid;
    padding: 10px;
    margin: 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
}

.detail .label:last-child {
    border: none;
}
</style>
