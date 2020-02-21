<template>
  <div class="content">
    <div class="container-fluid">
      <div v-if="!isMobile()">
        <div class="row">
          <div class="col-md-2">
            <div class="row mr-1">
              <card>
                <template slot="header">
                  <h4 class="card-title">Save Recipe</h4>
                  <p class="card-category">Keep your recipes easily</p>
                </template>
                <expendable-image src="img/addRecipe.PNG" alt="add_recipe" />
                <div class="stats mt-2">
                  Click on the picture to enlarge
                </div>
              </card>
            </div>

            <div class="row mr-1">
              <card>
                <template slot="header">
                  <h4 class="card-title">Update Recipe</h4>
                  <p class="card-category">Improve on your recipe</p>
                </template>
                <expendable-image src="img/updateRecipe.png" alt="add_recipe" />
                <div class="stats mt-2">
                  Click on the picture to enlarge
                </div>
              </card>
            </div>
          </div>

          <div class="col-md-2">
            <div class="row mr-1">
              <card>
                <template slot="header">
                  <h4 class="card-title">View Recipe</h4>
                  <p class="card-category">Follow your recipe</p>
                </template>
                <expendable-image src="img/viewRecipe.png" alt="add_recipe" />
                <div class="stats mt-2">
                  Click on the picture to enlarge
                </div>
              </card>
            </div>

            <div class="row mr-1">
              <card>
                <template slot="header">
                  <h4 class="card-title">Search Recipe</h4>
                  <p class="card-category">
                    Easily find for the recipe you want
                  </p>
                </template>
                <expendable-image src="img/searchRecipe.png" alt="add_recipe" />
                <div class="stats mt-2">
                  Click on the picture to enlarge
                </div>
              </card>
            </div>
          </div>

          <div class="col-md-8">
            <card>
              <template slot="header">
                <h4 class="card-title">Latest Recipes</h4>
                <p class="card-category">View the latest recipes</p>
              </template>

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
              <div v-else class="table-responsive">
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
        <card>
          <template slot="header">
            <h4 class="card-title">Latest Recipes</h4>
            <p class="card-category">View the latest recipes</p>
          </template>

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
          <div v-else class="table-responsive">
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
        </card>
        <div class="row text-center">
          <button
          type="submit"
          class="btn btn-warning btn-fill float-right mr-2"
          @click.prevent="toggleHide()"
        >
          View Tutorial
        </button>
        </div>
        <div v-bind:class="{ hide: togHide }">
          <div class="row">
            <card>
              <template slot="header">
                <h4 class="card-title">Search Recipe</h4>
                <p class="card-category">
                  Easily find for the recipe you want
                </p>
              </template>
              <expendable-image src="img/searchRecipe.png" alt="add_recipe" />
              <div class="stats mt-2">
                Click on the picture to enlarge
              </div>
            </card>
          </div>
          <div class="row">
            <card>
              <template slot="header">
                <h4 class="card-title">Save Recipe</h4>
                <p class="card-category">Keep your recipes easily</p>
              </template>
              <expendable-image src="img/addRecipe.PNG" alt="add_recipe" />
              <div class="stats mt-2">
                Click on the picture to enlarge
              </div>
            </card>
          </div>
          <div class="row">
            <card>
              <template slot="header">
                <h4 class="card-title">View Recipe</h4>
                <p class="card-category">Follow your recipe</p>
              </template>
              <expendable-image src="img/viewRecipe.png" alt="add_recipe" />
              <div class="stats mt-2">
                Click on the picture to enlarge
              </div>
            </card>
          </div>
          <div class="row">
            <card>
              <template slot="header">
                <h4 class="card-title">Update Recipe</h4>
                <p class="card-category">Improve on your recipe</p>
              </template>
              <expendable-image src="img/updateRecipe.png" alt="add_recipe" />
              <div class="stats mt-2">
                Click on the picture to enlarge
              </div>
            </card>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import ChartCard from "src/components/Cards/ChartCard.vue";
import StatsCard from "src/components/Cards/StatsCard.vue";
import LTable from "src/components/Table.vue";
import ExpendableImage from "src/components/ExpendableImage.vue";

import recipeApi from "src/api/recipe_api.js";
import recipeClass from "src/model/recipe_class.js";
import utils from "src/api/utils.js";

export default {
  components: {
    LTable,
    ChartCard,
    StatsCard,
    ExpendableImage
  },
  data() {
    return {
      tableColumns: ["Title", "Description"],
      recipeObj: new recipeClass(),
      recipe: {},
      error: "",
      togHide: false
    };
  },
  async created() {
    try {
      this.recipeObj.in_page = 1;
      if (this.isMobile()) {
        this.recipeObj.in_param_3 = 3;
      } else {
        this.recipeObj.in_param_3 = 5;
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
    viewRecipe(id) {
      let path = "/main/view_recipe?id=" + id;
      this.$router.push(path);
    },

    isMobile() {
      return utils.isMobile();
    },

    toggleHide() {
      if (this.togHide) {
        this.togHide = false;
      } else {
        this.togHide = true;
      }
    }
  }
};
</script>
<style>
.hide {
  /* visibility: hidden; */
  display: none
}
</style>
