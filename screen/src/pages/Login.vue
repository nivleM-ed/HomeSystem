<template>
  <div class="content">
    <div class="container-fluid" style="background-color: lightblue">
      <div class="center-screen">
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
        </card>
      </div>
    </div>
  </div>
</template>
<script>
import Card from "src/components/Cards/Card.vue";
import userApi from "src/api/users_api.js";
import {
  CONST
} from 'src/api/const';
const url = CONST.CONST_URL.concat('/users/');

export default {
  components: {
    Card
  },
  data() {
    return {
      password: "",
      username: "",
    };
  },
  async created() {
    console.log(url)
  },
  methods: {
    async login() {
      try {
        const log = await userApi.login(this.username, this.password);
        console.log(log)
        console.log(this.userObj)
        if(log.err) {
          alert(log.err)
        } else {
          this.$router.push("/main");
        }
        
      } catch (err) {
        this.error = err.message
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
