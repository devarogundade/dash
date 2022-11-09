<template>
<section>
    <div class="header">
        <div class="i-app-width">
            <div class="text">
                <h3>Borrow Stable Coins from your contacts</h3>
                <h2>${{ Number($utils.fromWei(unpaid)).toFixed(2) }} Unpaid</h2>
                <div class="other">
                    <p>Total loans: {{ loans.length }}</p>
                    <router-link to="/">
                        <p>Leave App <i class="fi fi-br-arrow-up-right-from-square"></i></p>
                    </router-link>
                </div>
                <div class="search">
                    <div class="filter">
                        <i class="fi fi-br-search"></i>
                        <input type="text" placeholder="Search loans by token name">
                    </div>

                    <div class="go" v-on:click="$nuxt.$emit('success', {
                      title: 'Thank you!',
                      message: 'But this feature is under development.'
                    })">Search</div>
                </div>
            </div>
            <div class="image">
                <img src="/images/astronaut_borrow.png" alt="">
            </div>
        </div>
    </div>
    <Progress v-if="fetching" />
    <div class="body">
        <div class="i-app-width">
            <div class="learn">
                <p>I don't understand!</p>
                <a target="_blank" to="/how-to-use">
                    <div>Learn <i class="fi fi-br-arrow-right"></i></div>
                </a>
            </div>

            <div class="toolbar">
                <div class="tabs">
                    <div :class="tab == 1? 'item item-active' :'item'" v-on:click="tab = 1">All Loans</div>
                    <div :class="tab == 2? 'item item-active' :'item'" v-on:click="tab = 2">Paid</div>
                </div>

                <div class="balance">
                    <router-link to="/dapp/offers">
                        <div class="add"> <i class="fi fi-br-plus"></i> New Loan</div>
                    </router-link>
                </div>
            </div>

            <div class="pools" v-if="tab == 1">
                <div class="pool" v-for="(loan, index) in loans" :key="index">
                    <div class="top">
                        <div class="images">
                            <img :src="findCoin(loan.liquidity.tokenAddress).image" alt="" />
                        </div>
                        <p>{{ findCoin(loan.liquidity.tokenAddress).name }}</p>
                    </div>

                    <div class="apy">
                        <h3>{{ $utils.fromWei(loan.interestRate) }} DASH</h3>
                        <p>per 24h</p>
                    </div>

                    <div class="stats">
                        <div>
                            <p>Interest Token</p>
                            <img src="/images/dash-token.png" alt="" />
                        </div>

                        <div>
                            <p>Amount</p>
                            <p>{{ $utils.fromWei(loan.amount) }} {{ findCoin(loan.liquidity.tokenAddress).symbol }}</p>
                        </div>

                        <div>
                            <p>Interest / 24h</p>
                            <p>{{ $utils.fromWei(loan.interestRate) }}</p>
                        </div>

                        <div>
                            <p>Took on</p>
                            <p>{{ $utils.formatToDate(loan.createdAt * 1000) }}</p>
                        </div>

                        <div>
                            <p>Due date</p>
                            <p>{{ $utils.formatToDate((loan.createdAt * 1000) + (loan.duration * 24 * 3600 * 1000)) }}</p>
                        </div>

                        <div>
                            <p>Paid</p>
                            <p v-if="loan.paidAt > 0">{{ $utils.formatToDate(loan.paidAt * 1000) }}</p>
                            <p v-else>No</p>
                        </div>
                    </div>

                    <div class="action" v-if="loan.paidAt == 0" v-on:click="repayLoan(loan)">
                        <i class="fi fi-br-dollar"></i> {{ paying == loan.id ? 'Paying..' : 'Repay' }}
                    </div>

                    <div class="action paid" v-else>
                        <i class="fi fi-br-check"></i> Payed
                    </div>
                </div>
            </div>

            <div class="pools" v-if="tab == 2">
                <div class="pool" v-for="(loan, index) in paid()" :key="index">
                    <div class="top">
                        <div class="images">
                            <img :src="findCoin(loan.liquidity.tokenAddress).image" alt="" />
                        </div>
                        <p>{{ findCoin(loan.liquidity.tokenAddress).name }}</p>
                    </div>

                    <div class="apy">
                        <h3>{{ $utils.fromWei(loan.interestRate) }} DASH</h3>
                        <p>per 24h</p>
                    </div>

                    <div class="stats">
                        <div>
                            <p>Interest Token</p>
                            <img src="/images/dash-token.png" alt="" />
                        </div>

                        <div>
                            <p>Amount</p>
                            <p>{{ $utils.fromWei(loan.amount) }} {{ findCoin(loan.liquidity.tokenAddress).symbol }}</p>
                        </div>

                        <div>
                            <p>Interest / 24h</p>
                            <p>{{ $utils.fromWei(loan.interestRate) }}</p>
                        </div>

                        <div>
                            <p>Took on</p>
                            <p>{{ $utils.formatToDate(loan.createdAt * 1000) }}</p>
                        </div>

                        <div>
                            <p>Due date</p>
                            <p>{{ $utils.formatToDate((loan.createdAt * 1000) + (loan.duration * 24 * 3600 * 1000)) }}</p>
                        </div>

                        <div>
                            <p>Paid</p>
                            <p>{{ $utils.formatToDate(loan.paidAt * 1000) }}</p>
                        </div>
                    </div>

                    <div class="action paid">
                        <i class="fi fi-br-check"></i> Payed
                    </div>
                </div>
            </div>

            <div class="empty" v-if="loans.length == 0 && tab == 1">
                <img src="/images/astronaut_borrow.png" alt="">
                <p>No Loans!</p>
            </div>

            <div class="empty" v-if="paid().length == 0 && tab == 2">
                <img src="/images/astronaut_borrow.png" alt="">
                <p>No Paid Loans!</p>
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
            loans: [],
            address: null,
            coins: stableCoins,
            contract: null,
            paying: -1,
            unpaid: "0",
            fetching: true
        }
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        if (this.address != null) {
            this.getLoans()
        }

        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.contract = contract
        })
    },
    methods: {
        getLoans: async function () {
            this.loans = await this.$firestore.fetchAllLoans(
                this.address.toUpperCase()
            )
            this.loans.forEach(loan => {
                if (loan.paidAt == 0) {
                    this.unpaid += loan.amount
                }
            })
            this.fetching = false
        },

        paid: function () {
            return this.loans.filter(loan =>
                loan.paidAt > 0
            )
        },

        findCoin: function (address) {
            const coins = this.coins.filter(coin => coin.address.toUpperCase() == address.toUpperCase())
            if (coins.length == 0) return
            return coins[0]
        },

        repayLoan: async function (loan) {
            if (this.contract == null) return

            this.paying = loan.id

            try {
                await this.contract.payLoan(loan.id, {
                    from: this.address
                })

                $nuxt.$emit('success', {
                    title: 'Loan has been repayed',
                    message: 'Congratulations you have repayed your loan'
                })
            } catch (error) {
                console.log(error);
            }

            this.getLoans()
            this.paying = -1
        }
    }
}
</script>

