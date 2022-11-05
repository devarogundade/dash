<template>
<section>
    <div class="app-width">
        <div class="header">
            <router-link to="/">
                <div class="logo">
                    <img src="/images/logo.png" alt="">
                </div>
            </router-link>
            <ul>
                <li><a href="/faucet">Faucet</a></li>
                <li><a href="/#why-dash">Why DASH</a></li>
                <li><a href="/#dash-token">Dash Token</a></li>
                <li><a href="/#faq">FAQs</a></li>
            </ul>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    height: 150px;
    width: 100%;
    position: fixed;
    top: 0;
    left: 0;
    z-index: 10;
}

.logo img {
    height: 40px;
}

.app-width,
.header {
    height: 100%;
}

.header {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 100px;
}

ul {
    display: flex;
    align-items: center;
    gap: 40px;
}

li a {
    font-size: 16px;
    font-weight: 600;
    color: #000;
}
</style>
