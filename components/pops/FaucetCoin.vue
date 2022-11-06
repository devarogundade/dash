<template>
<div class="box" v-if="show">
    <div class="token" v-for="coin in coins" :key="coin.symbol" v-on:click="choose(coin)">
        <img :src="coin.image" alt="" />
        <div class="text">
            <h3>{{ coin.name }} - {{ coin.allocation }}</h3>
            <p>{{ coin.address.substring(0, 10) }}...{{coin.address.substring(coin.address.length -10, coin.address.length) }}</p>
        </div>
    </div>
</div>
</template>

<script>
import stableCoins from "../../faucetcoins.json";
export default {
    data() {
        return {
            coins: stableCoins,
            show: false,
        };
    },
    created() {
        $nuxt.$on("pick-faucet", () => {
            this.show = true;
        });
    },
    methods: {
        choose: function (coin) {
            $nuxt.$emit("faucet", coin);
            this.show = false;
        },
    },
};
</script>

<style scoped>
.box {
    width: 500px;
    overflow: hidden;
    border-radius: 30px;
    background: rgb(222, 255, 222);
    position: fixed;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    box-shadow: 0 4px 8px #ccc;
    z-index: 10;
}

.token {
    display: flex;
    align-items: center;
    padding: 10px 20px;
    gap: 20px;
    cursor: pointer;
    user-select: none;
    border-bottom: 1px solid #ccc;
}

.token:hover {
    background: rgb(211, 211, 211);
}

.token h3 {
    font-size: 24px;
    margin-bottom: 4px;
}

.token p {
    font-size: 16px;
}

.token img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 50%;
}

.token:first-child {
    padding-top: 20px;
}

.token:last-child {
    padding-bottom: 20px;
    border: none;
}
</style>
