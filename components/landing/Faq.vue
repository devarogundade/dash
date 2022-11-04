<template>
<section>
    <div class="app-width">
        <h3 class="heading">Frequently Asked Questions</h3>
        <div class="faq">
            <div class="item">
                <h3>What is Dash?</h3>
                <p>Dash is a Peer 2 Peer lending and borrowing platform between a trusted network of people. Dash helps you manage how to lend friends, families, others.</p>
            </div>
            <div class="item">
                <h3>Why Dash?</h3>
                <p>So many times reaching an agreement with close friends and families on a loan is difficult and may not be repaid.</p>
            </div>
            <div class="item">
                <h3>Who can takes my loans?</h3>
                <p>Only your trusted contact list can see and take your loans.</p>
            </div>
            <div class="item">
                <h3>Can I take two loans?</h3>
                <p>No, you can't take two loans simultaneously.</p>
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

.app-width {
    width: 1000px;
}

section .heading {
    font-size: 40px;
    text-align: center;
    margin-bottom: 40px;
}

.item {
    padding: 40px 0;
    border-bottom: 1px solid #ccc;
}

.item h3 {
    font-size: 24px;
    margin-bottom: 20px;
}

.item p {
    font-size: 18px;
    line-height: 24px;
}

.item:last-child {
    border-bottom: none;
}
</style>
