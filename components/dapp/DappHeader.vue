<template>
<div class="header">
    <div class="grid">
        <div class="top">
            <div class="logo">
                <img src="/images/logo.png" alt="">
            </div>
            <div class="connect-wallet" v-if="address == null" v-on:click="connectWallet()">Connect Wallet</div>
            <div class="connect-wallet" v-else>
                {{
                  address.substring(0, 8) +
                  "..." +
                  address.substring(address.length - 8, address.length)
                }}
            </div>

            <div class="tabs">
                <router-link to="/dapp">
                    <div :class="$route.name == 'dapp' ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-wallet"></i> Dashboard
                    </div>
                </router-link>
                <router-link to="/dapp/loan">
                    <div :class="$route.name == 'dapp-loan' ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-usd-circle"></i> Loans
                    </div>
                </router-link>
                <router-link to="/dapp/liquidity">
                    <div :class="$route.name == 'dapp-liquidity' ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-piggy-bank"></i> Liquidity
                    </div>
                </router-link>
                <router-link to="/dapp/contacts">
                    <div :class="$route.name == 'dapp-contacts' ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-following"></i> Contacts
                    </div>
                </router-link>
            </div>
        </div>
        <div class="bottom">
            <div class="tabs">
                <div class="item">
                    <i class="fi fi-sr-menu-dots"></i> More
                </div>
                <router-link to="/dapp/settings">
                    <div :class="$route.name == 'dapp-settings' ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-settings"></i> Settings
                    </div>
                </router-link>
            </div>
        </div>
    </div>
</div>
</template>

<script>
export default {
    data() {
        return {
            address: null
        }
    },
    methods: {
        connectWallet: async function () {
            await this.$auth.connectWallet()
            const accounts = this.$auth.accounts
            if (accounts.length > 0) {
                this.address = accounts[0]
            }
        }
    }
}
</script>

<style scoped>
.header {
    width: 350px;
    border-right: 1px solid #CCC;
    height: 100vh;
    padding: 20px;
    position: sticky;
    top: 0;
}

.logo img {
    height: 40px;
}

.grid {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.connect-wallet {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    background: #ff9d05;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    color: #1900b3;
}

.tabs {
    display: flex;
    flex-direction: column;
    margin-top: 20px;
    gap: 4px;
}

.tabs .item {
    padding: 0 20px;
    border-radius: 10px;
    height: 50px;
    font-size: 16px;
    display: flex;
    align-items: center;
    gap: 16px;
    color: #1900b3;
    font-weight: 600;
}

.item-active {
    background: #e4e0ff;
}
</style>
