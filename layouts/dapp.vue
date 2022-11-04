<template>
<div class="dapp">
    <DappHeader class="xHead" />
    <Nuxt class="xNuxt" />

    <Success />
    <Failure />
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
