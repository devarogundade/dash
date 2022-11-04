<template>
<section>
    <div class="app-width">
        <div class="grid">
            <div class="image">
                <img src="/images/token_astronaut.png" alt="">
            </div>
            <div class="text">
                <h3>DASH Token $DASH</h3>
                <p>$DASH is the native cryptocurrency of the this platform. Loan Interests are paid in $DASH while the loan capital
                    amount remains unchange.
                </p>
                <div class="action">Buy Now</div>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
    padding-top: 200px;
}

.grid {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    gap: 100px;
}

.image {
    width: 250px;
}

.image img {
    width: 100%;
}

.text {
    width: 600px;
}

.text h3 {
    font-size: 36px;
    margin-bottom: 20px;
}

.text p {
    line-height: 24px;
    font-size: 18px;
}

.action {
    height: 55px;
    width: 220px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    background: #ff9d05;
    font-size: 16px;
    font-weight: 600;
    color: #1900b3;
}
</style>
