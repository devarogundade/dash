<template>
<section>
    <div class="header">
        <div class="i-app-width">
            <div class="text">
                <h3>Provide Liquidity, EARN $DASH</h3>
                <h2>Earnings: {{ $utils.fromWei(earnings) }} DASH per 24h</h2>
                <div class="other">
                    <p>Active Liquidities: {{ liquidities.length }}</p>
                    <router-link to="/">
                        <p>
                            Leave App <i class="fi fi-br-arrow-up-right-from-square"></i>
                        </p>
                    </router-link>
                </div>
                <div class="search">
                    <div class="filter">
                        <i class="fi fi-br-search"></i>
                        <input type="text" placeholder="Search liquidities by token name" />
                    </div>

                    <div class="go" v-on:click="$nuxt.$emit('success', {
                      title: 'Thank you!',
                      message: 'But this feature is under development.'
                    })">Search</div>
                </div>
            </div>
            <div class="image">
                <img src="/images/astronaut_liquidity.png" alt="" />
            </div>
        </div>
    </div>
    <Progress v-if="fetching" />
    <div class="body">
        <div class="i-app-width">
            <div class="learn">
                <p>I don't understand!</p>
                <router-link to="/how-to-use">
                    <div>Learn <i class="fi fi-br-arrow-right"></i></div>
                </router-link>
            </div>

            <div class="toolbar">
                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        All liquidities
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'" v-on:click="tab = 2">
                        Dust
                    </div>
                </div>

                <div class="balance">
                    <router-link to="/dapp/add-liquidity">
                        <div class="add"> <i class="fi fi-br-plus"></i> Add Liquidity</div>
                    </router-link>
                    <div class="add remove" v-if="liquidities.length > 0" v-on:click="$nuxt.$emit('success', {
                      title: 'Want to close a liquidity?',
                      message: 'Click the close button on the liquidity',
                    })"><i class="fi fi-sr-trash"></i> Remove Liquidity</div>
                </div>
            </div>

            <div class="pools" v-if="tab == 1">
                <div class="pool" v-for="(liquidity, index) in liquidities" :key="index">
                    <div class="top">
                        <div class="images">
                            <img :src="findCoin(liquidity.tokenAddress).image" alt="" />
                        </div>
                        <p>{{ findCoin(liquidity.tokenAddress).name }}</p>
                    </div>

                    <div class="apy">
                        <h3>{{ $utils.fromWei(liquidity.interestRate) }} DASH</h3>
                        <p>per 24h</p>
                    </div>

                    <div class="stats">
                        <div>
                            <p>Reward Token</p>
                            <img src="/images/dash-token.png" alt="" />
                        </div>

                        <div>
                            <p>Interest / 24h</p>
                            <p>{{ $utils.fromWei(liquidity.interestRate) }} DASH</p>
                        </div>

                        <div>
                            <p>Available Balance</p>
                            <p>{{ $utils.fromWei(liquidity.amount) }} {{ findCoin(liquidity.tokenAddress).symbol }}</p>
                        </div>

                        <div>
                            <p>Take Out</p>
                            <p>{{ $utils.fromWei(liquidity.minTakeOut) }} ~ {{ $utils.fromWei(liquidity.maxTakeOut)}} {{ findCoin(liquidity.tokenAddress).symbol }}</p>
                        </div>

                        <div>
                            <p>Min Credit Score</p>
                            <p>{{ liquidity.minScore }}</p>
                        </div>
                    </div>

                    <div class="action" v-if="!liquidity.closed" v-on:click="closeLiquidity(liquidity.id)">
                        <i class="fi fi-br-pause"></i> {{ closing == liquidity.id ? 'Closing..' : 'Close' }}
                    </div>

                    <div class="action closed" v-else>
                        <i class="fi fi-br-ban"></i> Closed
                    </div>
                </div>
            </div>

            <div class="pools" v-if="tab == 2">
                <div class="pool" v-for="(liquidity, index) in dusts()" :key="index">
                    <div class="top">
                        <div class="images">
                            <img :src="findCoin(liquidity.tokenAddress).image" alt="" />
                        </div>
                        <p>{{ findCoin(liquidity.tokenAddress).name }}</p>
                    </div>

                    <div class="apy">
                        <h3>{{ $utils.fromWei(liquidity.interestRate) }} DASH</h3>
                        <p>per 24h</p>
                    </div>

                    <div class="stats">
                        <div>
                            <p>Reward Token</p>
                            <img src="/images/dash-token.png" alt="" />
                        </div>

                        <div>
                            <p>Interest / 24h</p>
                            <p>{{ $utils.fromWei(liquidity.interestRate) }} DASH</p>
                        </div>

                        <div>
                            <p>Available Balance</p>
                            <p>{{ $utils.fromWei(liquidity.amount) }} {{ findCoin(liquidity.tokenAddress).symbol }}</p>
                        </div>

                        <div>
                            <p>Take Out</p>
                            <p>{{ $utils.fromWei(liquidity.minTakeOut) }} ~ {{ $utils.fromWei(liquidity.maxTakeOut)}} {{ findCoin(liquidity.tokenAddress).symbol }}</p>
                        </div>

                        <div>
                            <p>Min Credit Score</p>
                            <p>{{ liquidity.minScore }}</p>
                        </div>
                    </div>

                    <div class="action" v-if="!liquidity.closed" v-on:click="closeLiquidity(liquidity.id)">
                        <i class="fi fi-br-pause"></i> {{ closing == liquidity.id ? 'Closing..' : 'Close' }}
                    </div>

                    <div class="action closed" v-else>
                        <i class="fi fi-br-ban"></i> Closed
                    </div>
                </div>
            </div>

            <div class="empty" v-if="liquidities.length == 0 && tab == 1">
                <img src="/images/astronaut_borrow.png" alt="">
                <p>No Liquidity!</p>
            </div>

            <div class="empty" v-if="dusts().length == 0 && tab == 2">
                <img src="/images/astronaut_borrow.png" alt="">
                <p>No Dust!</p>
            </div>

            <div class="histories">
                <h3>History</h3>
                <table>
                    <thead>
                        <tr>
                            <td>Token</td>
                            <td>Amount</td>
                            <td>Interest / 24h</td>
                            <td>Due date</td>
                            <td>Status</td>
                            <td>Contact</td>
                        </tr>
                    </thead>
                    <tbody>
                        <br>
                        <tr v-for="history in histories" :key="history.id">
                            <td>
                                <div class="images">
                                    <img :src="findCoin(history.liquidity.tokenAddress).image" alt="">
                                </div>
                                <p>{{ findCoin(history.liquidity.tokenAddress).name }} <b>{{ findCoin(history.liquidity.tokenAddress).symbol }}</b></p>
                            </td>
                            <td>{{ $utils.fromWei(history.amount) }}</td>
                            <td>{{ $utils.fromWei(history.interestRate) }} DASH</td>
                            <td>{{ $utils.formatToDate(history.createdAt * 1000) }}</td>
                            <td>
                                <p v-if="history.paidAt  == 0">No <i class="fi fi-ss-badge-check"></i></p>
                                <p v-else>Paid on {{ $utils.formatToDate(history.paidAt * 1000)  }} <i class="fi fi-ss-badge-check"></i></p>
                            </td>
                            <td v-on:click="$nuxt.$emit('contact', history.user)">
                                <div class="images">
                                    <img :src="history.user.photo" alt="">
                                </div>
                                <p>{{ history.user.name }}</p>
                            </td>
                        </tr>
                    </tbody>
                </table>
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
            address: null,
            liquidities: [],
            histories: [],
            coins: stableCoins,
            contract: null,
            closing: -1,
            earnings: '0',
            fetching: true
        };
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        if (this.address != null) {
            this.getLiquidities()
            this.getLoanHistory()
        }

        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.contract = contract
        })
    },
    methods: {
        getLiquidities: async function () {
            this.liquidities = await this.$firestore.fetchAllWhere(
                'liquidities',
                'address',
                '==',
                this.address.toUpperCase()
            )

            this.liquidities.forEach(liquidity => {
                if (!liquidity.closed) {
                    this.earnings += liquidity.interestRate
                }
            })

            this.fetching = false
        },

        dusts: function () {
            return this.liquidities.filter(liquidity =>
                liquidity.amount < liquidity.minTakeOut
            )
        },

        findCoin: function (address) {
            const coins = this.coins.filter(coin => coin.address.toUpperCase() == address.toUpperCase())
            if (coins.length == 0) return
            return coins[0]
        },

        getLoanHistory: async function () {
            this.histories = await this.$firestore.fetchAllLoansHistoryProviders(this.address)
        },

        closeLiquidity: async function (id) {
            if (this.contract == null) return

            this.closing = id

            try {
                await this.contract.closeLiquidity(id, {
                    from: this.address
                })

            } catch (error) {}

            this.getLiquidities()
            this.closing = -1
        }
    }
};
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
    background: #CCEEFF;
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

