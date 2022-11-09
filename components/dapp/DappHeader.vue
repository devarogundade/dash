<template>
<div class="header" ref="menu">
    <div class="grid">
        <div class="top">
            <router-link to="/dapp">
                <div class="logo">
                    <img src="/images/logo.png" alt="">
                </div>
            </router-link>

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
                    <div :class="($route.name == 'dapp-loan' || $route.name == 'dapp-offers' || $route.name == 'dapp-new-loan-liquidity') ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-usd-circle"></i> Loans
                    </div>
                </router-link>
                <router-link to="/dapp/liquidity">
                    <div :class="($route.name == 'dapp-liquidity' || $route.name == 'dapp-add-liquidity') ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-piggy-bank"></i> Liquidity
                    </div>
                </router-link>
                <router-link to="/dapp/contacts">
                    <div :class="($route.name == 'dapp-contacts' || $route.name == 'dapp-add-contacts') ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-following"></i> Contacts
                    </div>
                </router-link>
            </div>
        </div>
        <div class="bottom">
            <div class="tabs">
                <div v-on:click="showOptions = !showOptions" :class="showOptions ? 'show item' : 'item'">
                    <i class="fi fi-sr-menu-dots"></i> More
                    <div class="options">
                        <p>Request loan</p>
                        <p>Add a new coin</p>
                        <p>Account statement</p>
                    </div>
                </div>
                <router-link to="/dapp/settings">
                    <div :class="$route.name == 'dapp-settings' ? 'item item-active' : 'item'">
                        <i class="fi fi-sr-settings"></i> Settings
                    </div>
                </router-link>
            </div>
        </div>
        <div ref="handburger" id="handburger" v-on:click="onDrawer()">
            <span></span>
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
</div>
</template>

<script>
export default {
    data() {
        return {
            address: null,
            showOptions: false
        }
    },
    mounted() {
        this.connectWallet()
    },
    methods: {
        connectWallet: async function () {
            this.address = await this.$auth.connectToMetaMask()
        },
        onDrawer: function () {
            this.$refs["handburger"].classList.toggle("open")
            this.$refs["menu"].classList.toggle("open-menu")
            this.showBuild = false
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
    z-index: 20;
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
    cursor: pointer;
    user-select: none;
    font-weight: 600;
    position: relative;
}

.options {
    position: absolute;
    background: #e4e0ff;
    padding: 20px;
    border-radius: 10px;
    z-index: 1;
    bottom: 50px;
    display: none;
}

.show .options {
    display: block;
}

.options p {
    padding: 10px 0;
}

.item-active {
    background: #e4e0ff;
}

#handburger {
    display: none;
}

@media screen and (max-width: 1000px) {
    .header {
        width: 100%;
        height: 100%;
        position: fixed;
        top: 0;
        left: -100%;
        background: #fff;
    }

    .open-menu {
        left: 0 !important;
    }

    #handburger {
        width: 32px;
        height: 25px;
        right: 5%;
        top: 24px;
        position: fixed;
        -webkit-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -o-transform: rotate(0deg);
        transform: rotate(0deg);
        -webkit-transition: 0.5s ease-in-out;
        -moz-transition: 0.5s ease-in-out;
        -o-transition: 0.5s ease-in-out;
        transition: 0.5s ease-in-out;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 100;
    }

    #handburger span {
        display: block;
        position: absolute;
        height: 4px;
        width: 100%;
        background: #000;
        opacity: 1;
        left: 0;
        -webkit-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -o-transform: rotate(0deg);
        transform: rotate(0deg);
        -webkit-transition: 0.25s ease-in-out;
        -moz-transition: 0.25s ease-in-out;
        -o-transition: 0.25s ease-in-out;
        transition: 0.25s ease-in-out;
    }

    #handburger span:nth-child(1) {
        top: 0px;
    }

    #handburger span:nth-child(2),
    #handburger span:nth-child(3) {
        top: 10px;
    }

    #handburger span:nth-child(4) {
        top: 20px;
    }

    #handburger.open span:nth-child(1) {
        top: 10px;
        width: 0%;
        left: 50%;
    }

    #handburger.open span:nth-child(2) {
        -webkit-transform: rotate(45deg);
        -moz-transform: rotate(45deg);
        -o-transform: rotate(45deg);
        transform: rotate(45deg);
    }

    #handburger.open span:nth-child(3) {
        -webkit-transform: rotate(-45deg);
        -moz-transform: rotate(-45deg);
        -o-transform: rotate(-45deg);
        transform: rotate(-45deg);
    }

    #handburger.open span:nth-child(4) {
        top: 18px;
        width: 0%;
        left: 50%;
    }
}
</style>
