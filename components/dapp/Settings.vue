<template>
<section>
    <div class="header">
        <div class="image">
            <img src="http://localhost:3000/images/students/5.jpg" alt="" />
        </div>
    </div>
    <div class="body">
        <div class="i-app-width">
            <div class="container">
                <div class="form">
                    <div class="from input">
                        <input type="text" placeholder="Full name">
                    </div>

                    <div class="to input">
                        <input type="text" placeholder="Email Address">
                    </div>

                    <div class="label">Age</div>
                    <div class="flex">
                        <div class="to input">
                            <input type="text" placeholder="1999">
                            <div class="token">
                                <p>Year</p>
                            </div>
                        </div>
                        <div class="to input">
                            <input type="text" placeholder="01">
                            <div class="token">
                                <p>Month</p>
                            </div>
                        </div>
                    </div>

                    <div class="label">Contact & Address</div>
                    <div class="flex">
                        <div class="to input">
                            <input type="text" placeholder="+123">
                            <div class="token">
                                <p>Phone</p>
                            </div>
                        </div>
                        <div class="to input">
                            <input type="text" placeholder="01 Street">
                            <div class="token">
                                <p>Address</p>
                            </div>
                        </div>
                    </div>

                    <div class="to input">
                        <input type="text" placeholder="@username">
                    </div>

                    <div class="action" v-on:click="$nuxt.$emit('success', {
                      title: 'Profile Updated',
                      message: 'You profile has been changed successfully!'
                    })">Update Profile</div>
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<script>
export default {
    data() {
        return {
            tab: 1,
        };
    },
};
</script>

<style scoped>
section {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
}

.header {
    height: 240px;
    width: 100%;
    display: flex;
    justify-content: center;
    position: relative;
    background: #CCEEFF;
}

.header .image {
    position: absolute;
    left: 50%;
    top: 80px;
    transform: translate(-50%, 0);
    height: 240px;
    width: 240px;
    border-radius: 50%;
    overflow: hidden;
}

.header img {
    height: 100%;
    width: 100%;
    object-fit: cover;
}

.header .text h3 {
    font-size: 24px;
    margin-top: 20px;
}

.header .text h2 {
    margin-top: 10px;
    font-size: 36px;
    color: #1900b3;
}

.body {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-top: 60px;
    padding-bottom: 60px;
}

.container {
    width: 100%;
    display: flex;
    justify-content: center;
    padding: 50px 0;
}

.form {
    width: 450px;
    height: fit-content;
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