.balance div:nth-child(2) {
    background: #ffdbd6;
    color: #ad1500;
}

.tabs {
    display: flex;
    align-items: center;
    background: #e2e2e2;
    border-radius: 10px;
    width: fit-content;
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

.pools {
    display: flex;
    flex-wrap: wrap;
    margin-top: 40px;
    gap: 40px;
}

.pool {
    width: 360px;
    padding: 30px;
    background: #fafafa;
    box-shadow: 0 6px 10px #ccc;
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

.stats p:last-child {
    font-weight: 600;
}

.stats>div {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.stats img {
    height: 20px;
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

.closed {
    background: #ccc;
    color: #000;
}

.action i {
    position: absolute;
    left: 20px;
}

.histories {
    margin-top: 60px;
}

.histories h3 {
    font-size: 30px;
}

table {
    width: 100%;
    margin-top: 20px;
    background-image: linear-gradient(to top, #0c3483 0%, #a2b6df 100%, #6b8cce 100%, #a2b6df 100%);
    padding: 40px 0;
    border-radius: 30px;
    border: none;
}

tbody img {
    width: 30px;
    height: 30px;
    border-radius: 50%;
}

td {
    padding: 0 40px;
}

thead td {
    font-size: 20px;
    color: #1900b3 !important;
    font-weight: 600 !important;
}

tbody {
    padding-top: 30px;
}

tbody tr {
    border-radius: 6px;
}

tbody td {
    color: #FFFFFF;
}

td:nth-child(2) {
    width: 150px;
}

td:nth-child(3) {
    width: 150px;
}

td:nth-child(4) {
    width: 250px;
}

td:nth-child(5) {
    width: 120px;
}

td:nth-child(5) p {
    display: flex;
    align-items: center;
    gap: 4px;
}

td:last-child {
    width: 250px;
}

td:last-child p {
    text-decoration: underline;
    cursor: pointer;
    font-weight: 600;
}

tbody td:first-child,
td:last-child {
    gap: 10px;
    display: flex;
    height: 65px;
    align-items: center;
    font-weight: 500;
}

td:last-child {
    text-align: right;
}
</style>
