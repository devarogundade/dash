<template>
<div class="box" v-if="transaction">
    <p>View transaction on explorer</p>
    <a target="_blank" :href="`https://testnet.ftmscan.com/tx/${transaction}`">
        {{
          transaction.substring(0, 12) +
          "..." +
          transaction.substring(transaction.length - 12, transaction.length)
        }}
    </a>
</div>
</template>

<script>
export default {
    data() {
        return {
            transaction: null
        }
    },
    created() {
        $nuxt.$on('trx', (txHash) => {
            this.transaction = txHash

            setTimeout(() => {
                this.transaction = null
            }, 10000);
        })
    }
}
</script>

<style scoped>
.box {
    position: fixed;
    bottom: 30px;
    padding: 30px;
    border-radius: 20px;
    right: 30px;
    width: 350px;
    max-width: 100%;
    background: rgb(11, 85, 177);
}

p {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 10px;
    color: #fff;
}

a {
    text-decoration: underline;
    color: #ff9d05;
    font-size: 16px;
}

@media screen and (max-width: 700px) {
    .box {
        bottom: 0;
        right: 0;
        width: 100%;
    }
}
</style>
