<template>
  <div v-if="isShow">
    <div class="flex-container">
      <input
        :style="{
          border: !password && isSubmit ? '1px solid red' : '',
        }"
        v-model="password"
        placeholder="Password"
        type="password"
        @keyup.enter="update"
      />
      <div class="flex-button">
        <button style="flex: 1" @click="update">Update</button>
        <button style="flex: 1" @click="cancle">Cancle</button>
      </div>
      <Alert :isShow="isFail" :message="errorMessage" />
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Alert from "./Alert.vue";

export default {
  data() {
    return {
      id: localStorage.getItem("userID"),
      password: "",
      isSubmit: false,
      isFail: false,
      errorMessage: "",
    };
  },

  props: {
    isShow: Boolean,
  },

  name: "Register",

  components: {
    Alert,
  },

  methods: {
    async update() {
      this.isSubmit = true;

      if (!this.password) {
        this.isFail = true;

        this.errorMessage = "Please insert your password";
        return;
      }

      const passwordRegex = new RegExp("^(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,})");
      if (!passwordRegex.test(this.password)) {
        this.isInvalidatePassword = true;
        this.isFail = true;
        this.errorMessage =
          "Password needs include a number, a character and at least 6 long";

        return;
      }

      if (this.password) {
        try {
          await axios.patch(
            `https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/${this.id}/password`,
            {
              password: this.password,
            },
            {
              headers: {
                Authorization: "Bearer " + localStorage.getItem("token"),
              },
            }
          );

          this.clearData();

          this.$emit("finishUpdatePassword");
        } catch (error) {
          this.isFail = true;

          switch (error.response.status) {
            case 400:
              this.errorMessage =
                "Password needs include a number, a character and at least 6 long";
              break;
            case 404:
              this.errorMessage = "User not found";
              break;
            case 409:
              this.errorMessage = "Password was used previously";
              break;
            default:
              this.errorMessage = "Something wrong";
          }
        }
      }
    },

    cancle() {
      this.clearData();

      this.$emit("finishUpdatePassword");
    },

    clearData() {
      this.password = "";
      this.isSubmit = false;
      this.isFail = false;
      this.errorMessage = "";
    },
  },
};
</script>

<style>
.flex-container {
  display: flex;
  flex-direction: column;
  width: 500px;
  max-width: 500px;
  margin-left: auto;
  margin-right: auto;
}
.flex-alert {
  display: flex;
}
.flex-input {
  display: flex;
}
.flex-button {
  display: flex;
}
</style>
