<template>
  <div>
    <div class="flex-container">
      <h2>Login</h2>
      <input v-model="username" placeholder="Username" @keyup.enter="login" />
      <input
        v-model="password"
        placeholder="Password"
        type="password"
        @keyup.enter="login"
      />
      <div class="flex-button">
        <button style="flex: 1" @click="login">Login</button>
        <button style="flex: 1" @click="register">Register</button>
      </div>
      <Alert :isShow="isFail" :message="errorMessage" />
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Alert from "../components/Alert.vue";

export default {
  data() {
    return {
      username: "",
      password: "",
      isFail: false,
      errorMessage: "",
    };
  },

  name: "Login",

  components: {
    Alert,
  },

  methods: {
    async login() {
      try {
        const { data } = await axios.post(
          "https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/login",
          {
            username: this.username,
            password: this.password,
          }
        );

        localStorage.setItem("token", data.user.token);
        localStorage.setItem("userID", data.user._id);

        this.$router.push("/user");
      } catch (error) {
        this.isFail = true;

        switch (error.response.status) {
          case 401:
            this.errorMessage = "Username or password is incorrect";
            break;
          case 404:
            this.errorMessage = "User not found";
            break;
          default:
            this.errorMessage = "Something wrong";
        }
      }
    },
    async register() {
      this.$router.push("/register");
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
.flex-input {
  display: flex;
}
.flex-button {
  display: flex;
}
</style>
