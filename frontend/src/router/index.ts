import { createRouter, createWebHistory } from 'vue-router'
import AppLayout from '../components/layout/AppLayout.vue'
import Home from '../pages/Home.vue'
import Signup from '../pages/Signup.vue'
import Login from '../pages/Login.vue'
import Catalogue from '../pages/Catalogue.vue'
import Profile from '../pages/Profile.vue'

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: AppLayout,
      children: [
        { path: '', component: Home },
        { path: 'inscription', component: Signup },
        { path: 'connexion', component: Login },
        { path: 'catalogue', component: Catalogue },
        { path: 'profil/:id', component: Profile },
      ],
    },
  ],
})
