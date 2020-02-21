import DashboardLayout from '../layout/DashboardLayout.vue'
// GeneralViews
import NotFound from '../pages/NotFoundPage.vue'

// Admin pages
import Overview from 'src/pages/Overview.vue'
import Login from 'src/pages/Login.vue'
import DataEntryRecipe from 'src/pages/DataEntryRecipe.vue'
import SearchRecipe from 'src/pages/SearchRecipe.vue'
import ViewRecipe from 'src/pages/ViewRecipe.vue'

const routes = [
  {
    path: '/',
    name: 'login',
    component: Login,
    // redirect: '/admin/overview'
  },
  {
    path: '/main',
    component: DashboardLayout,
    redirect: '/main/overview',
    children: [
      {
        path: 'overview',
        name: 'Overview',
        component: Overview
      },
      {
        path: 'dataentry_recipe',
        name: 'dataEntryRecipe',
        component: DataEntryRecipe
      },
      {
        path: 'search_recipe',
        name: 'SearchRecipe',
        component: SearchRecipe
      },
      {
        path: 'view_recipe',
        name: 'ViewRecipe',
        component: ViewRecipe
      }
    ]
  },
  { path: '*', component: NotFound }
]

/**
 * Asynchronously load view (Webpack Lazy loading compatible)
 * The specified component must be inside the Views folder
 * @param  {string} name  the filename (basename) of the view to load.
function view(name) {
   var res= require('../components/Dashboard/Views/' + name + '.vue');
   return res;
};**/

export default routes
