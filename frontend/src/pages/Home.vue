<script setup lang="ts">
import { ref, onMounted } from 'vue'

const cards = ref<Element[]>([])

const testimonials = [
  { name: "Martin V.", job: "RH, Groupe Ionis", quote: "ProfilsActifs nous a permis de trouver des profils authentiques que les CV ne révèlent jamais." },
  { name: "Noah G.", job: "Recruteur, Pôle Emploi Strasbourg", quote: "La certification JEB est un vrai plus pour identifier rapidement les candidats sérieux." },
  { name: "Diana K.", job: "Directrice, Atyos", quote: "Un outil simple, efficace et conforme aux exigences du service public." },
]

onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.remove('opacity-0', 'translate-y-4')
      }
    })
  }, { threshold: 0.2 })

  cards.value.forEach(card => observer.observe(card))
})
</script>


<template>
  <div class="h-[calc(100vh-80px)] overflow-y-scroll snap-y snap-proximity">

    <section class="h-[calc(100vh-80px)] snap-start relative flex flex-col items-center justify-center px-12 text-center overflow-hidden">
      <div
        class="absolute inset-0 z-0 pointer-events-none opacity-[0.10] grayscale"
        style="background-image: url('https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=2000'); background-size: cover; background-position: center;"
        aria-hidden="true"
      />
      <div class="relative z-10 w-full max-w-4xl md:max-w-5xl xl:max-w-6xl 2xl:max-w-7xl mx-auto flex flex-col items-center">
        <h1 class="text-5xl md:text-6xl xl:text-7xl 2xl:text-8xl font-black text-primary font-marianne tracking-tight mb-8 leading-tight drop-shadow-sm">
          La mise en relation <br /> simple et transparente.
        </h1>
        <p class="text-xl md:text-2xl xl:text-3xl text-text-main font-spectral max-w-3xl xl:max-w-4xl mx-auto leading-relaxed font-medium mb-14">
          ProfilsActifs est la plateforme gouvernementale permettant aux demandeurs d'emploi de se présenter en vidéo et aux recruteurs de découvrir des talents authentiques, certifiés JEB.
        </p>
        <div class="flex flex-col sm:flex-row gap-6 justify-center w-full max-w-lg xl:max-w-xl 2xl:max-w-2xl">
          <RouterLink to="/inscription" class="btn-action w-full flex justify-center items-center text-lg shadow-md py-4">
            Inscription
          </RouterLink>
          <RouterLink to="/catalogue" class="btn-secondary w-full text-lg shadow-sm bg-white/90 backdrop-blur-sm py-4">
            Accès Recruteur
          </RouterLink>
        </div>
      </div>
    </section>

    <section class="h-[calc(100vh-80px)] snap-start flex flex-col items-center justify-center px-12 text-center">
      <div class="w-full max-w-5xl md:max-w-6xl xl:max-w-7xl 2xl:max-w-full 2xl:px-20">
        <h2
          :ref="el => { if (el) cards.push(el as Element) }"
          class="text-3xl xl:text-4xl 2xl:text-5xl font-marianne font-bold text-primary mb-12 opacity-0 translate-y-4 transition-all duration-700"
        >
          Ils nous font confiance
        </h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 xl:gap-12">
          <div
            v-for="t in testimonials"
            :key="t.name"
            :ref="el => { if (el) cards.push(el as Element) }"
            class="p-10 xl:p-14 bg-white border border-border rounded-lg text-left opacity-0 translate-y-4 transition-all duration-700"
          >
            <p class="font-spectral text-text-main italic mb-6 text-lg xl:text-xl 2xl:text-2xl leading-relaxed">"{{ t.quote }}"</p>
            <p class="font-marianne font-bold text-primary xl:text-lg">{{ t.name }}</p>
            <p class="font-marianne text-text-muted text-sm xl:text-base">{{ t.job }}</p>
          </div>
        </div>
      </div>
    </section>

    <section class="h-[calc(100vh-80px)] snap-start flex flex-col">
      <div class="flex-1 flex items-center justify-center px-12 text-center w-full">
        <div class="w-full max-w-5xl md:max-w-6xl xl:max-w-7xl 2xl:max-w-full 2xl:px-20 grid grid-cols-1 md:grid-cols-3 gap-8 xl:gap-12">
          <div
            :ref="el => { if (el) cards.push(el as Element) }"
            class="p-10 xl:p-14 bg-white/60 backdrop-blur-sm border border-border/50 rounded-lg opacity-0 translate-y-4 transition-all duration-700"
          >
            <h3 class="text-2xl xl:text-3xl font-marianne font-bold text-primary mb-4">Vidéo courte</h3>
            <p class="text-text-muted font-spectral text-lg xl:text-xl leading-relaxed">Une présentation d'une minute pour exprimer votre motivation au-delà du CV.</p>
          </div>
          <div
            :ref="el => { if (el) cards.push(el as Element) }"
            class="p-10 xl:p-14 bg-white/60 backdrop-blur-sm border border-border/50 rounded-lg opacity-0 translate-y-4 transition-all duration-700"
          >
            <h3 class="text-2xl xl:text-3xl font-marianne font-bold text-primary mb-4">Certification JEB</h3>
            <p class="text-text-muted font-spectral text-lg xl:text-xl leading-relaxed">Un test de savoir-être professionnel pour valoriser vos compétences douces.</p>
          </div>
          <div
            :ref="el => { if (el) cards.push(el as Element) }"
            class="p-10 xl:p-14 bg-white/60 backdrop-blur-sm border border-border/50 rounded-lg opacity-0 translate-y-4 transition-all duration-700"
          >
            <h3 class="text-2xl xl:text-3xl font-marianne font-bold text-primary mb-4">Contact direct</h3>
            <p class="text-text-muted font-spectral text-lg xl:text-xl leading-relaxed">Les recruteurs parcourent les profils mis en avant et initient l'échange.</p>
          </div>
        </div>
      </div>
      <footer class="flex justify-between items-center px-12 py-8 border-t border-border bg-surface shrink-0">
        <div class="text-primary font-marianne font-bold text-lg">ProfilsActifs</div>
        <div class="text-text-muted text-sm font-marianne">Plateforme gouvernementale de mise en relation emploi.</div>
      </footer>
    </section>

  </div>
</template>
