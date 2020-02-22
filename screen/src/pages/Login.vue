<template>
  <div class="content">
    <div class="container-fluid" style="background-color: lightblue">
      <div class="center-screen">
        <card
          v-if="err"
          style="background-color: #edd2d1"
          class="border border-danger rounded text-center"
        >
          <div>
            <h4 slot="header" class="card-title">You are not logged in</h4>
            <p>Please log in first</p>
          </div>
        </card>

        <card>
          <h4 slot="header" class="card-title">Login</h4>
          <form style="padding: 40px">
            <div class="row">
              <base-input
                type="username"
                label="username"
                :disabled="false"
                placeholder="Enter username"
                v-model="username"
              >
              </base-input>
            </div>
            <div class="row">
              <base-input
                type="password"
                label="password"
                :disabled="false"
                placeholder="Enter password"
                v-model="password"
              >
              </base-input>
            </div>
            <div class="text-center">
              <button
                type="submit"
                class="btn btn-info btn-fill float"
                @click.prevent="login"
              >
                Enter
              </button>
            </div>
          </form>
          <div class="stats float-right">
            {{ versionB }}
          </div>
        </card>
      </div>
    </div>
  </div>
</template>
<script>
import Card from "src/components/Cards/Card.vue";
import userApi from "src/api/users_api.js";
import { CONST } from "src/api/const";
const url = CONST.CONST_URL.concat("/users/");

export default {
  components: {
    Card
  },
  data() {
    return {
      password: "",
      username: "",
      versionB: "",
      error: "",
      err: this.$route.query.err
    };
  },
  async created() {
    try {
      let check_logged = await userApi.check_logged();
      console.log("Check Login: ", check_logged);
      if (!check_logged.err) {
        this.$router.push("/main");
      }
      this.versionB = await userApi.versionB();
    } catch (err) {
      this.error = err.message;
    }
  },
  methods: {
    async login() {
      try {
        const log = await userApi.login(this.username.trim(), this.password);
        console.log(log);
        if (log.err) {
          alert(log.err);
        } else {
          this.$router.push("/main");
        }
      } catch (err) {
        this.error = err.message;
      }
    }
  }
};
</script>
<style>
.center-screen {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  min-height: 100vh;
}
</style>
