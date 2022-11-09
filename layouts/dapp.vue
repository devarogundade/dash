<template>
<div class="dapp">
    <!-- header -->
    <DappHeader class="xHead" />

    <!-- view -->
    <Nuxt class="xNuxt" />

    <!-- pops -->
    <Success />
    <Failure />
    <PickCoin />
    <Profile />
    <Transaction />
</div>
</template>

<script>
export default {
    async mounted() {
        const address = await this.$auth.connectToMetaMask();
        if (address) {
            this.$firestore.callback('reminders', 'address', '==', address.toUpperCase(), (data) => {
                this.$notifier.notify({
                    title: 'Loan reminder',
                    body: data.message
                })
            })
        }
    }
}
</script>

<style scoped>
.dapp {
    display: flex;
}

.xNuxt {
    width: 100%;
}
</style>
