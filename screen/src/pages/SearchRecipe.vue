<template>
  <div class="content">
    <div class="container-fluid">
      <card>
        <h4 slot="header" class="card-title">Search Recipe</h4>
        <form>
          <div class="row">
            <div class="col-sm">
              <base-input
                type="text"
                placeholder="Enter Recipe Title"
                v-model="in_param"
              >
              </base-input>
            </div>

            <div class="col-sm">
              <button
                type="submit"
                class="btn btn-info btn-fill"
                @click.prevent="searchRecipe"
              >
                Search
              </button>
            </div>
          </div>

          <div
            v-if="error"
            style="background-color: #edd2d1"
            class="border border-danger rounded mt-3 p-2 text-center"
          >
            <h4 slot="header" class="card-title">{{ error }}</h4>
            <p v-if="error == 'Network Error'">
              If you see this, it means there is a problem with reaching the
              server
            </p>
            <p>Please contact the person in charge to fix this problem</p>
          </div>

          <div v-else>
            <div v-if="!isMobile()">
              <div class="row">
                <div class="col-12">
                  <card class="card-plain">
                    <div class="table-responsive">
                      <table class="table">
                        <thead>
                          <slot name="columns">
                            <tr>
                              <th v-for="column in tableColumns" :key="column">
                                {{ column }}
                              </th>
                            </tr>
                          </slot>
                        </thead>
                        <tbody>
                          <tr v-for="item in recipe" :key="item.id">
                            <slot :row="item">
                              <td style="width: 15%">{{ item.title }}</td>
                              <td style="width: 80%">{{ item.description }}</td>
                              <td>
                                <button
                                  class="btn btn-info btn-fill"
                                  @click.prevent="viewRecipe(item.id)"
                                >
                                  View Recipe
                                </button>
                              </td>
                            </slot>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </card>
                </div>
              </div>
            </div>
            <div v-else>
              <card v-for="item in recipe" :key="item.id">
                <h5 slot="header" class="card-title">{{ item.title }}</h5>
                <p class="card-category">{{ item.description }}</p>
                <button
                  class="btn btn-info btn-fill mt-2"
                  @click.prevent="viewRecipe(item.id)"
                >
                  View Recipe
                </button>
              </card>
            </div>
            <n-pagination
              class="justify-content-center mt-3"
              :page-count="total_page"
              v-model="page"
            ></n-pagination>
          </div>
          <div class="clearfix"></div>
        </form>
      </card>
    </div>
  </div>
</template>
<script>
import Card from "src/components/Cards/Card.vue";
import LTable from "src/components/Table.vue";
import Pagination from "src/components/Pagination.vue";
import recipeApi from "src/api/recipe_api.js";
import recipeClass from "src/model/recipe_class.js";
import utils from "src/api/utils.js";

export default {
  components: {
    Card,
    LTable,
    [Pagination.name]: Pagination
  },
  data() {
    return {
      tableColumns: ["Title", "Description"],
      in_param: null,
      recipeObj: new recipeClass(),
      recipe: {},
      page: 1,
      total_page: 1,
      error: ""
    };
  },
  async created() {
    try {
      // alert(process.env.VUE_APP_API_URL)
      this.setClass();
      this.recipeObj.in_page = this.page;
      if (this.isMobile()) {
        this.recipeObj.in_param_3 = 3;
      }
      const search = await recipeApi.search(this.recipeObj.toJson());
      this.recipe = search.result[0].map(recipes => ({
        ...recipes
      }));
      this.total_page = search.result[1];
    } catch (err) {
      this.error = err.message;
    }
  },
  methods: {
    async searchRecipe() {
      console.log("Searching recipe...");
      console.log("Search Input:", this.in_param);
      try {
        this.setClass();
        this.recipeObj.in_page = this.page;
        if (this.isMobile()) {
          this.recipeObj.in_param_3 = 3;
        }
        const search = await recipeApi.search(this.recipeObj.toJson());
        this.recipe = search.result[0].map(recipes => ({
          ...recipes
        }));
        this.total_page = search.result[1];
      } catch (err) {
        this.error = err.message;
      }
    },

    viewRecipe(id) {
      let path = "/main/view_recipe?id=" + id;
      this.$router.push(path);
      //console.log(this.$route.query.id)
    },

    async setClass() {
      this.recipeObj.in_param_1 = this.in_param;
    },

    nextPage() {
      page = this.recipeObj.nextPage();
    },

    prevPage() {
      page = this.recipeObj.prevPage();
    },

    isMobile() {
      return utils.isMobile();
    }
  },
  watch: {
    page: async function(val) {
      if (!isNaN(val)) {
        console.log("Change page...");
        console.log("Search Input:", this.in_param);
        try {
          this.setClass();
          this.recipeObj.in_page = val;
          if (this.isMobile()) {
            this.recipeObj.in_param_3 = 3;
          }
          const search = await recipeApi.search(this.recipeObj.toJson());
          this.recipe = search.result[0].map(recipes => ({
            ...recipes
          }));
          this.total_page = search.result[1];
        } catch (err) {
          this.error = err.message;
        }
      }
    }
  }
};
</script>
<style></style>
