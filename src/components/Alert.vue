<template>
  <div v-if="isShow" class="alert">
    <p class="incorrect">{{ message }}</p>
  </div>
</template>

<script>
export default {
  name: "User",
  props: {
    message: String,
    isShow: Boolean,
  },
};
</script>

<style>
.alert {
  display: flex;
  justify-content: center;
}
.incorrect {
  margin: 0px;
  color: red;
  font-size: 16px;
}
</style>
