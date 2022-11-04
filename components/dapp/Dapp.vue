<template>
<section>
    <div class="i-app-width">
        <div class="history">
            <h3>Activity History</h3>
            <div class="toolbar">
                <div class="filter">
                    <i class="fi fi-br-search"></i>
                    <input type="text" placeholder="Search by Token name">
                </div>
            </div>
        </div>
    </div>
</section>
</template>

<style scoped>
section {
  padding: 60px 0;
}

.history>h3 {
  font-size: 30px;
}

.toolbar {
  margin-top: 20px;
}

.filter {
  width: 400px;
  height: 50px;
  display: flex;
  align-items: center;
  border: 1px #000 solid;
  border-radius: 10px;
  gap: 10px;
  padding: 0 20px;
}

.filter input {
  border: none;
  outline: none;
  font-size: 16px;
  font-weight: 500;
}

</style>
