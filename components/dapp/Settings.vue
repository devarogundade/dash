<template>
<section>
    <div class="header">
        <div class="image">
            <img :src="user.photo" id="photo" alt="" />
        </div>
        <div class="file-picker">
            <input type="file" accept="image/*" v-on:change="choosePhoto($event)">
            <i class="fi fi-br-edit-alt"></i>
        </div>
    </div>
    <div class="body">
        <div class="i-app-width">
            <div class="container">
                <div class="form">
                    <div class="from input">
                        <input type="text" v-model="user.name" placeholder="Full name">
                    </div>

                    <div class="to input">
                        <input type="text" v-model="user.email" placeholder="Email Address">
                    </div>

                    <div class="label">Age</div>
                    <div class="flex">
                        <div class="to input">
                            <input type="text" v-model="user.age.year" placeholder="1999">
                            <div class="token">
                                <p>Year</p>
                            </div>
                        </div>
                        <div class="to input">
                            <input type="text" v-model="user.age.month" placeholder="01">
                            <div class="token">
                                <p>Month</p>
                            </div>
                        </div>
                    </div>

                    <div class="label">Contact & Address</div>
                    <div class="flex">
                        <div class="to input">
                            <input type="text" v-model="user.phone" placeholder="+123">
                            <div class="token">
                                <p>Phone</p>
                            </div>
                        </div>
                        <div class="to input">
                            <input type="text" v-model="user.address" placeholder="01 Street">
                            <div class="token">
                                <p>Address</p>
                            </div>
                        </div>
                    </div>

                    <div class="to input">
                        <input type="text" v-model="user.username" placeholder="@username">
                    </div>

                    <div class="action" v-if="!updating" v-on:click="updateProfile()">Update Profile</div>
                    <div class="action" v-else>Updating..</div>
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
            user: {
                name: '',
                photo: '/images/placeholder.png',
                email: '',
                age: {
                    year: '',
                    month: ''
                },
                phone: '',
                address: '',
                username: ''
            },
            contract: null,
            file: null,
            updating: false
        };
    },
    async created() {
        if (this.$auth.accounts.length > 0) {
            const user = await this.$firestore.fetch('users', this.$auth.accounts[0].toUpperCase())
            if (user != null) {
                this.user = user
            }
        }

        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.contract = contract
        })
    },
    methods: {
        choosePhoto: function (event) {
            const file = event.target.files[0]
            const url = URL.createObjectURL(file)
            document.getElementById('photo').src = url
            this.file = file
        },

        updateProfile: async function () {
            if (this.$auth.accounts.length == 0 || this.contract == null) return

            this.updating = true

            if (this.file != null) {
                const base64 = await this.$ipfs.toBase64(this.file)
                const url = await this.$ipfs.upload(`users`, base64)

                if (url != null) {
                    this.user.photo = url
                }
            }

            try {
                const trx = await this.contract.createUser(
                    this.user.name,
                    this.user.photo,
                    this.user.email,
                    this.user.username, {
                        from: this.$auth.accounts[0]
                    }
                )

                $nuxt.$emit('trx', trx)
                $nuxt.$emit('success', {
                    title: 'Profile Updated',
                    message: 'You have successfully updated your profile!'
                })
            } catch (error) {}

            this.updating = false
        }
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
    height: 240px;
    width: 100%;
    display: flex;
    justify-content: center;
    position: relative;
    background: #CCEEFF;
}

.header .image {
    position: absolute;
    left: 50%;
    top: 80px;
    transform: translate(-50%, 0);
    height: 240px;
    width: 240px;
    border-radius: 50%;
    overflow: hidden;
}

.header img {
    height: 100%;
    width: 100%;
    object-fit: cover;
}

.file-picker {
    width: 60px;
    height: 60px;
    background: #1900b3;
    border-radius: 20px;
    overflow: hidden;
    cursor: pointer;
    top: 250px;
    left: calc(50% + 50px);
    color: #ff9d05;
    position: absolute;
    z-index: 1;
    font-size: 24px;
}

.file-picker input {
    width: 100%;
    height: 100%;
    opacity: 0;
    z-index: 1;
}

.header .text h3 {
    font-size: 24px;
    margin-top: 20px;
}

.header .text h2 {
    margin-top: 10px;
    font-size: 36px;
    color: #1900b3;
}

.body {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-top: 60px;
    padding-bottom: 60px;
}

.container {
    width: 100%;
    display: flex;
    justify-content: center;
    padding: 50px 0;
}

.form {
    width: 450px;
    height: fit-content;
}

.input {
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    box-shadow: 0 4px 8px #CCC;
    border-radius: 10px;
    padding: 10px;
    margin-bottom: 20px;
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
}

.label {
    font-size: 16px;
    margin-bottom: 4px;
    font-weight: 600;
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
    font-weight: 600;
    color: #ff9d05;
    cursor: pointer;
    user-select: none;
}

.flex {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
}
</style>
