<template>
<section>
    <div class="app-width">
        <h3>Supported Stable Coins</h3>

        <table>
            <thead>
                <tr>
                    <td>Name</td>
                    <td>Price</td>
                    <td>Circulating</td>
                    <td>Contract Address</td>
                </tr>
            </thead>
            <tbody>
                <br>
                <tr v-for="coin in coins" :key="coin.symbol">
                    <td>
                        <div class="images">
                            <img src="/images/dash-token.png" alt="">
                            <img :src="coin.image" alt="">
                        </div>
                        <p>{{ coin.name }} <b>{{ coin.symbol }}</b></p>
                    </td>
                    <td>$1.00</td>
                    <td>10,000,000,000</td>
                    <td>
                        <p>{{ coin.address.substring(0, 10) }}...{{coin.address.substring(coin.address.length -10, coin.address.length) }}</p>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="action">
            <h4>Connect your wallet to start borrowing and lending.</h4>
            <router-link to="/dapp">
                <div>Launch App</div>
            </router-link>
        </div>
    </div>
</section>
</template>

<script>
import stableCoins from "../../stablecoins.json";
export default {
    data() {
        return {
            coins: stableCoins
        }
    }
}
</script>

<style scoped>
section {
    padding-top: 200px;
}

section h3 {
    font-size: 40px;
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
    min-width: 250px;
}

thead td {
    font-size: 20px;
    color: #FFFFFF;
    font-weight: 600;
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

tbody td:first-child {
    gap: 10px;
    display: flex;
    height: 65px;
    align-items: center;
    font-weight: 500;
}

td:last-child {
    text-align: right;
}

.images {
    display: flex;
    align-items: center;
}

.images img:last-child {
    margin-left: -10px;
}

.action {
    margin-top: 40px;
}

.action h4 {
    font-size: 24px;
}

.action div {
    height: 55px;
    width: 220px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 20px;
    border-radius: 10px;
    background: #ff9d05;
    font-size: 16px;
    font-weight: 600;
    color: #1900b3;
}
</style>
