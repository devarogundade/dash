<template>
<div class="box" v-if="show">
    <div class="image">
        <img :src="data.photo" alt="">
    </div>
    <div class="details">
        <h3 class="name">{{ data.name }}</h3>
        <p class="username">{{ data.username }}</p>
        <div class="items">
            <div class="item">
                <p>Age</p>
                <p>{{ data.age.year }} - {{ data.age.month }}</p>
            </div>
            <div class="item">
                <p>Address</p>
                <p>{{ data.address }}</p>
            </div>
            <div class="item">
                <p>Wallet</p>
                <p>{{ data.id.substring(0, 5).toLowerCase()  }}...{{data.id.substring(data.id.length -5, data.id.length).toLowerCase() }}</p>
            </div>
        </div>
        <a :href="`tel: ${data.phone}`">
            <div class="phone">Call</div>
        </a>
        <div class="action" v-on:click="close()">Close</div>
    </div>
</div>
</template>

<script>
export default {
    data() {
        return {
            show: false,
            data: null
        }
    },
    created() {
        $nuxt.$on('contact', (data) => {
            this.show = true
            this.data = data
        })
    },
    methods: {
        close: function () {
            this.show = false
            this.data = null
        }
    }
}
</script>

<style scoped>
.box {
    width: 500px;
    border-radius: 30px;
    background: #FFFFFF;
    position: fixed;
    left: calc(50% + 150px);
    top: 50%;
    transform: translate(-50%, -50%);
    overflow: hidden;
    box-shadow: 0 4px 8px #ccc;
    z-index: 10;
}

img {
    height: 200px;
    object-fit: cover;
    width: 100%;
}

.details {
    padding: 40px;
}

.item {
    display: flex;
    height: 50px;
    align-items: center;
    justify-content: space-between;
}

.name {
    font-size: 24px;
}

.username {
    margin-bottom: 20px;
    font-weight: 600;
}

.item p {
    font-size: 16px;
}

.item p:last-child {
    font-weight: 600;
}

.phone {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 30px;
    border-radius: 10px;
    background: #0c3483;
    font-size: 18px;
    color: #FFFFFF;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
}

.action {
    height: 55px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 10px;
    border: 1px #000 solid;
    font-size: 18px;
    margin-top: 10px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
}
</style>
