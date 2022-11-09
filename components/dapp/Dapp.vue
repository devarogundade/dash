<template>
<section>
    <Progress v-if="fetching" />
    <div class="i-app-width">
        <div class="nav">
            <h3>Hi, Welcome back!</h3>
            <router-link to="/dapp/settings">
                <div class="profile" v-if="!user">
                    <div class="image">
                        <img src="/images/placeholder.png" alt="" />
                    </div>
                    <p>My Profile</p>
                </div>

                <div class="profile" v-else>
                    <div class="image">
                        <img :src="user.photo" alt="" />
                    </div>
                    <p>{{ user.name }}</p>
                </div>
            </router-link>
        </div>
        <div class="home">
            <div class="balances">
                <div class="balance">
                    <img :src="balances.ftm.image" alt="" />
                    <div class="name">
                        <h3>{{ balances.ftm.name }}</h3>
                        <p>{{ balances.ftm.symbol }}</p>
                    </div>
                    <div class="total">
                        <p>
                            {{ Number($utils.fromWei(balances.ftm.balance)).toFixed(4) }}
                        </p>
                        <p>
                            $
                            {{
                  (
                    balances.ftm.quoteRate *
                    Number($utils.fromWei(balances.ftm.balance))
                  ).toFixed(4)
                }}
                        </p>
                    </div>
                </div>
                <div class="balance">
                    <img :src="balances.fusd.image" alt="" />
                    <div class="name">
                        <h3>{{ balances.fusd.name }}</h3>
                        <p>{{ balances.fusd.symbol }}</p>
                    </div>
                    <div class="total">
                        {{ Number($utils.fromWei(balances.fusd.balance)).toFixed(3) }}
                    </div>
                </div>
                <div class="balance">
                    <img :src="balances.usdt.image" alt="" />
                    <div class="name">
                        <h3>{{ balances.usdt.name }}</h3>
                        <p>{{ balances.usdt.symbol }}</p>
                    </div>
                    <div class="total">
                        {{ Number($utils.fromWei(balances.usdt.balance)).toFixed(3) }}
                    </div>
                </div>
                <div class="balance">
                    <img :src="balances.usdc.image" alt="" />
                    <div class="name">
                        <h3>{{ balances.usdc.name }}</h3>
                        <p>{{ balances.usdc.symbol }}</p>
                    </div>
                    <div class="total">
                        {{ Number($utils.fromWei(balances.usdc.balance)).toFixed(3) }}
                    </div>
                </div>
                <div class="balance">
                    <img :src="balances.dash.image" alt="" />
                    <div class="name">
                        <h3>{{ balances.dash.name }}</h3>
                        <p>{{ balances.dash.symbol }}</p>
                    </div>
                    <div class="total">
                        {{ Number($utils.fromWei(balances.dash.balance)).toFixed(3) }}
                    </div>
                </div>
            </div>
            <div class="attributes">
                Price feed by <img src="/images/covalent.png" alt="" />
            </div>

            <div class="apps">
                <router-link to="/how-to-use">
                    <div class="app">
                        <h3>Get Started</h3>
                        <p>Learn how to use DASH to borrow and lend.</p>
                        <img src="/images/astronaut_learning.png" alt="" />
                    </div>
                </router-link>
                <router-link to="/dapp/loan">
                    <div class="app">
                        <h3>Get a Loan</h3>
                        <p>Borrow tokens from your contact.</p>
                        <img src="/images/astronaut_borrow.png" alt="" />
                    </div>
                </router-link>
                <router-link to="/dapp/liquidity">
                    <div class="app">
                        <h3>Provide Liquidity</h3>
                        <p>Earn $DASH for lending out to your contacts.</p>
                        <img src="/images/astronaut_liquidity.png" alt="" />
                    </div>
                </router-link>
                <router-link to="/dapp/contacts">
                    <div class="app">
                        <h3>My Contacts</h3>
                        <p>Add your circle of friends and family.</p>
                        <img src="/images/astronaut_friends.png" alt="" />
                    </div>
                </router-link>
            </div>
        </div>
        <div class="reminders">
            <h3>Reminders</h3>
            <div class="toolbar">
                <div class="filter">
                    <i class="fi fi-br-search"></i>
                    <input type="text" placeholder="Search reminder with text" />
                </div>
            </div>

            <table v-if="reminders.length > 0">
                <thead>
                    <tr>
                        <td>From</td>
                        <td>Message</td>
                        <td>Action</td>
                    </tr>
                </thead>
                <tbody>
                    <br />
                    <tr v-for="(reminder, index) in reminders" :key="index">
                        <td v-on:click="$nuxt.$emit('contact', reminder.user)">
                            <div class="images">
                                <img :src="reminder.user.photo" alt="" />
                            </div>
                            <p>{{ reminder.user.name }}</p>
                        </td>
                        <td>{{ reminder.message }}</td>
                        <td>
                            <p class="remind">
                                <router-link to="/dapp/loan">Pay Loan</router-link>
                            </p>
                        </td>
                    </tr>
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
            user: null,
            address: null,
            balances: {
                ftm: {
                    balance: "0",
                    name: "Fantom",
                    symbol: "FTM",
                    image: "https://s3.coinmarketcap.com/static/img/portraits/62d51d9af192d82df8ff3a83.png",
                    address: process.env.FTM_CONTRACT_ADDRESS,
                    quoteRate: 0,
                },
                fusd: {
                    balance: "0",
                    name: "Fantom USD",
                    symbol: "FUSD",
                    image: "https://s3.coinmarketcap.com/static/img/portraits/62d51d9af192d82df8ff3a83.png",
                    address: "0xDfF71f0DCb01884a462e834AC8940c4DF0F68947",
                },
                usdt: {
                    balance: "0",
                    name: "USDT",
                    symbol: "tUSDT",
                    image: "https://s2.coinmarketcap.com/static/img/coins/200x200/825.png",
                    address: "0x19037fDa524EB14c595E37Ae6F7E87f34Fec4dCc",
                },
                usdc: {
                    balance: "0",
                    name: "USDC",
                    symbol: "tUSDC",
                    image: "https://s3-symbol-logo.tradingview.com/market-cap-usdc--600.png",
                    address: "0x1dFBC4CC39Afd045F5E8FDB11c8f57D67ce365D0",
                },
                dash: {
                    balance: "0",
                    name: "Dash Token",
                    symbol: "DASH",
                    image: "/images/dash-token.png",
                    address: process.env.TOKEN_CONTRACT_ADDRESS,
                },
            },
            reminders: [],
            fetching: true,
        };
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask();
        if (this.address != null) {
            this.getUser();
            this.getBalances();
            this.getReminders();
        }
    },
    methods: {
        getUser: async function () {
            this.user = await this.$firestore.fetch(
                "users",
                this.address.toUpperCase()
            );
        },
        getBalances: async function () {
            const response = await this.$covalent.getTokenBalances(this.address);
            this.fetching = false;

            if (response == null || !response.data) return;
            response.data.items.forEach((token) => {
                switch (token.contract_address.toUpperCase()) {
                    case this.balances.ftm.address.toUpperCase():
                        this.balances.ftm.balance = token.balance;
                        this.balances.ftm.quoteRate = token.quote_rate;
                        this.balances.ftm.image = token.logo_url;
                        break;
                    case this.balances.fusd.address.toUpperCase():
                        this.balances.fusd.balance = token.balance;
                        break;
                    case this.balances.usdt.address.toUpperCase():
                        this.balances.usdt.balance = token.balance;
                        break;

                    case this.balances.usdc.address.toUpperCase():
                        this.balances.usdc.balance = token.balance;
                        break;
                    case this.balances.dash.address.toUpperCase():
                        this.balances.dash.balance = token.balance;
                        break;
                    default:
                        break;
                }
            });
        },
        getReminders: async function () {
            this.reminders = await this.$firestore.fetchAllReminderProviders(
                this.address.toUpperCase()
            );
        },
    },
};
</script>

