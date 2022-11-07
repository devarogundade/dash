<template>
<section>
    <div class="header">
        <div class="i-app-width">
            <div class="text">
                <h3>Manage your contact list</h3>
                <h2>1,074 DASH</h2>
                <div class="other">
                    <p>Total contacts: {{ contacts.length }}</p>
                    <router-link to="/app">
                        <p> Leave App <i class="fi fi-br-arrow-up-right-from-square"></i> </p>
                    </router-link>
                </div>
                <div class="search">
                    <div class="filter">
                        <i class="fi fi-br-search"></i>
                        <input type="text" placeholder="Search contacts by name" />
                    </div>

                    <div class="go" v-on:click="$nuxt.$emit('success', {
                      title: 'Thank you!',
                      message: 'But this feature is under development.'
                    })">Search</div>
                </div>
            </div>
            <div class="image">
                <img src="/images/astronaut_friends.png" alt="" />
            </div>
        </div>
    </div>
    <div class="body">
        <div class="i-app-width">
            <div class="learn">
                <p>I don't understand!</p>
                <router-link to="/how-to-use">
                    <div>Learn <i class="fi fi-br-arrow-right"></i></div>
                </router-link>
            </div>

            <div class="toolbar">

                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        All Contacts
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'" v-on:click="tab = 2">
                        Owing
                    </div>
                </div>

                <div class="balance">
                    <router-link to="/dapp/add-contact">
                        <div class="add"> <i class="fi fi-br-plus"></i> Add New Contact</div>
                    </router-link>
                    <!-- <div class="add remove"><i class="fi fi-sr-trash"></i> Remove Liquidity</div> -->
                </div>
            </div>

            <div class="friends">
                <div class="friend" v-for="(contact, index) in contacts" :key="index" v-on:click="$nuxt.$emit('profile', contact)">
                    <div class="image">
                        <img :src="contact.photo" alt="">
                    </div>
                    <div class="detail">{{ contact.name }}</div>
                </div>
            </div>

            <div class="empty" v-if="contacts.length == 0">
                <img src="/images/astronaut_borrow.png" alt="">
                <p>No Contacts!</p>
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
            contacts: [],
            address: null
        };
    },
    async created() {
        this.address = await this.$auth.connectToMetaMask()
        if (this.address != null) {
            this.contacts = await this.$firestore.fetchAllContacts(
                this.address.toUpperCase()
            )
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
    height: 300px;
    width: 100%;
    display: flex;
    justify-content: center;
    background: #DC9AFE;
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

.toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 60px;
}

.balance {
    display: flex;
    align-items: center;
    gap: 10px;
}

.balance div {
    height: 40px;
    padding: 0 20px;
    border-radius: 10px;
    cursor: pointer;
    user-select: none;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    background: #ccc;
}

.balance div:first-child {
    background: #d2cbff;
    color: #1900b3;
}

.balance div:nth-child(2) {
    background: #ffdbd6;
    color: #ad1500;
}

.tabs {
    display: flex;
    align-items: center;
    background: #e2e2e2;
    border-radius: 10px;
    width: fit-content;
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

.item-active {
    background: #CCC;
}

.friends {
    display: flex;
    flex-wrap: wrap;
    margin-top: 40px;
    gap: 40px;
}

.friend {
    width: 300px;
    padding: 30px;
    background: #fafafa;
    box-shadow: 0 6px 10px #ccc;
    border: 1px;
    cursor: pointer;
    user-select: none;
    border-radius: 16px;
}

.friend .image {
    width: 100%;
    height: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.friend .image img {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    object-fit: cover;
}

.friend .detail {
    text-align: center;
    margin-top: 10px;
    font-size: 16px;
    font-weight: 600;
}

.action {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 45px;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
    background: #1900b3;
    color: #ffffff;
    font-weight: 600;
    gap: 10px;
    font-size: 16px;
    position: relative;
    margin-top: 30px;
}

.action i {
    position: absolute;
    left: 20px;
}
</style>
