<template>
<section id="header">
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
                <li><a href="/#roadmap">Roadmap</a></li>
            </ul>
            <router-link to="/dapp">
                <div class="action"> Launch App <i class="fi fi-br-arrow-right"></i></div>
            </router-link>
        </div>
    </div>
</section>
</template>

<script>
export default {
    mounted() {
        window.addEventListener('scroll', (e) => {
            const header = document.getElementById('header')
            header.classList.toggle('blur', window.pageYOffset > 5)
        })
    }
}
</script>

<style scoped>
section {
    height: 150px;
    width: 100%;
    position: fixed;
    top: 0;
    left: 0;
    z-index: 10;
    background: transparent;
}

.blur {
    background: rgba(255, 255, 255, 1);
    box-shadow: 0 0 10px #CCC;
    height: 80px;
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
    width: 100%;
}

li a {
    font-size: 16px;
    font-weight: 600;
    color: #000;
}

.action {
    padding: 16px 24px;
    border-radius: 30px;
    display: none;
    width: 200px;
    font-size: 20px;
    background: #ff9d05;
    font-size: 15px;
    font-weight: 600;
    color: #1900b3;
    cursor: pointer;
    justify-content: center;
    gap: 20px;
    align-items: center;
    user-select: none;
}

.blur .action {
    display: flex !important;
}
</style>
