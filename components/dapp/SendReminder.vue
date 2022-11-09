<template>
<section>
    <div class="i-app-width">
        <Progress v-if="fetching" />
        <div class="container">
            <div class="form">
                <div class="tabs">
                    <div class="item item-active">Send Reminder</div>
                </div>

                <label class="error-text" v-if="errorUsername">{{ errorUsername }}</label>
                <div class="from input">
                    <input type="text" disabled :class="getInputClassForUsername()" v-model="user.username" placeholder="@username">
                </div>

                <div class="to input">
                    <input type="text" v-model="message" placeholder="Write a message">
                </div>

                <div class="action" v-if="!adding" v-on:click="sendReminder()">Remind</div>
                <div class="action" v-else>Sending..</div>
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
            errorUsername: null,
            message: '',
            user: {
                username: ''
            },
            contract: null,
            address: null,
            adding: false,
            fetching: true
        }
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        this.findUser()
        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.contract = contract
        })
    },
    methods: {
        findUser: async function () {
            const loanId = this.$route.query.loan;
            const userId = this.$route.query.user;
            if (!loanId || loanId == '') {
                $nuxt.$emit('failure', {
                    title: 'Error',
                    message: 'Invalid url'
                })
                this.fetching = false
                return
            }
            if (!userId || userId == '') {
                $nuxt.$emit('failure', {
                    title: 'Error',
                    message: 'Invalid url'
                })
                this.fetching = false
                return
            }

            const users = await this.$firestore.fetchAllWhere(
                'users', 'id', '==', userId.toUpperCase()
            )

            if (users.length == 0) {
                this.user = null
                $nuxt.$emit('failure', {
                    title: 'No user found',
                    message: 'Try a different username'
                })
                this.fetching = false
                return
            }

            this.user = users[0]

            if (this.user.id.toUpperCase() == this.address.toUpperCase()) {
                $nuxt.$emit('failure', {
                    title: 'Error',
                    message: 'You can\'t remind yourself'
                })
            }

            this.fetching = false
        },

        sendReminder: async function () {
            if (this.user == null) {
                $nuxt.$emit('failure', {
                    title: 'No user found',
                    message: 'Try refreshing'
                })
                return
            }

            if (this.user.id.toUpperCase() == this.address.toUpperCase()) {
                $nuxt.$emit('failure', {
                    title: 'Error',
                    message: 'You can\'t remind yourself'
                })
                return
            }

            if (this.contract == null || this.address == null) return

            this.adding = true

            try {
                const sent = await this.$firestore.write('reminders', null, {
                    loanId: this.$route.query.loan,
                    message: this.message,
                    by: this.address,
                    address: this.user.id.toUpperCase(),
                    timestamp: new Date().getTime()
                })
                if (sent) {
                    $nuxt.$emit('success', {
                        title: 'Reminder sent',
                        message: `${this.user.name} has received your message.`
                    })
                } else {
                    $nuxt.$emit('failure', {
                        title: 'Error',
                        message: 'Failed to send'
                    })
                }
            } catch (error) {
                console.log(error);
            }

            this.adding = false
        },

        getInputClassForUsername: function () {
            if (this.user.username == '') {
                this.errorUsername = null
                return ''
            }
            if (!this.user.username.startsWith('@')) {
                this.errorUsername = 'Username must start with @'
                return 'error filled'
            }
            if (this.user.username.length < 4) {
                this.errorUsername = 'Username is too short'
                return 'error filled'
            } else {
                this.errorUsername = null
                return 'filled'
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
    display: flex;
    align-items: center;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
    padding: 20px;
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

.error {
    border: 2px solid #C74F4F;
}

.error-text {
    font-size: 14px;
    font-weight: 600;
    line-height: 17px;
    color: #C74F4F;
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
