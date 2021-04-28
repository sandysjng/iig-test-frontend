<template>
  <div v-if="isShow">
    <div class="flex-container">
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
        @keyup.enter="update"
      />
      <div class="flex-input">
        <input
          :style="{
            border: !firstName && isSubmit ? '1px solid red' : '',
          }"
          style="flex: 1"
          v-model="firstName"
          placeholder="First Name"
          @keyup.enter="update"
        />
        <input
          :style="{
            border: !lastName && isSubmit ? '1px solid red' : '',
          }"
          style="flex: 1"
          v-model="lastName"
          placeholder="Last Name"
          @keyup.enter="update"
        />
      </div>
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
      token: localStorage.getItem("token"),
      username: "",
      firstName: "",
      lastName: "",
      profile: null,
      profileUrl: null,
      isSubmit: false,
      isFail: false,
      errorMessage: "",
      isInvalidateUsername: false,
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
    async setProfile(event) {
      this.profileUrl = URL.createObjectURL(event.target.files[0]);
      this.profile = event.target.files[0];
    },

    async update() {
      this.isSubmit = true;

      const usernameRegex = new RegExp("^[A-Za-z0-9_]{6,12}$");
      if (!usernameRegex.test(this.username)) {
        this.isInvalidateUsername = true;
        this.isFail = true;
        this.errorMessage =
          "Username must be between 6 and 12 long and contain A-Z, a-z, 0-9, _";

        return;
      }

      if (
        !this.username ||
        !this.firstName ||
        !this.lastName ||
        !this.profile
      ) {
        this.isFail = true;
        this.errorMessage = "Please fill in the information";
        return;
      }

      try {
        await axios.put(
          `https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/${this.id}`,
          {
            user: {
              username: this.username,
              firstName: this.firstName,
              lastName: this.lastName,
            },
          },
          {
            headers: {
              Authorization: "Bearer " + localStorage.getItem("token"),
            },
          }
        );

        let fromData = new FormData();
        fromData.append("file", this.profile);

        await axios.post(
          `https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/${this.id}/profile`,
          fromData,
          {
            headers: {
              Authorization: "Bearer " + this.token,
              "Content-Type": "image/png",
            },
          }
        );

        this.clearData();

        this.$emit("finishUpdate");
      } catch (error) {
        this.isFail = true;

        switch (error.response.status) {
          case 400:
            this.errorMessage = "Invalid request";
            break;
          case 409:
            this.errorMessage = "Duplicated username";
            break;
          default:
            this.errorMessage = "Something wrong";
        }
      }
    },

    async cancle() {
      this.clearData();

      this.$emit("finishUpdate");
    },

    clearData() {
      this.username = "";
      this.firstName = "";
      this.lastName = "";
      this.profile = null;
      this.profileUrl = null;
      this.isSubmit = false;
      this.isFail = false;
      this.errorMessage = "";
      this.isInvalidateUsername = false;
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
