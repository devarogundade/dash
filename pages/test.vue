<template>
<section>

</section>
</template>

<script>
import contract from 'truffle-contract'
export default {
    async created() {
        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.getUser(contract)
        })
    },
    methods: {
        async getUser(contract) {
            console.log(contract);
            const address = await this.$auth.connectToMetaMask()
            const user = await contract.users(address)
            const liquidity = await contract.liquidities("0xBe25761ae1F024A991ed081532B3C89Df7F28d02", 0)
            console.log(user, this.$utils.fromWei(liquidity.amount));
        }
    }
}
</script>
