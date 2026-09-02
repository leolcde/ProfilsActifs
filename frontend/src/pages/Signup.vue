<script setup lang="ts">
import { reactive } from 'vue'

const formData = reactive({
  firstName: '',
  lastName: '',
  email: '',
  birthDate: '',
  consent: false,
})
</script>

<template>
  <div class="flex-1 py-16 px-6 bg-surface">
    <div class="max-w-xl mx-auto bg-white p-10 border border-border">
      <h1 class="text-3xl font-marianne font-bold text-primary mb-2">Inscription</h1>
      <p class="text-text-muted font-spectral mb-10">
        Rejoignez ProfilsActifs pour accéder à la plateforme.
      </p>

      <form class="space-y-6" @submit.prevent>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block font-marianne font-bold text-primary mb-2 text-sm">Prénom</label>
            <input
              v-model="formData.firstName"
              type="text"
              class="w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral"
              required
            />
          </div>
          <div>
            <label class="block font-marianne font-bold text-primary mb-2 text-sm">Nom</label>
            <input
              v-model="formData.lastName"
              type="text"
              class="w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral"
              required
            />
          </div>
        </div>

        <div>
          <label class="block font-marianne font-bold text-primary mb-2 text-sm">Adresse e-mail</label>
          <input
            v-model="formData.email"
            type="email"
            class="w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral"
            required
          />
        </div>

        <div>
          <label class="block font-marianne font-bold text-primary mb-2 text-sm">Date de naissance *</label>
          <input
            v-model="formData.birthDate"
            type="date"
            class="w-full border border-border p-3 rounded-none focus:outline-none focus:border-primary font-spectral"
            required
          />
          <p class="text-xs text-text-muted mt-1 font-spectral">Obligatoire pour valider l'inscription.</p>
        </div>

        <div class="pt-4 border-t border-border">
          <label class="flex items-start gap-3 cursor-pointer">
            <input
              v-model="formData.consent"
              type="checkbox"
              class="mt-1 w-5 h-5 border-border rounded-none text-action focus:ring-action"
              required
            />
            <span class="text-sm font-spectral text-text-main leading-snug">
              Je consens au traitement de mes données à caractère personnel dans le cadre du service ProfilsActifs et j'accepte les Conditions Générales d'Utilisation.
            </span>
          </label>
        </div>

        <button type="submit" class="btn-action w-full mt-8">
          Valider mon inscription
        </button>
      </form>
    </div>
  </div>
</template>
