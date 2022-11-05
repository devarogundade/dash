<template>
<section>
    <div class="i-app-width">
        <div class="nav">
            <h3>Hi, Welcome back!</h3>
            <router-link to="/dapp/settings">
                <div class="profile">
                    <div class="image">
                        <img src="/images/placeholder.png" alt="">
                    </div>
                    <p>My Profile</p>
                </div>
            </router-link>
        </div>
        <div class="home">
            <div class="apps">
                <router-link to="">
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
                        <h3>Give a Loan</h3>
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
        <div class="history">
            <h3>Notifications</h3>
            <div class="toolbar">
                <div class="filter">
                    <i class="fi fi-br-search"></i>
                    <input type="text" placeholder="Search notifications">
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding: 60px 0;
}

.history>h3 {
    font-size: 30px;
}

.toolbar {
    margin-top: 20px;
}

.filter {
    width: 400px;
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
    justify-content: center;
    margin-bottom: 60px;
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
    box-shadow: 0 4px 8px #CCC;
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
</style>
