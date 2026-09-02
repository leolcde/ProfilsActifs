import { createRouter, createWebHistory } from 'vue-router'
import Catalogue from '../views/Catalogue.vue'
import Dashboard from '../views/Dashboard.vue'
import DefaultLayout from '../views/DefaultLayout.vue'
import LandingPage from '../views/LandingPage.vue'
import Login from '../views/Login.vue'
import Profile from '../views/Profile.vue'
import Signup from '../views/Signup.vue'

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: DefaultLayout,
      children: [
        { path: '', name: 'home', component: LandingPage },
        { path: 'catalogue', name: 'catalogue', component: Catalogue },
        { path: 'dashboard', name: 'dashboard', component: Dashboard },
        { path: 'login', name: 'login', component: Login },
        { path: 'profil/:id', name: 'profile', component: Profile },
        { path: 'signup', name: 'signup', component: Signup },
      ],
    },
  ],
})
