<template>
  <div>
    <div class="flex-container">
      <h2>Register</h2>
      <div>
        <img
          v-if="profileUrl"
          :src="profileUrl"
          style="width: 250px; max-width: 250px"
        />
      </div>
      <button
        :style="{ border: !profile && isSubmit ? '1px solid red' : '' }"
        @click="$refs.fileInput.click()"
      >
        Upload new image
      </button>
      <input
        accept="image/x-png,image/gif,image/jpeg"
        style="display: none"
        type="file"
        ref="fileInput"
        @change="setProfile"
      />
      <input
        :style="{
          border:
            (!username || isInvalidateUsername) && isSubmit
              ? '1px solid red'
              : '',
        }"
        v-model="username"
        placeholder="Username"
        @keyup.enter="register"
      />
      <input
        :style="{
          border:
            (!password || isInvalidatePassword) && isSubmit
              ? '1px solid red'
              : '',
        }"
        v-model="password"
        placeholder="Password"
        type="password"
        @keyup.enter="register"
      />
      <div class="flex-input">
        <input
          :style="{ border: !firstName && isSubmit ? '1px solid red' : '' }"
          style="flex: 1"
          v-model="firstName"
          placeholder="First Name"
          @keyup.enter="register"
        />
        <input
          :style="{ border: !lastName && isSubmit ? '1px solid red' : '' }"
          style="flex: 1"
          v-model="lastName"
          placeholder="Last Name"
          @keyup.enter="register"
        />
      </div>
      <div class="flex-button">
        <button style="flex: 1" @click="register">Register</button>
        <button style="flex: 1" @click="cancle">Cancle</button>
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
      firstName: "",
      lastName: "",
      profile: null,
      profileUrl: null,
      isSubmit: false,
      isFail: false,
      isInvalidateUsername: false,
      isInvalidatePassword: false,
      errorMessage: "",
    };
  },

  name: "Register",

  components: {
    Alert,
  },

  methods: {
    async setProfile(event) {
      this.profileUrl = URL.createObjectURL(event.target.files[0]);
      this.profile = event.target.files[0];
    },

    async register() {
      this.isSubmit = true;

      let isInvalid = false;

      const usernameRegex = new RegExp("^[A-Za-z0-9_]{6,12}$");
      if (!usernameRegex.test(this.username)) {
        this.isInvalidateUsername = true;
        isInvalid = true;
      } else {
        this.isInvalidateUsername = false;
      }

      const passwordRegex = new RegExp("^(?=.*[a-zA-Z])(?=.*[0-9])(?=.{6,})");
      if (!passwordRegex.test(this.password)) {
        this.isInvalidatePassword = true;
        isInvalid = true;
      } else {
        this.isInvalidatePassword = false;
      }

      if (isInvalid) {
        this.isFail = true;
        switch (true) {
          case this.isInvalidateUsername && !this.isInvalidatePassword:
            this.errorMessage =
              "Username can contain A-Z, a-z, 0-9, _, between 6 and 12 long";
            break;
          case !this.isInvalidateUsername && this.isInvalidatePassword:
            this.errorMessage =
              "Password needs include a number, a character and at least 6 long";
            break;
          default:
            this.errorMessage = `Username can contain A-Z, a-z, 0-9, _, between 6 and 12 long
                 Password needs include a number, a character and at least 6 long`;
        }
        return;
      }

      if (
        !this.username ||
        !this.password ||
        !this.firstName ||
        !this.lastName ||
        !this.profile
      ) {
        this.isFail = true;
        this.errorMessage = "Please fill in the information";
        return;
      }

      try {
        const { data } = await axios.post(
          "https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/",
          {
            user: {
              username: this.username,
              password: this.password,
              firstName: this.firstName,
              lastName: this.lastName,
            },
          }
        );

        let fromData = new FormData();
        fromData.append("file", this.profile);

        await axios.post(
          `https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/${data.user._id}/profile`,
          fromData,
          {
            headers: {
              Authorization: "Bearer " + data.user.token,
              "Content-Type": "image/png",
            },
          }
        );

        localStorage.setItem("token", data.user.token);
        localStorage.setItem("userID", data.user._id);

        this.$router.push("/user");
      } catch (error) {
        this.isFail = true;

        switch (error.response.status) {
          case 400:
            this.errorMessage = "Invalid request";
            break;
          case 409:
            this.errorMessage = "Username is duplicated";
            break;
          default:
            this.errorMessage = "Something wrong";
        }
      }
    },

    async cancle() {
      this.$router.push("/login");
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
