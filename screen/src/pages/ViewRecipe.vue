<template>
  <card>
    <div
      v-if="error"
      style="background-color: #edd2d1"
      class="border border-danger rounded mt-3 p-2 text-center"
    >
      <h4 slot="header" class="card-title">{{ error }}</h4>
      <p v-if="error == 'Network Error'">
        If you see this, it means there is a problem with reaching the server
      </p>
      <p>Please contact the person in charge to fix this problem</p>
    </div>
    <div v-else>
      <form>
        <div v-if="!isMobile()">
          <div class="row ml-2">
            <div class="col-8">
              <div class="row">
                <h2 class="card-title">{{ recipe.title }}</h2>
              </div>
              <div class="row mt-3">
                {{ recipe.description }}
              </div>
              <div class="row">
                <card class="mt-3">
                  <div class="table-responsive">
                    <table class="table">
                      <thead>
                        <slot name="columns">
                          <tr>
                            <th>Ingredient</th>
                            <th>Quantity</th>
                            <th>Type</th>
                          </tr>
                        </slot>
                      </thead>
                      <tbody>
                        <tr v-for="item in recipe.ingredients" :key="item">
                          <slot :row="item">
                            <td>{{ item.ingredient }}</td>
                            <td>{{ item.quantity }}</td>
                            <td>{{ item.quantity_type }}</td>
                          </slot>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </card>
              </div>
            </div>
            <div class="col-4" style="max-width: 800px" v-if="recipe.pic_path">
              <expendable-image
                slot="image"
                :src="'img/uploads/' + recipe.pic_path"
                alt="pic_path"
                class="text-center border border-dark rounded p-2"
              />
            </div>
          </div>
        </div>
        <div v-else>
          <div class="row p-2">
            <h2 class="card-title">{{ recipe.title }}</h2>
          </div>
          <div class="row mt-3 p-2">
            {{ recipe.description }}
          </div>
          <div class="row" style="max-width: 800px" v-if="recipe.pic_path">
            <expendable-image
              slot="image"
              :src="'img/uploads/' + recipe.pic_path"
              alt="pic_path"
              class="text-center p-2"
            />
          </div>
          <card class="mt-3">
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <slot name="columns">
                    <tr>
                      <th>Ingredient</th>
                      <th>Quantity</th>
                      <th>Type</th>
                    </tr>
                  </slot>
                </thead>
                <tbody>
                  <tr v-for="item in recipe.ingredients" :key="item">
                    <slot :row="item">
                      <td>{{ item.ingredient }}</td>
                      <td>{{ item.quantity }}</td>
                      <td>{{ item.quantity_type }}</td>
                    </slot>
                  </tr>
                </tbody>
              </table>
            </div>
          </card>
        </div>

        <card class="mt-3">
          <div class="table-responsive">
            <table class="table">
              <thead>
                <slot name="columns">
                  <tr>
                    <th>Step</th>
                    <th>Description</th>
                  </tr>
                </slot>
              </thead>
              <tbody>
                <tr v-for="item in recipe.methods" :key="item">
                  <slot :row="item">
                    <td>{{ item.step }}</td>
                    <td>{{ item.description }}</td>
                  </slot>
                </tr>
              </tbody>
            </table>
          </div>
        </card>

        <div class="text-center" v-if="!isMobile()">
          <button
            type="submit"
            class="btn btn-warning btn-fill float-right"
            @click.prevent="updateRecipe"
          >
            Update Recipe
          </button>
        </div>
        <button
            type="submit"
            class="btn btn-warning btn-fill float-right mr-2"
            @click.prevent="$router.go(-1)"
          >
            Go back
          </button>
        <div class="stats mt-2" v-if="isMobile()">
          Recipe update disabled in mobile
        </div>
        <div class="clearfix"></div>
      </form>
    </div>
  </card>
</template>
<script>
import Card from "src/components/Cards/Card.vue";
import ExpendableImage from "src/components/ExpendableImage.vue";
import recipeApi from "src/api/recipe_api.js";
import recipeClass from "src/model/recipe_class.js";
import utils from "src/api/utils.js";

export default {
  components: {
    Card,
    ExpendableImage
  },
  data() {
    return {
      is_update: this.$route.query.id,
      test: "",
      recipe: {},
      recipeObj: new recipeClass(),
      error: ""
    };
  },
  async created() {
    try {
      this.recipeObj.in_param_2 = this.$route.query.id;
      this.recipeObj.in_page = 1;
      const search = await recipeApi.search(this.recipeObj.toJson());
      this.recipe = search.result[0][0];
      // this.recipe.pic_path = "1582202643265-mePhoto2.png";
    } catch (err) {
      this.error = err.message;
    }
  },
  methods: {
    updateRecipe() {
      let path = "/main/dataentry_recipe?id=" + this.$route.query.id;
      this.$router.push(path);
    },

    isMobile() {
      return utils.isMobile();
    }
  }
};
</script>
<style></style>
