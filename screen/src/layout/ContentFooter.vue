<template>
  <footer class="footer">
    <div class="container-fluid">
      <nav>
        <ul class="footer-menu">
          <li>
            <router-link :to="{ path: '/main' }"
              >Home System {{ versionF }}</router-link
            >
          </li>
        </ul>
      </nav>
      <!-- <div class="copyright text-center">
        &copy; Coded with
        <i class="fa fa-heart heart"></i> by
        <a href="https://binarcode.com" target="_blank">BinarCode</a>.
        Designed by <a href="https://www.creative-tim.com/?ref=pdf-vuejs" target="_blank">Creative Tim</a>.
      </div> -->
      <div class="copyright text-center">
        {{ versionB }}
      </div>
    </div>
  </footer>
</template>
<script>
import userApi from "src/api/users_api.js";
import { CONST } from "src/api/const.js";

export default {
  data() {
    return {
      versionB: "",
      versionF: " "
    };
  },
  async created() {
    this.versionB = await userApi.versionB();
    this.versionF = CONST.versionF;
  }
};
</script>
<style></style>
