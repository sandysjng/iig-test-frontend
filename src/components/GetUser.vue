<template>
  <div v-if="isShow" class="flex-container">
    <div style="margin: auto">
      <img class="profile-img" :src="profile" />
      <p style="color: grey">{{ username }}</p>
      <h2>{{ firstName }} {{ lastName }}</h2>
    </div>
    <div class="flex-button">
      <button style="flex: 1" @click="update">Edit</button>
      <button style="flex: 1" @click="updatePassword">Change Password</button>
    </div>
    <div class="flex-button">
      <button style="flex: 1" @click="logout">Logout</button>
    </div>
    <Alert :isShow="isFail" :message="errorMessage" />
  </div>
</template>

<script>
import axios from "axios";
import Alert from "./Alert.vue";

export default {
  name: "User",

  props: {
    isShow: Boolean,
  },

  components: {
    Alert,
  },

  data() {
    return {
      id: localStorage.getItem("userID"),
      username: "",
      firstName: "",
      lastName: "",
      profile: null,
      isFail: false,
      errorMessage: "",
    };
  },

  mounted() {
    this.getUser();
  },

  methods: {
    async getUser() {
      try {
        const { data: userData } = await axios.get(
          `https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/${this.id}`,
          {
            headers: {
              Authorization: "Bearer " + localStorage.getItem("token"),
            },
          }
        );

        this.username = userData.user.username;
        this.firstName = userData.user.firstName;
        this.lastName = userData.user.lastName;

        const tmp = await axios.get(
          `https://iig-test-backend-cggbvvsruq-as.a.run.app/api/user/${this.id}/profile`,
          {
            headers: {
              Authorization: "Bearer " + localStorage.getItem("token"),
            },
          }
        );

        this.profile = tmp.config.url;
      } catch (error) {
        this.isFail = true;

        switch (error.response.status) {
          case 400:
            this.errorMessage = "Invalid request";
            break;
          case 404:
            this.errorMessage = "User not found";
            break;
          default:
            this.errorMessage = "Something wrong";
        }
      }
    },

    async update() {
      this.$emit("startUpdate");
    },

    async updatePassword() {
      this.$emit("startUpdatePassword");
    },

    async logout() {
      this.$emit("logout");
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
.flex-button {
  display: flex;
}
.profile-img {
  width: 250px;
  max-width: 250px;
}
</style>
