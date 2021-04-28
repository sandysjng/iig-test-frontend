<template>
  <div class="flex-container">
    <h2>User</h2>
    <GetUser
      ref="getUserComponent"
      :isShow="!isUpdate && !isUpdatePassword"
      @startUpdate="startUpdate()"
      @startUpdatePassword="startUpdatePassword()"
      @logout="logout()"
    />
    <UpdateUser
      :isShow="isUpdate && !isUpdatePassword"
      @finishUpdate="finishUpdate()"
    />
    <UpdateUserPassword
      :isShow="!isUpdate && isUpdatePassword"
      @finishUpdatePassword="finishUpdatePassword()"
    />
  </div>
</template>

<script>
import GetUser from "../components/GetUser.vue";
import UpdateUser from "../components/UpdateUser.vue";
import UpdateUserPassword from "../components/UpdateUserPassword.vue";

export default {
  name: "User",

  data() {
    return {
      id: localStorage.getItem("userID"),
      isUpdate: false,
      isUpdatePassword: false,
    };
  },
  components: {
    GetUser,
    UpdateUser,
    UpdateUserPassword,
  },

  methods: {
    async startUpdate() {
      this.isUpdate = true;
    },
    async finishUpdate() {
      this.isUpdate = false;
      this.$refs.getUserComponent.getUser();
    },

    async startUpdatePassword() {
      this.isUpdatePassword = true;
    },
    async finishUpdatePassword() {
      this.isUpdatePassword = false;
    },

    async logout() {
      localStorage.removeItem("token");
      localStorage.removeItem("userID");
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
.flex-button {
  display: flex;
}
</style>
