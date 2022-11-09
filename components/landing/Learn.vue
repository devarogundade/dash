<template>
<section id="learn">
    <div class="app-width">
        <h3 class="heading">Step by Step Guide</h3>

        <div class="items">
            <div class="item">
                <h3>Automatic loan reminder</h3>
                <p>You don't have to manually reminder your contacts to repay their loan or when to repay their loans, its features comes with dash right out of the box.</p>
            </div>
            <div class="item">
                <h3>Safe lending</h3>
                <p>
                    Assessing people for loan is not possible except your are a bank organization, dash protects far better than natural lending by setting a min credit score on your liquidity, and allowing only a contact that is not already on a loan to take another loan from you.
                    <br> <br>
                    So if you want to safely lending out funds to people, dash is the right choice for you.
                </p>
            </div>
            <div class="item">
                <h3>Immutable</h3>
                <p>
                    On liquidities and loans transactions are recorded on the blockchain, with give to a full tracking and back logs of old activities. This can be very useful for resolving disputes between you and contacts.
                </p>
            </div>
            <div class="item">
                <h3>No more stress</h3>
                <p>Now all your have to do is added your friends, family or colleagues to your contact list and relax. Your contact get the loan they needed on time without disturbing you.</p>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding-top: 200px;
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
