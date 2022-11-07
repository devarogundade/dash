<template>
<section>
    <div class="i-app-width">
        <div class="container">
            <div class="form">
                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        New
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'">
                        Existing <span>Soon</span>
                    </div>
                </div>

                <div class="from input">
                    <input type="text" v-model="username" placeholder="@username">
                    <div class="token" v-on:click="findUser()">
                        <p>Search</p>
                    </div>
                </div>

                <div class="to input">
                    <input type="text" v-if="user" v-model="user.name" disabled>
                    <input type="text" v-else disabled>
                </div>

                <div class="action" v-on:click="addToContact()">Add To Contact</div>
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
            username: '',
            user: null,
            contract: null,
            address: null
        }
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.contract = contract
        })
    },
    methods: {
        findUser: async function () {
            if (this.username == '') return

            const users = await this.$firestore.fetchAllWhere(
                'users', 'username', '==', this.username.toLowerCase()
            )

            if (users.length == 0) {
                this.user = null
                $nuxt.$emit('failure', {
                    title: 'No user found',
                    message: 'Try a different username'
                })
                return
            }

            this.user = users[0]

            if (this.user.id.toUpperCase() == this.address.toUpperCase()) {
                $nuxt.$emit('failure', {
                    title: 'Error',
                    message: 'You can\'t added yourself'
                })
            }
        },

        addToContact: async function () {
            if (this.user == null) {
                $nuxt.$emit('failure', {
                    title: 'No user found',
                    message: 'Search user by username'
                })
                return
            }

            if (this.user.id.toUpperCase() == this.address.toUpperCase()) {
                $nuxt.$emit('failure', {
                    title: 'Error',
                    message: 'You can\'t added yourself'
                })
                return
            }

            if (this.contract == null || this.address == null) return

            try {
                const trx = await this.contract.addNetwork(this.user.id.toLowerCase(), {
                    from: this.address
                })

                $nuxt.$emit('success', {
                    title: 'User added to list',
                    message: `${this.user.name} has been added to your contact`
                })
            } catch (error) {
                console.log(error);
            }
        }
    }
}
</script>

<style scoped>
.container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    padding: 150px 0;
}

.form {
    width: 450px;
    border-radius: 30px;
    padding: 40px;
    box-shadow: 0 6px 10px #CCC;
    height: fit-content;
}

.tabs {
    display: flex;
    align-items: center;
    border-radius: 10px;
    width: fit-content;
    margin-bottom: 40px;
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

.item span {
    padding: 2px 6px;
    background: #ff9d05;
    color: #ffffff;
    font-size: 12px;
    border-radius: 4px;
    margin-top: -20px;
    margin-left: 5px;
}

.item-active {
    background: #000;
    color: #ffffff;
}

.input {
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    box-shadow: 0 4px 8px #CCC;
    border-radius: 10px;
    padding: 10px;
}

.input input {
    width: 100%;
    background: transparent;
    font-size: 20px;
    font-weight: 600;
    padding-right: 20px;
    height: 100%;
    border: none;
    outline: none;
}

.input .token {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
    user-select: none;
    cursor: pointer;
}

.to {
    margin-top: 20px;
}

.price {
    margin: 30px 0;
    text-align: center;
    font-size: 18px;
}

.action {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    background: #1900b3;
    font-size: 16px;
    cursor: pointer;
    user-select: none;
    font-weight: 600;
    color: #ff9d05;
}
</style>
