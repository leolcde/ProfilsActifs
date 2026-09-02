<script setup lang="ts">
import { ref, computed } from 'vue'
import { MapPin, Search } from 'lucide-vue-next'
import { MOCK_PROFILES } from '../assets/data/mock.ts'
import JebBadge from '../assets/JebBadge.vue'

const filterCertified = ref(false)
const profiles = computed(() =>
  filterCertified.value ? MOCK_PROFILES.filter(p => p.isCertified) : MOCK_PROFILES
)
</script>

<template>
  <div class="max-w-7xl mx-auto px-6 py-12 w-full flex flex-col md:flex-row gap-12">
    <!-- Sidebar Filters -->
    <aside class="w-full md:w-64 shrink-0 space-y-8">
      <div>
        <h2 class="text-xl font-marianne font-bold text-primary mb-6 border-b border-border pb-2">Filtres</h2>
        <div class="space-y-6">
          <div>
            <label class="block font-marianne font-bold text-primary text-sm mb-2">Domaine / Compétence</label>
            <div class="relative">
              <Search class="absolute left-3 top-2.5 h-4 w-4 text-text-muted" />
              <input
                type="text"
                placeholder="Ex: Logistique..."
                class="w-full pl-9 pr-3 py-2 bg-white border border-border text-sm focus:outline-none focus:border-primary font-spectral"
              />
            </div>
          </div>

          <div>
            <label class="block font-marianne font-bold text-primary text-sm mb-2">Ville</label>
            <div class="relative">
              <MapPin class="absolute left-3 top-2.5 h-4 w-4 text-text-muted" />
              <input
                type="text"
                placeholder="Ex: Lyon"
                class="w-full pl-9 pr-3 py-2 bg-white border border-border text-sm focus:outline-none focus:border-primary font-spectral"
              />
            </div>
          </div>

          <div class="pt-4 border-t border-border">
            <label class="flex items-center gap-3 cursor-pointer group">
              <input
                v-model="filterCertified"
                type="checkbox"
                class="w-5 h-5 border-border rounded-none text-action focus:ring-action"
              />
              <span class="font-marianne font-medium text-sm text-primary group-hover:underline">
                Profils certifiés JEB uniquement
              </span>
            </label>
          </div>
        </div>
      </div>
    </aside>

    <!-- Main Feed -->
    <div class="flex-1">
      <h1 class="text-3xl font-marianne font-black text-primary mb-2">Profils mis en avant</h1>
      <p class="text-text-muted font-spectral mb-8 pb-4 border-b border-border">
        Découvrez les présentations vidéo des demandeurs d'emploi.
      </p>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div
          v-for="profile in profiles"
          :key="profile.id"
          class="bg-white border border-border flex flex-col hover:border-primary transition-colors group"
        >
          <div class="h-48 relative bg-surface border-b border-border overflow-hidden">
            <template v-if="profile.hasConsent">
              <img
                :src="profile.videoUrl"
                :alt="`Vidéo de ${profile.name}`"
                class="w-full h-full object-cover grayscale opacity-90 group-hover:grayscale-0 transition-all duration-500"
              />
              <div class="absolute inset-0 flex items-center justify-center">
                <div class="w-12 h-12 bg-action text-action-foreground rounded-full flex items-center justify-center pl-1 shadow-sm">
                  <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M4 4l12 6-12 6z" /></svg>
                </div>
              </div>
            </template>
            <div v-else class="w-full h-full flex items-center justify-center text-text-muted font-spectral italic bg-surface">
              Vidéo masquée
            </div>
          </div>

          <div class="p-6 flex-1 flex flex-col">
            <div class="mb-4">
              <h3 class="text-xl font-marianne font-bold text-primary mb-1">{{ profile.name }}</h3>
              <p class="font-marianne text-text-main font-medium mb-2">{{ profile.job }}</p>
              <p class="text-text-muted font-marianne text-sm flex items-center gap-1.5">
                <MapPin class="w-3.5 h-3.5" />
                {{ profile.city }}
              </p>
            </div>

            <div class="mb-6 flex-1">
              <JebBadge v-if="profile.isCertified" />
            </div>

            <div class="flex gap-4">
              <RouterLink
                :to="`/profil/${profile.id}`"
                class="btn-secondary flex-1 text-sm text-center"
              >
                Voir le profil
              </RouterLink>
              <button class="btn-action flex-1 text-sm">
                Contacter
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>