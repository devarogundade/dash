<template>
<section>
    <div class="i-app-width">
        <div class="container">
            <div class="form">
                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        Add
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'">
                        Import <span>Soon</span>
                    </div>
                </div>

                <div class="from input">
                    <input type="number" v-model="liquidity.amount" placeholder="Amount" />
                    <div class="token" v-on:click="$nuxt.$emit('pick-coin')">
                        <img :src="coin.image" alt="" />
                        <p>{{ coin.symbol }}</p>
                    </div>
                </div>

                <div class="to input">
                    <input type="number" min="0" v-model="liquidity.interest" placeholder="Interest rate / 24h" />
                    <div class="token">
                        <img src="/images/dash-token.png" alt="" />
                        <p>DASH</p>
                    </div>
                </div>

                <div class="label">Take out</div>
                <div class="flex">
                    <div class="to input">
                        <input type="number" min="0" v-model="liquidity.takeOut.min" placeholder="Min" />
                        <div class="token">
                            <p>{{ coin.symbol }}</p>
                        </div>
                    </div>
                    <div class="to input">
                        <input type="number" min="0" v-model="liquidity.takeOut.max" placeholder="Max" />
                        <div class="token">
                            <p>{{ coin.symbol }}</p>
                        </div>
                    </div>
                </div>

                <div class="label">Duration</div>
                <div class="flex">
                    <div class="to input">
                        <input type="number" min="0" v-model="liquidity.days.min" placeholder="Min" />
                        <div class="token">
                            <p>Days</p>
                        </div>
                    </div>
                    <div class="to input">
                        <input type="number" min="0" v-model="liquidity.days.max" placeholder="Max" />
                        <div class="token">
                            <p>Days</p>
                        </div>
                    </div>
                </div>

                <div class="label">Default credit score is 65</div>
                <div class="to input">
                    <input type="number" max="100" min="0" v-model="liquidity.minimumScore" placeholder="Minimum credit score" />
                    <div class="token" v-on:click="liquidity.minimumScore = 100">
                        <p>Max</p>
                    </div>
                </div>

                <div class="price">1 {{ coin.symbol }} = $1.00</div>

                <div class="action" v-if="!adding" v-on:click="addLiquidity()">Add To Liquidity</div>
                <div class="action" v-else>Adding..</div>
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
            liquidity: {
                amount: '',
                tokenAddress: '',
                interest: '',
                takeOut: {
                    min: '',
                    max: ''
                },
                days: {
                    min: '',
                    max: ''
                },
                minimumScore: ''
            },
            contract: null,
            adding: false,
            coin: stableCoins[0]
        };
    },
    async created() {
        this.$contract.init();
        $nuxt.$on('contract', (contract) => {
            this.contract = contract;
        });
        $nuxt.$on('coin', (coin) => {
            this.coin = coin
        })
    },
    methods: {
        addLiquidity: async function () {
            if (this.$auth.accounts.length == 0 || this.contract == null) return

            if (this.liquidity.amount == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter liquidity amount',
                    message: 'Field is required'
                })
                return
            }

            if (this.liquidity.interest == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter liquidity interest',
                    message: 'Field is required'
                })
                return
            }

            if (this.liquidity.takeOut.min == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter liquidity minimum take out',
                    message: 'Field is required'
                })
                return
            }

            if (this.liquidity.takeOut.max == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter liquidity maximum take out',
                    message: 'Field is required'
                })
                return
            }

            if (Number(this.liquidity.takeOut.min) > Number(this.liquidity.takeOut.max)) {
                $nuxt.$emit('failure', {
                    title: 'Minimum take out cannot be greater than maximum duration',
                    message: 'Field is required'
                })
                return
            }

            if (Number(this.liquidity.takeOut.max) > Number(this.liquidity.amount)) {
                $nuxt.$emit('failure', {
                    title: 'Maximum take out cannot be greater than liquidity amount',
                    message: 'Field is required'
                })
                return
            }

            if (this.liquidity.days.min == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter liquidity minimum duration',
                    message: 'Field is required'
                })
                return
            }

            if (this.liquidity.days.max == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter liquidity maximum duration in days',
                    message: 'Field is required'
                })
                return
            }

            if (Number(this.liquidity.days.min) > Number(this.liquidity.days.max)) {
                $nuxt.$emit('failure', {
                    title: 'Minimum duration cannot be greater than maximum duration',
                    message: 'Field is required'
                })
                return
            }

            if (this.liquidity.minimumScore == '') {
                $nuxt.$emit('failure', {
                    title: 'Enter minimum credit score',
                    message: 'Field is required'
                })
                return
            }

            this.adding = true;

            try {
                const trx = await this.contract.provideLiquidity(
                    this.$utils.toWei(this.liquidity.amount),
                    this.coin.address,
                    this.$utils.toWei(this.liquidity.interest),
                    this.$utils.toWei(this.liquidity.takeOut.min),
                    this.$utils.toWei(this.liquidity.takeOut.max),
                    this.liquidity.days.min,
                    this.liquidity.days.max,
                    this.liquidity.minimumScore, {
                        from: this.$auth.accounts[0]
                    }
                );

                $nuxt.$emit('trx', trx)
                $nuxt.$emit('success', {
                    title: 'Liquidity Added',
                    message: 'You have successfully added a new liquidity!'
                })

                // reset inputs
                this.liquidity = {
                    amount: '',
                    tokenAddress: '',
                    interest: '',
                    takeOut: {
                        min: '',
                        max: ''
                    },
                    days: {
                        min: '',
                        max: ''
                    },
                    minimumScore: ''
                }
            } catch (error) {
                console.log(error);
            }

            this.adding = false
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

.item span {
    padding: 2px 6px;
    background: #ff9d05;
    color: #ffffff;
    font-size: 12px;
    border-radius: 4px;
    margin-top: -20px;
    margin-left: 5px;
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
    color: #ff9d05;
    user-select: none;
    cursor: pointer;
}

.flex {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
}
</style>
