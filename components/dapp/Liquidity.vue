<template>
<section>
    <div class="header">
        <div class="i-app-width">
            <div class="text">
                <h3>Provide Liquidity, EARN $DASH</h3>
                <h2>$105,786,890.44</h2>
                <div class="other">
                    <p>Total Value Locked (TVL)</p>
                    <router-link to="">
                        <p>
                            Tutorial <i class="fi fi-br-arrow-up-right-from-square"></i>
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
            <div class="learn"></div>

            <div class="toolbar">
                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        Active
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'" v-on:click="tab = 2">
                        All Liquidity
                    </div>
                </div>

                <div class="balance">
                    <router-link to="/dapp/add-liquidity">
                        <div class="add"> <i class="fi fi-br-plus"></i> Add Liquidity</div>
                    </router-link>
                    <div class="add remove"><i class="fi fi-sr-trash"></i> Remove Liquidity</div>
                </div>
            </div>

            <div class="pools">
                <div class="pool" v-for="(liquidity, index) in liquidities" :key="index">
                    <div class="top">
                        <div class="images">
                            <img src="https://s2.coinmarketcap.com/static/img/coins/200x200/825.png" alt="" />
                        </div>
                        <p>USDT</p>
                    </div>

                    <div class="apy">
                        <h3>22.4%</h3>
                        <p>APY</p>
                    </div>

                    <div class="stats">
                        <div>
                            <p>Reward Token</p>
                            <img src="https://s2.coinmarketcap.com/static/img/coins/200x200/825.png" alt="" />
                        </div>

                        <div>
                            <p>Reward Token</p>
                            <p>$2,432.40</p>
                        </div>

                        <div>
                            <p>My Share</p>
                            <p>$0 (0%)</p>
                        </div>

                        <div>
                            <p>Available Balance</p>
                            <p>$0</p>
                        </div>
                        <div>
                            <p>Interest</p>
                            <p>$0</p>
                        </div>
                    </div>

                    <div class="action">
                        <i class="fi fi-br-plus"></i> Pause
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
export default {
    data() {
        return {
            tab: 1,
            liquidities: []
        };
    },
    async created() {
        if (this.$auth.accounts.length > 0) {
            this.liquidities = await this.$firestore.fetchAllWhere('liquidities', 'address', '==',
                this.$auth.accounts[0].toUpperCase()
            )
        }
    },
    methods: {

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
    margin-top: 60px;
    padding-bottom: 60px;
}

.learn {
    height: 200px;
    width: 100%;
    background: #000;
    border-radius: 30px;
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
    background: #000;
    color: #ffffff;
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