<style scoped>
section {
    padding: 60px 0;
}

.reminder>h3 {
    font-size: 30px;
}

.toolbar {
    margin-top: 20px;
}

.filter {
    width: 400px;
    max-width: 100%;
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
    width: 100%;
}

.nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.nav>h3 {
    font-size: 24px;
    text-decoration: underline;
}

.profile {
    padding: 4px;
    background: rgb(241, 241, 241);
    display: flex;
    align-items: center;
    padding-right: 10px;
    gap: 4px;
    border-radius: 30px;
}

.profile .image {
    width: 40px;
    height: 40px;
}

.profile img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
}

.profile p {
    font-size: 16px;
    font-weight: 600;
}

.home {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-bottom: 60px;
}

.balances {
    margin-top: 60px;
    width: 640px;
    max-width: 100%;
    border-radius: 20px;
    border: 1px #eee solid;
}

.balance {
    height: 75px;
    border-bottom: 1px #eee solid;
    padding: 0 20px;
    display: flex;
    align-items: center;
    gap: 20px;
}

.balance img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    object-fit: cover;
}

.balance:last-child {
    border: none;
}

.balance .name {
    width: 100%;
}

.balance .total {
    font-size: 30px;
    font-weight: 600;
}

.balance .total p:nth-child(2) {
    text-align: right;
    width: 100%;
    font-size: 14px;
    color: green;
}

.apps {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    margin-top: 60px;
    gap: 30px;
    width: 640px;
    max-width: 100%;
}

.app {
    width: 300px;
    box-shadow: 0 4px 8px #ccc;
    border-radius: 20px;
    padding: 20px;
    text-align: center;
}

.app h3 {
    color: #000;
    font-size: 20px;
}

.app p {
    color: #333;
    font-size: 16px;
    font-weight: 600;
    margin-top: 10px;
}

.app img {
    height: 60px;
    margin-top: 10px;
}

.attributes {
    display: flex;
    width: 100%;
    max-width: 640px;
    align-items: center;
    justify-content: flex-end;
    padding: 10px 0;
    gap: 10px;
    font-weight: 600;
    font-size: 14px;
}

.attributes img {
    height: 20px;
}

.reminders {
    margin-top: 60px;
}

.reminders h3 {
    font-size: 30px;
}

table {
    width: 100%;
    margin-top: 20px;
    background-image: linear-gradient(to top, #2955ac 0%, #a2b6df 100%, #9fb5e0 100%, #a2b6df 100%);
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
    cursor: pointer;
    font-weight: 600;
    width: 250px;
}
td:nth-child(2) {
    width: 500px;
    font-size: 17px;
}

td:last-child {
    width: 200px;
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

.remind {
    background: #1900b3;
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 16px;
}

.remind a {
    font-weight: 600;
    color: #fff;
}

@media screen and (max-width: 800px) {
    .tabs {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .toolbar {
        flex-direction: column;
        gap: 10px;
    }
}

@media screen and (max-width: 700px) {
    .nav>h3 {
        font-size: 20px;
    }

    .profile .image {
        width: 30px;
        height: 30px;
    }
}
</style>
