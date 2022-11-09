<template>
<section id="learn">
    <div class="app-width">
        <h3 class="heading">Step by Step Guide</h3>

        <div class="items">
            <div class="item">
                <h3>Step 1</h3>
                <p>Go to <a href="https://dash-p2p.netlify.app">https://dash-p2p.netlify.app</a> to access the DAPP.</p>
            </div>
            <div class="item">
                <h3>Step 2</h3>
                <p> Connect your wallet to authenticate your account. </p>
            </div>
            <div class="item">
                <h3>Step 3</h3>
                <p>Go to settings tab and create your profile.</p>
            </div>
            <div class="item">
                <h3>Step 4</h3>
                <p>Go to contacts tab and add a new contact by searching for them with their username.</p>
            </div>
            <div class="item">
                <h3>Step 5</h3>
                <p>Go to <a href="https://dash-p2p.netlify.app/faucet">https://dash-p2p.netlify.app/faucet</a> to mint some test tokens.</p>
            </div>
            <div class="item">
                <h3>Step 6</h3>
                <p>Launch dapp, go to liquidity tab and add a new liquidity with some of the test tokens from the faucet.</p>
            </div>
            <div class="item">
                <h3>Step 7</h3>
                <p>Now your contacts list can see your liquidities, and take some of it as a loan.</p>
            </div>
            <div class="item">
                <h3>Step 8</h3>
                <p>Your contact list will repay back the exact token that was borrowed and interests in Dash tokens.</p>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding-top: 200px;
    padding-bottom: 100px;
}

section .heading {
    font-size: 40px;
}

.app-width {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.items {
    display: flex;
    flex-direction: column;
    margin-top: 40px;
    gap: 30px;
    width: 100%;
    max-width: 1000px;
    width: 100%;
}

.item {
    background: #EEE;
    border-radius: 20px;
    border: 6px #CCC solid;
    padding: 30px;
}

.item h3 {
    font-size: 26px;
    margin-bottom: 20px;
}

.item p {
    font-size: 16px;
    line-height: 24px;
    font-weight: 600;
    color: #333;
}

a {
    color: #1900b3;
}

@media screen and (max-width: 800px) {
    section {
        padding-top: 60px;
    }

    section .heading {
        font-size: 24px;
    }

    .items {
        margin-top: 20px;
        gap: 20px;
    }

    .item {
        border-radius: 16px;
        border: 4px #CCC solid;
        padding: 20px;
    }
}
</style>
