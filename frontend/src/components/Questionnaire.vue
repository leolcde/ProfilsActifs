<script setup>
import { ref, onMounted } from 'vue'

// Adapte cette valeur : pour l'instant, en attendant l'authentification,
// le profile_id est codé en dur ici. Ton collègue le remplacera par
// l'ID du profil réellement connecté une fois l'auth branchée.
const profileId = ref(1)

const API_BASE = 'http://localhost:8080'

const questions = ref([])
const currentIndex = ref(0)
const selectedOption = ref(null)
const loading = ref(true)
const finished = ref(false)
const errorMessage = ref(null)

const currentQuestion = () => questions.value[currentIndex.value]

async function demarrerQuestionnaire() {
  await fetch(`${API_BASE}/questionnaire/demarrer`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ profile_id: profileId.value }),
  })
}

async function chargerQuestions() {
  const res = await fetch(`${API_BASE}/questionnaire`)
  questions.value = await res.json()
}

async function envoyerReponse() {
  if (selectedOption.value === null) {
    errorMessage.value = 'Choisis une réponse avant de continuer.'
    return
  }
  errorMessage.value = null

  const question = currentQuestion()

  await fetch(`${API_BASE}/questionnaire/reponse`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      profile_id: profileId.value,
      question_id: question.ID,
      options: [selectedOption.value],
    }),
  })

  selectedOption.value = null

  if (currentIndex.value + 1 < questions.value.length) {
    currentIndex.value++
  } else {
    finished.value = true
  }
}

onMounted(async () => {
  loading.value = true
  await demarrerQuestionnaire()
  await chargerQuestions()
  loading.value = false
})
</script>

<template>
  <div class="questionnaire">
    <p v-if="loading">Chargement du questionnaire...</p>

    <div v-else-if="finished">
      <h2>Questionnaire terminé !</h2>
      <p>Tes réponses ont bien été enregistrées.</p>
    </div>

    <div v-else-if="currentQuestion()">
      <p class="progress">
        Question {{ currentIndex + 1 }} / {{ questions.length }}
      </p>

      <h2>{{ currentQuestion().Content }}</h2>

      <div class="options">
        <label
          v-for="option in currentQuestion().Options"
          :key="option"
          class="option"
        >
          <input
            type="radio"
            name="reponse"
            :value="option"
            v-model="selectedOption"
          />
          {{ option }}
        </label>
      </div>

      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

      <button @click="envoyerReponse">Suivant</button>
    </div>

    <p v-else>Aucune question disponible.</p>
  </div>
</template>

<style scoped>
.questionnaire {
  max-width: 500px;
  margin: 2rem auto;
  font-family: sans-serif;
}
.progress {
  color: #666;
  margin-bottom: 0.5rem;
}
.options {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin: 1rem 0;
}
.option {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}
.error {
  color: red;
}
button {
  padding: 0.5rem 1rem;
  cursor: pointer;
}
</style>