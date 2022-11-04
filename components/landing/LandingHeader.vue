<template>
<section>
    <div class="app-width">
        <div class="header">
            <div class="logo">
                <img src="/images/logo.png" alt="">
            </div>
            <ul>
                <li><a href="">Get Started</a></li>
                <li><a href="">Developer</a></li>
                <li><a href="">Dash Token</a></li>
                <li><a href="">About</a></li>
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
</style>
