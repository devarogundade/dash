<template>
<div class="container-x" id="roadmap">
    <div class="goals">
        <div class="timeline">
            <div class="container left">
                <div class="content">
                    <h2>Hackathon</h2>
                    <p>Minimum Viable Product (MVP) development, participate in the Moralis x Google hackathon.</p>
                </div>
            </div>
            <div class="container right">
                <div class="content">
                    <h2>Team Formation</h2>
                    <p>Project marketers, advisors, and engineers team formation, and project restructuring.</p>
                </div>
            </div>
            <div class="container left">
                <div class="content">
                    <h2>Testnet release and Community</h2>
                    <p>Testnet release, product testing, build community (discord, youtube, twitter and telegram).</p>
                </div>
            </div>
            <div class="container right">
                <div class="content">
                    <h2>$DASH Presale and Mainnet Launch</h2>
                    <p>Initial Coin Offering and V1 project launching.</p>
                </div>
            </div>
        </div>
    </div>
</div>
</template>

<style scoped>
.container-x {
    width: 100%;
    display: flex;
    justify-content: center;
    padding-top: 50px;
    padding-bottom: 200px;
}

.goals {
    width: 1000px;
    max-width: 100%;
}

.timeline {
    position: relative;
    width: 100%;
}

.timeline::after {
    content: '';
    position: absolute;
    width: 6px;
    background-color: #ff9d05;
    top: 0;
    bottom: 0;
    left: 50%;
    margin-left: -3px;
}

.container {
    padding: 10px 40px;
    position: relative;
    background-color: inherit;
    width: 50%;
}

.container::after {
    content: '';
    position: absolute;
    width: 25px;
    height: 25px;
    right: -17px;
    background-color: white;
    border: 4px solid #ff9d05;
    top: 15px;
    border-radius: 50%;
    z-index: 1;
}

.left {
    left: 0;
}

.right {
    left: 50%;
}

.left::before {
    content: " ";
    height: 0;
    position: absolute;
    top: 22px;
    width: 0;
    z-index: 1;
    right: 30px;
    border: medium solid white;
    border-width: 10px 0 10px 10px;
    border-color: transparent transparent transparent #EEE;
}

.right::before {
    content: " ";
    height: 0;
    position: absolute;
    top: 22px;
    width: 0;
    z-index: 1;
    left: 30px;
    border: medium solid white;
    border-width: 10px 10px 10px 0;
    border-color: transparent #EEE transparent transparent;
}

.right::after {
    left: -16px;
}

.content {
    padding: 20px 30px;
    background-color: #EEE;
    position: relative;
    border-radius: 6px;
}

.content p {
    margin-top: 20px;
}

@media screen and (max-width: 800px) {
    .container-x {
        padding-top: 20px;
        padding-bottom: 100px;
    }
}

@media screen and (max-width: 700px) {

    .timeline::after {
        left: 31px;
    }

    .container {
        width: 100%;
        padding-left: 70px;
        padding-right: 25px;
    }

    .container::before {
        left: 60px;
        border: medium solid white;
        border-width: 10px 10px 10px 0;
        border-color: transparent white transparent transparent;
    }

    .left::after,
    .right::after {
        left: 15px;
    }

    .right {
        left: 0%;
    }
}
</style>
