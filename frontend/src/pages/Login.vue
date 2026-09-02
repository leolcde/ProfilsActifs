<script setup lang="ts">
import { reactive } from 'vue'

const formData = reactive({
  email: '',
  password: '',
})
</script>

<template>
  <div class="flex-1 py-16 px-6 bg-surface">
    <div class="max-w-md mx-auto bg-white p-10 border border-border">
      <h1 class="text-3xl font-marianne font-bold text-primary mb-2">Connexion</h1>
      <p class="text-text-muted font-spectral mb-10">
        Accédez à votre espace ProfilsActifs.
      </p>

      <form class="space-y-6" @submit.prevent>
        <div>
          <label class="block font-marianne font-bold text-primary mb-2 text-sm">Adresse e-mail</label>
          <input
            v-model="formData.email"
            type="email"
            placeholder="votre@email.fr"
            class="w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral"
            required
          />
        </div>

        <div>
          <label class="block font-marianne font-bold text-primary mb-2 text-sm">Mot de passe</label>
          <input
            v-model="formData.password"
            type="password"
            placeholder="••••••••"
            class="w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral"
            required
          />
        </div>

        <div class="flex items-center justify-between pt-2">
          <a href="#" class="text-sm font-marianne text-text-muted hover:underline">
            Mot de passe oublié ?
          </a>
        </div>

        <button type="submit" class="btn-action w-full mt-4">
          Se connecter
        </button>

        <p class="text-center text-sm font-spectral text-text-muted pt-2">
          Pas encore de compte ?
          <RouterLink to="/inscription" class="font-marianne font-bold text-primary hover:underline">
            S'inscrire
          </RouterLink>
        </p>
      </form>
    </div>
  </div>
</template>
