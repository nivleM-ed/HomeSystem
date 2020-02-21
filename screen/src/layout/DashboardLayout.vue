<template>
  <div class="wrapper">
    <side-bar>
      <mobile-menu slot="content"></mobile-menu>
      <sidebar-link to="/main/overview">
        <i class="nc-icon nc-grid-45"></i>
        <p>Homepage</p>
      </sidebar-link>
      <sidebar-link to="/main/dataentry_recipe">
        <i class="nc-icon nc-simple-add"></i>
        <p>Add Recipe</p>
      </sidebar-link>
      <sidebar-link to="/main/search_recipe">
        <i class="nc-icon nc-chart-pie-35"></i>
        <p>search Recipe</p>
      </sidebar-link>
    </side-bar>
    <div class="main-panel">
      <top-navbar></top-navbar>

      <dashboard-content @click="toggleSidebar">

      </dashboard-content>

      <content-footer></content-footer>
    </div>
  </div>
</template>
<style lang="scss">

</style>
<script>
  import TopNavbar from './TopNavbar.vue'
  import ContentFooter from './ContentFooter.vue'
  import DashboardContent from './Content.vue'
  import MobileMenu from './MobileMenu.vue'
  export default {
    components: {
      TopNavbar,
      ContentFooter,
      DashboardContent,
      MobileMenu
    },
    methods: {
      toggleSidebar () {
        if (this.$sidebar.showSidebar) {
          this.$sidebar.displaySidebar(false)
        }
      }
    }
  }

</script>
