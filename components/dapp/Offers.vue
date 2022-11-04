<template>
<section>
    <div class="header">
        <div class="i-app-width">
            <div class="text">
                <h3>Active Lending Offers</h3>
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
                <img src="/images/rocket_astronaut.png" alt="" />
            </div>
        </div>
    </div>
    <div class="body">
        <div class="i-app-width">
            <div class="toolbar">
                <div class="filter"></div>
            </div>

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
                    <router-link v-for="index in 15" :key="index" to="/dapp/new-loan">
                        <tr>
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
                    </router-link>
                </tbody>
            </table>
        </div>
    </div>
</section>
</template>

<script>
export default {
    data() {
        return {
            tab: 1,
        };
    },
};
</script>

<style scoped>
section {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    overflow: hidden;
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

table {
    width: 100%;
    margin-top: 20px;
    margin-top: 40px;
    border-radius: 30px;
    border: none;
}

tbody img {
    width: 30px;
    height: 30px;
    border-radius: 50%;
}

td {
    min-width: 300px;
}

thead {
    position: sticky;
    background: #ffffff;
    top: 0;
}

thead td {
    font-size: 20px;
    padding: 10px 0;
    font-weight: 600;
}

tbody {
    padding-top: 30px;
}

tbody tr {
    border-radius: 6px;
}

tbody tr:hover {
    background: #FFFFFF;
}

tbody td {
    /* color: #FFFFFF; */
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
</style>
