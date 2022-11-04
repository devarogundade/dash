<template>
<section>
    <div class="i-app-width">
        <div class="container">
            <div class="form">
                <div class="tabs">
                    <div :class="tab == 1 ? 'item item-active' : 'item'" v-on:click="tab = 1">
                        Add
                    </div>
                    <div :class="tab == 2 ? 'item item-active' : 'item'" v-on:click="tab = 2">
                        Remove
                    </div>
                </div>

                <div class="from input">
                    <input type="text" placeholder="Amount">
                    <div class="token">
                        <img src="" alt="">
                        <p>BNB</p>

                    </div>
                </div>

                <div class="to input">
                    <input type="text" placeholder="Interest rate (%)">
                    <div class="token">
                        <img src="" alt="">
                        <p>DASH</p>

                    </div>
                </div>

                <div class="label">Take out</div>
                <div class="flex">
                    <div class="to input">
                        <input type="text" placeholder="Min">
                        <div class="token">
                            <p>BNB</p>
                        </div>
                    </div>
                    <div class="to input">
                        <input type="text" placeholder="Max">
                        <div class="token">
                            <p>BNB</p>
                        </div>
                    </div>
                </div>

                <div class="label">Duration</div>
                <div class="flex">
                    <div class="to input">
                        <input type="text" placeholder="Min">
                        <div class="token">
                            <p>Days</p>
                        </div>
                    </div>
                    <div class="to input">
                        <input type="text" placeholder="Max">
                        <div class="token">
                            <p>Days</p>
                        </div>
                    </div>
                </div>

                <div class="to input">
                    <input type="text" placeholder="Minimum credit score">
                    <div class="token">
                        <p>800</p>
                    </div>
                </div>

                <div class="price">
                    1 BNB = 1 BNBx ($1.43)
                </div>

                <div class="action">Add To Liquidity</div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
export default {
    data() {
        return {
            tab: 1
        }
    }
}
</script>

<style scoped>
.container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    padding: 150px 0;
}

.form {
    width: 450px;
    border-radius: 30px;
    padding: 40px;
    box-shadow: 0 6px 10px #CCC;
    height: fit-content;
}

.tabs {
    display: flex;
    align-items: center;
    border-radius: 10px;
    width: fit-content;
    margin-bottom: 40px;
}

.tabs .item {
    height: 40px;
    min-width: 60px;
    padding: 0 20px;
    display: flex;
    align-items: center;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    border-radius: 10px;
}

.item-active {
    background: #000;
    color: #ffffff;
}

.input {
    display: flex;
    align-items: center;
    border: 1px solid #ccc;
    box-shadow: 0 4px 8px #CCC;
    border-radius: 10px;
    padding: 10px;
    margin-bottom: 20px;
}

.input input {
    width: 100%;
    background: transparent;
    font-size: 20px;
    font-weight: 600;
    padding-right: 20px;
    height: 100%;
    border: none;
    outline: none;
}

.input .token {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

.label {
    font-size: 16px;
    margin-bottom: 4px;
    font-weight: 600;
}

.price {
    margin: 30px 0;
    text-align: center;
    font-size: 18px;
}

.action {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 40px;
    border-radius: 10px;
    background: #1900b3;
    font-size: 16px;
    font-weight: 600;
    color: #ff9d05;
}

.flex {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
}
</style>