<style scoped>
section {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
}

.header {
    height: 300px;
    width: 100%;
    display: flex;
    justify-content: center;
    background: #CF9EF5;
}

.header>.i-app-width {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
}

.header .image {
    height: 100%;
    display: flex;
    align-items: flex-end;
    padding-bottom: 20px;
}

.header img {
    height: 240px;
}

.header .text {
    padding: 40px 0;
}

.header .text h3 {
    font-size: 24px;
}

.header .text h2 {
    margin-top: 10px;
    font-size: 36px;
    color: #1900b3;
}

.other {
    display: flex;
    align-items: center;
    gap: 20px;
    margin-top: 10px;
}

.other p {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 500;
    color: #000;
}

.search {
    display: flex;
    gap: 20px;
    margin-top: 20px;
}

.filter {
    width: 350px;
    height: 50px;
    display: flex;
    align-items: center;
    border: 1px #000 solid;
    border-radius: 10px;
    gap: 10px;
    padding: 0 20px;
}

.filter input {
    border: none;
    outline: none;
    font-size: 16px;
    font-weight: 500;
    background: transparent;
    width: 100%;
}

.search .go {
    width: 160px;
    height: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #1900b3;
    background: #ff9d05;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
    gap: 10px;
    padding: 0 20px;
}

.body {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-top: 60px;
    padding-bottom: 60px;
}

.tabs {
    display: flex;
    align-items: center;
    background: #EEE;
    border-radius: 10px;
    width: fit-content;
}

.paid {
    background: #CCC !important;
    color: #000 !important;
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
    background: #CCC;
}

.toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 60px;
}

.balance {
    display: flex;
    align-items: center;
    gap: 10px;
}

.balance div {
    height: 40px;
    padding: 0 20px;
    border-radius: 10px;
    cursor: pointer;
    user-select: none;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    background: #ccc;
}

.balance div:first-child {
    background: #d2cbff;
    color: #1900b3;
}

.pools {
    display: flex;
    flex-wrap: wrap;
    margin-top: 40px;
    gap: 40px;
}

.pool {
    width: 360px;
    padding: 30px;
    background: #FAFAFA;
    box-shadow: 0 6px 10px #CCC;
    border: 1px;
    border-radius: 16px;
}

.pool .top {
    display: flex;
    align-items: center;
    gap: 10px;
}

.top img {
    width: 30px;
}

.top p {
    font-size: 16px;
    font-weight: 600;
}

.apy {
    text-align: center;
    margin-top: 20px;
}

.apy h3 {
    font-size: 24px;
}

.stats {
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    gap: 22px;
}

.stats>div {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.stats img {
    height: 20px;
}

.stats p:last-child {
    font-weight: 600;
}

.action {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 45px;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
    background: #1900b3;
    color: #ffffff;
    font-weight: 600;
    gap: 10px;
    font-size: 16px;
    position: relative;
    margin-top: 30px;
}

.action i {
    position: absolute;
    left: 20px;
}
</style>
