<template>
<section>
    <div class="app-width">
        <div class="hero">
            <div class="text">
                <h3>P2P lending, LEND to EARN $Dash.</h3>
                <p>
                    Securely manage how you lend money to or borrow money from your friends, families, and colleagues.
                    Start lending to earn DASH tokens.
                </p>
                <div class="actions">
                    <router-link to="/dapp">
                        <div>Launch App <i class="fi fi-br-arrow-right"></i></div>
                    </router-link>
                    <div>Learn First</div>
                </div>
                <div class="powered">
                    <p>Powered by</p>
                    <div class="images">
                        <img src="https://d33wubrfki0l68.cloudfront.net/35c173c14c345ad7b9b6248273d21a838242a96f/b8f87/assets/img/home/hero/partner/4.svg" alt="" />
                        <img src="https://d33wubrfki0l68.cloudfront.net/75adf2ddce49ab8b1faed9450542ade6e928fab6/f645a/assets/img/home/hero/partner/2.svg" alt="" />
                        <img src="https://d33wubrfki0l68.cloudfront.net/8aa0a439051c1231587c4ec93def5b316edbb142/4ccec/assets/img/home/hero/partner/1.svg" alt="" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="image">
        <img src="/images/two_astronauts.png" alt="" />
    </div>
</section>
</template>

<style scoped>
section {
    min-height: 100vh;
    padding-top: 150px;
    padding-bottom: 80px;
    display: flex;
    align-items: flex-end;
    position: relative;
    overflow: hidden;
}

.text {
    width: 800px;
    max-width: 100%;
}

.text h3 {
    font-size: 80px;
    line-height: 100px;
    font-weight: 700;
}

.text>p {
    font-size: 20px;
    margin-top: 40px;
    font-weight: 600;
    line-height: 30px;
}

.actions {
    display: flex;
    align-items: center;
    gap: 20px;
    margin-top: 60px;
}

.actions div {
    padding: 16px 24px;
    border-radius: 30px;
    font-size: 20px;
    background: #ff9d05;
    font-size: 15px;
    font-weight: 600;
    color: #1900b3;
    cursor: pointer;
    display: flex;
    gap: 20px;
    align-items: center;
    user-select: none;
}

.actions div:nth-child(2) {
    border: 1px solid #1900b3;
    background: #ffffff;
    color: #1900b3;
}

.powered {
    margin-top: 200px;
    display: flex;
    align-items: center;
    gap: 40px;
}

.powered p {
    font-size: 20px;
    font-weight: 600;
}

.images {
    display: flex;
    align-items: center;
    gap: 20px;
}

.images img {
    height: 36px;
}

.image {
    position: absolute;
    right: -250px;
    height: 100vh;
    top: 0;
    z-index: -1;
}

.image img {
    height: 100%;
}
</style>
