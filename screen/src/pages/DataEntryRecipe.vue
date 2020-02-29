<template>
  <div class="content">
    <div class="container-fluid">
      <card v-if="!isMobile()">
        <h4 slot="header" class="card-title">Add Recipe</h4>
        <form>
          <div
            v-if="error"
            style="background-color: #edd2d1"
            class="border border-danger rounded m-3 p-2 text-center"
          >
            <h4 slot="header" class="card-title">{{ error }}</h4>
            <p v-if="error == 'Network Error'">
              If you see this, it means there is a problem with reaching the
              server
            </p>
            <p>Please contact the person in charge to fix this problem</p>
          </div>
          <div
            v-if="man_desc || man_title || man_ing || man_step"
            style="background-color: #edd2d1"
            class="border border-danger rounded m-3 p-2 text-center"
          >
            <h4 slot="header" class="card-title">
              No input for mandatory fields
            </h4>
            <p class="text-center">
              Please fill in the parts indicated with a red box
            </p>
          </div>
          <div class="row">
            <div class="col-9">
              <div class="row">
                <div class="col-6">
                  <h5 slot="header" class="card-title">Title</h5>
                  <base-input
                    type="text"
                    placeholder="Title"
                    v-model="title"
                    v-bind:class="{
                      border: man_title,
                      'border-danger': man_title,
                      rounded: man_title
                    }"
                  >
                  </base-input>
                </div>
                <div class="col-6">
                  <h5 slot="header" class="card-title" v-if="pic_path">
                    Change Picture
                  </h5>
                  <h5 slot="header" class="card-title" v-else>
                    Upload Picture
                  </h5>
                  <form
                    enctype="multipart/form-data"
                    class="form-control"
                    style="width: 90%"
                  >
                    <input
                      type="file"
                      ref="file"
                      @change="onSelect"
                      accept="image/jpeg, image/png, image/jpg"
                      label="Upload picture"
                    />
                  </form>
                </div>
              </div>
              <div class="row">
                <div class="col-lg">
                  <h5 slot="header" class="card-title">Description</h5>
                  <base-input
                    type="text"
                    placeholder="Description"
                    v-model="description"
                    v-bind:class="{
                      border: man_desc,
                      'border-danger': man_desc,
                      rounded: man_desc
                    }"
                  >
                  </base-input>
                </div>
              </div>
            </div>

            <div class="col-3" v-if="pic_path" style="max-width=100px">
              <expendable-image
                slot="image"
                :src="'img/uploads/' + pic_path"
                alt="pic_path"
                class="text-center border border-dark rounded p-2"
              />
            </div>
          </div>

          <card>
            <h5 slot="header" class="card-title">Ingredients</h5>
            <table :id="'ingredient'">
              <tr>
                <th>Ingredient</th>
                <th>Quantity</th>
                <th>Type</th>
              </tr>
              <tr v-for="(items, index) in item" v-bind:key="index" :id="index">
                <td style="width: 50%">
                  <base-input
                    v-model="items.ingredient"
                    :id="'ingredient_' + index"
                    :ref="'ingredient_' + index"
                  ></base-input>
                </td>
                <td style="width: 10%">
                  <base-input v-model="items.quantity"></base-input>
                </td>
                <td style="width: 15%">
                  <base-input>
                    <select class="form-control" v-model="items.quantity_type">
                      <option disabled value>Select One</option>
                      <option>-</option>
                      <option>Grams</option>
                      <option>mL</option>
                      <option>Teaspoon/s</option>
                      <option>Tablespoon/s</option>
                      <option>Cup/s</option>
                      <option>Oz</option>
                    </select>
                  </base-input>
                </td>
                <td class="align-top px-2">
                  <button
                    class="btn btn-danger btn-fill text-center"
                    @click.prevent="remove(item, index)"
                  >
                    Remove
                  </button>
                </td>
              </tr>
            </table>

            <button
              class="btn btn-info btn-fill float"
              @click.prevent="addNewItem()"
            >
              Add Ingredient
            </button>
          </card>

          <card>
            <h5 slot="header" class="card-title">Methods</h5>
            <table :id="'step'">
              <tr>
                <th>Step</th>
                <th>Description</th>
              </tr>
              <tr
                v-for="(methods, index) in method"
                v-bind:key="index"
                :id="index"
              >
                <td style="width: 5%">
                  {{ (methods.step = index + 1) }}
                </td>
                <td style="width: 90%">
                  <textarea
                    class="form-control"
                    placeholder="Write step here"
                    rows="3"
                    v-model="methods.description"
                    :id="'step_' + index"
                    :ref="'step_' + index"
                  ></textarea>
                </td>
                <td class="align-top px-2" style="width: 10%">
                  <button
                    class="btn btn-danger btn-fill text-center"
                    @click.prevent="remove(method, index)"
                  >
                    Remove
                  </button>
                </td>
              </tr>
            </table>

            <button
              class="btn btn-info btn-fill float mt-2"
              @click.prevent="addNewStep()"
            >
              Add Step
            </button>
          </card>
          <div class="row">
            <div class="p-2 text-center">
              <button
                type="submit"
                class="btn btn-warning btn-fill float-right"
                @click.prevent="$router.go(-1)"
                v-if="is_update"
              >
                Go Back
              </button>
            </div>
            <div class="p-2 text-center">
              <button
                type="submit"
                class="btn btn-warning btn-fill float-right"
                @click.prevent="updateRecipe()"
                v-if="is_update"
              >
                Update Recipe
              </button>
              <button
                type="submit"
                class="btn btn-success btn-fill float-right"
                @click.prevent="addRecipe()"
                v-else
              >
                Add Recipe
              </button>
            </div>
            <div class="p-2 text-center">
              <button
                type="submit"
                class="btn btn-danger btn-fill float-right"
                @click.prevent="deleteRecipe()"
                v-if="is_update"
              >
                Delete Recipe
              </button>
            </div>
          </div>
          <div class="clearfix"></div>
        </form>
      </card>
      <card v-else>
        <p>Adding recipes for mobile is still in development</p>
        <img src="img/patience_20200222.png" alt="" class="img-fluid" />
      </card>
    </div>
  </div>
