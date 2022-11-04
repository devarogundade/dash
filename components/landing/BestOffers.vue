<template>
<section>
    <div class="app-width">
        <h3>Largest Pools</h3>

        <table>
            <thead>
                <tr>
                    <td>Name</td>
                    <td>Price</td>
                    <td>Interest per 24h</td>
                    <td>Volume</td>
                </tr>
            </thead>
            <tbody>
                <br>
                <tr v-for="index in 5" :key="index">
                    <td>
                        <div class="images">
                            <img src="https://s2.coinmarketcap.com/static/img/coins/64x64/1.png" alt="">
                            <img src="https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png" alt="">
                        </div>
                        <p>BNB <b>BNB</b></p>
                    </td>
                    <td>$352.4</td>
                    <td>+3.3%</td>
                    <td>$1.3M</td>
                </tr>
            </tbody>
        </table>

        <div class="action">
            <h4>Connect your Wallet to start borrowing and lending.</h4>
            <div>Connect Wallet</div>
        </div>
    </div>
</section>
</template>

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
