<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Heart, Lock, MapPin, MessageSquare, Share2, VideoOff } from 'lucide-vue-next'
import { MOCK_PROFILES } from '../assets/data/mock'
import JebBadge from '../assets/JebBadge.vue'
import { useAuth } from '../stores/auth'

const router = useRouter()
const route = useRoute()
const { isAuthenticated } = useAuth()

/** Toute interaction exige d'être connecté. */
function requireAuth(): boolean {
  if (isAuthenticated.value) return true
  router.push({ name: 'login', query: { redirect: route.fullPath } })
  return false
}

// On étoffe le feed à partir des profils mock (pas de backend)
const baseCount: Record<string, number> = { '1': 342, '2': 187, '3': 54 }

const feed = MOCK_PROFILES.flatMap((p, batch) =>
  [0, 1, 2].map((k) => ({
    ...p,
    uid: `${p.id}-${batch}-${k}`,
    likes: (baseCount[p.id] ?? 20) + k * 7,
  })),
)

const LS_KEY = 'feed_likes'

function loadLiked(): Set<string> {
  try {
    return new Set<string>(JSON.parse(localStorage.getItem(LS_KEY) ?? '[]'))
  } catch {
    return new Set<string>()
  }
}

const liked = reactive(loadLiked())

function persist() {
  try {
    localStorage.setItem(LS_KEY, JSON.stringify([...liked]))
  } catch {
    /* stockage indisponible : on ignore */
  }
}

function toggleLike(uid: string) {
  if (!requireAuth()) return
  if (liked.has(uid)) liked.delete(uid)
  else liked.add(uid)
  persist()
}

function likeCount(item: { uid: string; likes: number }) {
  return item.likes + (liked.has(item.uid) ? 1 : 0)
}

// petit feedback visuel sur double-tap / clic image
const burst = ref<string | null>(null)
function doubleLike(uid: string) {
  if (!requireAuth()) return
  if (!liked.has(uid)) toggleLike(uid)
  burst.value = uid
  setTimeout(() => (burst.value = null), 600)
}

const total = computed(() => feed.length)
</script>

<template>
  <div class="h-[calc(100dvh-4rem)] sm:h-[calc(100dvh-5rem)] overflow-y-scroll snap-y snap-mandatory bg-black">
    <section
      v-for="(item, i) in feed"
      :key="item.uid"
      class="h-[calc(100dvh-4rem)] sm:h-[calc(100dvh-5rem)] snap-start relative flex items-center justify-center overflow-hidden"
    >
      <!-- Média -->
      <template v-if="item.hasConsent">
        <img
          :src="item.videoUrl"
          :alt="`Présentation de ${item.name}`"
          class="absolute inset-0 w-full h-full object-cover"
          @dblclick="doubleLike(item.uid)"
        />
        <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/10 to-black/40" />
      </template>
      <div v-else class="absolute inset-0 bg-surface flex flex-col items-center justify-center text-text-muted">
        <VideoOff class="w-12 h-12 mb-3" />
        <p class="font-marianne font-bold">Vidéo masquée</p>
        <p class="font-spectral text-sm">Consentement non accordé</p>
      </div>

      <!-- coeur "burst" -->
      <Heart
        v-if="burst === item.uid"
        class="absolute w-24 h-24 sm:w-32 sm:h-32 text-white fill-action drop-shadow-lg animate-ping"
      />

      <!-- Infos bas gauche -->
      <div class="absolute left-0 bottom-0 p-4 sm:p-6 md:p-10 max-w-[75%] sm:max-w-md md:max-w-lg pr-16 sm:pr-24 text-white z-10">
        <div class="mb-3">
          <JebBadge v-if="item.isCertified" />
        </div>
        <h2 class="text-2xl sm:text-3xl font-marianne font-black tracking-tight drop-shadow">{{ item.name }}</h2>
        <p class="font-marianne font-medium text-white/90 mb-2">{{ item.job }}</p>
        <p class="font-marianne text-sm text-white/70 flex items-center gap-1.5 mb-4">
          <MapPin class="w-3.5 h-3.5" />
          {{ item.city }}
        </p>
        <div class="flex flex-wrap gap-2 mb-5">
          <span
            v-for="skill in item.skills"
            :key="skill"
            class="px-3 py-1 bg-white/15 backdrop-blur-sm border border-white/20 text-white font-marianne text-xs"
          >
            {{ skill }}
          </span>
        </div>
        <RouterLink
          :to="`/profil/${item.id}`"
          class="inline-flex items-center bg-action text-action-foreground font-marianne font-semibold px-5 py-2.5 hover:opacity-90 transition-opacity text-sm"
        >
          Voir le profil
        </RouterLink>
      </div>

      <!-- Rail d'actions droite -->
      <div class="absolute right-2 sm:right-6 bottom-16 sm:bottom-24 flex flex-col items-center gap-4 sm:gap-6 z-10 text-white">
        <button class="flex flex-col items-center group" @click="toggleLike(item.uid)">
          <span
            class="w-11 h-11 sm:w-12 sm:h-12 rounded-full bg-white/15 backdrop-blur-sm border border-white/20 flex items-center justify-center group-hover:bg-white/25 transition-colors"
          >
            <Heart
              class="w-5 h-5 sm:w-6 sm:h-6 transition-colors"
              :class="liked.has(item.uid) ? 'fill-action text-action' : 'text-white'"
            />
          </span>
          <span class="text-xs font-marianne font-bold mt-1">{{ likeCount(item) }}</span>
        </button>

        <button class="flex flex-col items-center group" @click="requireAuth()">
          <span
            class="w-11 h-11 sm:w-12 sm:h-12 rounded-full bg-white/15 backdrop-blur-sm border border-white/20 flex items-center justify-center group-hover:bg-white/25 transition-colors"
          >
            <MessageSquare class="w-5 h-5 sm:w-6 sm:h-6" />
          </span>
          <span class="text-xs font-marianne font-bold mt-1">Contacter</span>
        </button>

        <button class="flex flex-col items-center group" @click="requireAuth()">
          <span
            class="w-11 h-11 sm:w-12 sm:h-12 rounded-full bg-white/15 backdrop-blur-sm border border-white/20 flex items-center justify-center group-hover:bg-white/25 transition-colors"
          >
            <Share2 class="w-5 h-5 sm:w-6 sm:h-6" />
          </span>
          <span class="text-xs font-marianne font-bold mt-1">Partager</span>
        </button>
      </div>

      <!-- Bandeau : connexion requise pour interagir -->
      <RouterLink
        v-if="!isAuthenticated"
        :to="{ name: 'login', query: { redirect: route.fullPath } }"
        class="absolute top-4 left-4 z-10 inline-flex items-center gap-2 bg-black/40 backdrop-blur-sm text-white/90 font-marianne text-xs px-3 py-2 hover:bg-black/60 transition-colors"
      >
        <Lock class="w-3.5 h-3.5" />
        Connectez-vous pour aimer et contacter
      </RouterLink>

      <!-- Compteur de position -->
      <div
        class="absolute top-4 right-4 z-10 text-white/70 font-marianne text-xs bg-black/30 px-2 py-1"
      >
        {{ i + 1 }} / {{ total }}
      </div>
    </section>
  </div>
</template>
