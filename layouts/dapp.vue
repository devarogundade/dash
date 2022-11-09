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

<style scoped>
.dapp {
    display: flex;
}

.xNuxt {
    width: 100%;
}
</style>