</template>
<script>
import Card from "src/components/Cards/Card.vue";
import ExpendableImage from "src/components/ExpendableImage.vue";
import recipeApi from "src/api/recipe_api.js";
import recipeClass from "src/model/recipe_class.js";
import userApi from "src/api/users_api.js";
import { CONST } from "src/api/const.js";
import utils from "src/api/utils.js";
import axios from "axios";

export default {
  components: {
    Card,
    ExpendableImage
  },
  data() {
    return {
      is_update: this.$route.query.id,
      title: null,
      description: null,
      ingredients: "",
      method: [
        {
          step: 1,
          description: ""
        }
      ],
      item: [
        {
          ingredient: null,
          quantity: 0,
          quantity_type: ""
        }
      ],
      recipe: {},
      pic_path: null,
      recipeObj: new recipeClass(),
      error: "",
      file: "",
      man_title: false,
      man_desc: false,
      man_ing: false,
      man_step: false
    };
  },
  async created() {
    try {
      let logToken = false;
    let check_logged = await userApi.check_logged();
    console.log("Check Login: ", check_logged);
    if (check_logged.err) {
      this.$router.push("/?err=notLogged");
    } else {
      logToken = true;
    }

    if (this.is_update) {
      try {
        this.recipeObj.in_param_2 = this.$route.query.id;
        this.recipeObj.in_page = 1;
        const search = await recipeApi.search(this.recipeObj.toJson());
        this.recipe = search.result[0][0];
        this.title = this.recipe.title;
        this.description = this.recipe.description;
        this.method = this.recipe.methods;
        this.item = this.recipe.ingredients;
        this.pic_path = this.recipe.pic_path;
      } catch (err) {
        this.error = err.message;
      }
    }
    } catch (err) {
      this.error = err.message
    }
  },
  methods: {
    addNewItem() {
      this.item.push({
        ingredient: null,
        quantity: 0,
        quantity_type: null
      });
    },

    addNewStep() {
      this.method.push({
        step: this.method.length + 1,
        description: null
      });
    },

    remove(item, index) {
      if (item.length > 1) {
        item.splice(index, 1);
      } else {
        alert("Cannot remove");
      }
    },

    async addRecipe() {
      console.log("Adding recipe...");
      let token = false;
      let mandatory = await this.checkMandatory();
      if (!mandatory) {
        if (this.file) {
          console.log("Uploading picture...");
          try {
            let picture = await recipeApi.uploadPic(this.file);
            this.pic_path = picture.file.filename;
            token = true;
          } catch (err) {
            this.error = err.message;
          }
        } else {
          token = true;
        }

        if (token) {
          try {
            this.setClass();
            const add = await recipeApi.add(this.recipeObj.toJson());
            let nextPage = "/main/view_recipe?id=" + add[0].id;
            this.$router.push(nextPage);
          } catch (err) {
            this.error = err.message;
          }
        }
      }
    },

    async updateRecipe() {
      console.log("Updating recipe...");
      let token = false;
      let mandatory = await this.checkMandatory();
      if (!mandatory) {
        if (this.file) {
          try {
            let picture = await recipeApi.uploadPic(this.file);
            this.pic_path = picture.file.filename;
            token = true;
          } catch (err) {
            this.error = err.message;
          }
        } else {
          token = true;
        }

        if (token) {
          try {
            this.setClass();
            this.recipeObj.in_param_1 = this.$route.query.id;
            const update = await recipeApi.update(this.recipeObj.toJson());
            // console.log(update); //can be ignored
            let nextPage = "/main/view_recipe?id=" + update[0].id;
            this.$router.push(nextPage);
          } catch (err) {
            this.error = err.message;
          }
        }
      }
    },

    async deleteRecipe() {
      let token = false;
      if (
        confirm(
          "This recipe will be deleted forever. Are you sure you want to proceed?"
        )
      ) {
        token = true;
      }

      console.log("Deleting recipe...");
      if (token) {
        try {
          this.recipeObj.in_param_1 = this.$route.query.id;
          const del = await recipeApi.delete(this.recipeObj.toJson());
          let nextPage = "/main/search_recipe";
          this.$router.push(nextPage);
        } catch (err) {
          this.error = err.message;
        }
      }
    },

    async setClass() {
      this.recipeObj.title = this.title;
      this.recipeObj.description = this.description;
      this.recipeObj.ingredients = this.item;
      this.recipeObj.methods = this.method;
      this.recipeObj.pic_path = this.pic_path;
    },

    async checkMandatory() {
      try {
        if (this.title == null || this.title.split("") < 1) {
          this.man_title = true;
        } else {
          this.man_title = false;
        }

        if (this.description == null || this.description.split("") < 1) {
          this.man_desc = true;
        } else {
          this.man_desc = false;
        }

        this.man_ing = await this.checkMandatoryId("ingredient");
        this.man_step = await this.checkMandatoryId("step");
      } catch (err) {
        this.error = err.message;
      }

      if (this.man_desc || this.man_title || this.man_ing || this.man_step) {
        return true;
      } else {
        return false;
      }
    },

    async checkMandatoryId(setid) {
      let token = false;
      let length = parseInt(document.getElementById(setid).rows.length) - 1;
      for (var i = 0; i < length; i++) {
        let id = setid + "_" + i;
        let el = document.getElementById(id);
        if (el.value == null || el.value.split("") < 1) {
          el.classList.add("border");
          el.classList.add("border-danger");
          token = true;
        } else {
          el.classList.remove("border");
          el.classList.remove("border-danger");
        }
      }
      return token;
    },

    onSelect() {
      const file = this.$refs.file.files[0];
      this.file = file;
      console.log(this.file);
    },

    isMobile() {
      return utils.isMobile();
    }
  }
};
</script>
<style></style>
