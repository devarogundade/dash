<template>
<section>

</section>
</template>

<script>
export default {
    async created() {
        this.$contract.init()
        $nuxt.$on('contract', (contract) => {
            this.getUser(contract)
        })
    },
    methods: {
        async getUser(contract) {
            const address = await this.$auth.connectToMetaMask()
            const user = await contract.users(address)
            console.log(user, Number(user.creditScore));
        }
    }
}
</script>
