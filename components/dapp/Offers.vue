<template>
<section>
    <div class="header">
        <div class="i-app-width">
            <div class="text">
                <h3>Provide Liquidity, EARN $DASH</h3>
                <h2>Earnings: 1,074 DASH per 24h</h2>
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
                        <input type="text" placeholder="Search by token or pool address" />
                    </div>

                    <div class="go">Search</div>
                </div>
            </div>
            <div class="image">
                <img src="/images/astronaut_liquidity.png" alt="" />
            </div>
        </div>
    </div>
    <div class="body">
        <div class="i-app-width">
            <div class="pools">
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

                    <router-link :to="`/dapp/new-loan/${liquidity.id}`">
                        <div class="action">
                            <i class="fi fi-br-dollar"></i> Take loan
                        </div>
                    </router-link>
                </div>
            </div>

            <div class="empty" v-if="liquidities.length == 0">
                <img src="/images/astronaut_borrow.png" alt="">
                <p>No Liquidity!</p>
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
            coins: stableCoins,
            contract: null
        };
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        if (this.address != null) {
            this.getLiquidities()
        }

        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.contract = contract
        })
    },
    methods: {
        getLiquidities: async function () {
            this.liquidities = await this.$firestore.fetchAllContactsWithLiquidities(
                this.address.toUpperCase()
            )
        },

        findCoin: function (address) {
            const coins = this.coins.filter(coin => coin.address.toUpperCase() == address.toUpperCase())
            if (coins.length == 0) return
            return coins[0]
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
    /* background-image: linear-gradient(-20deg, #ddd6f3 0%, #faaca8 100%, #faaca8 100%); */
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
    padding-bottom: 60px;
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

.action i {
    position: absolute;
    left: 20px;
}
</style>
