<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()
const route = useRoute()

const formData = reactive({
  email: '',
  password: '',
  remember: false,
})

const loading = ref(false)
const error = ref('')

const inputClass =
  'w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral'
const labelClass = 'block font-marianne font-bold text-primary mb-2 text-sm'

async function submit() {
  error.value = ''
  loading.value = true
  try {
    const res = await fetch('/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mail: formData.email,
        password: formData.password,
      }),
    })

    const body = await res.json().catch(() => ({}))

    if (!res.ok) {
      error.value = body.error ?? `Erreur ${res.status}`
      return
    }

    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : null
    if (redirect) {
      router.push(redirect)
    } else {
      router.push({ name: 'dashboard' })
    }
  } catch {
    error.value = 'Impossible de contacter le serveur.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex-1 py-16 px-6 bg-surface">
    <div class="max-w-md mx-auto bg-white p-10 border border-border">
      <h1 class="text-3xl font-marianne font-bold text-primary mb-2">Connexion</h1>
      <p class="text-text-muted font-spectral mb-10">
        Accédez à votre espace personnel ProfilsActifs.
      </p>

      <p
        v-if="error"
        class="mb-6 border border-action bg-surface text-action font-marianne text-sm p-3"
      >
        {{ error }}
      </p>

      <form class="space-y-6" @submit.prevent="submit">
        <div>
          <label :class="labelClass">Adresse e-mail</label>
          <input v-model="formData.email" type="email" :class="inputClass" required />
        </div>

        <div>
          <label :class="labelClass">Mot de passe</label>
          <input v-model="formData.password" type="password" :class="inputClass" required />
        </div>

        <div class="flex items-center justify-between">
          <label class="flex items-center gap-2 cursor-pointer">
            <input
              v-model="formData.remember"
              type="checkbox"
              class="w-4 h-4 border-border rounded-none text-action focus:ring-action"
            />
            <span class="text-sm font-spectral text-text-main">Se souvenir de moi</span>
          </label>
          <a href="#" class="text-sm font-marianne text-primary hover:underline underline-offset-4">
            Mot de passe oublié ?
          </a>
        </div>

        <button type="submit" class="btn-action w-full mt-4" :disabled="loading">
          {{ loading ? 'Connexion...' : 'Se connecter' }}
        </button>
      </form>

      <p class="text-sm font-spectral text-text-muted mt-8 pt-6 border-t border-border text-center">
        Pas encore de compte ?
        <RouterLink
          :to="{ name: 'signup' }"
          class="text-primary font-marianne font-bold hover:underline underline-offset-4"
        >
          S'inscrire
        </RouterLink>
      </p>
    </div>
  </div>
</template>
