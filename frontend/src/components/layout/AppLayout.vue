<template>
  <div class="min-h-screen bg-background flex flex-col">
    <header class="border-b border-border bg-white sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
        <RouterLink to="/" class="flex items-center group">
          <div class="py-2 pr-6">
            <span class="text-2xl font-black text-primary font-marianne tracking-tight">
              ProfilsActifs
            </span>
          </div>
        </RouterLink>

        <nav class="flex items-center gap-8 font-marianne font-medium text-sm">
          <RouterLink to="/catalogue" class="text-primary hover:underline underline-offset-4">
            Catalogue recruteur
          </RouterLink>
          <RouterLink to="/inscription" class="text-primary hover:underline underline-offset-4">
            S'inscrire
          </RouterLink>
          <RouterLink to="/profil/1" class="btn-secondary text-xs px-3 py-1 border border-border">
            Mon Profil (démo)
          </RouterLink>
        </nav>
      </div>
    </header>

    <main class="flex-1 flex flex-col">
      <RouterView />
    </main>

    <footer class="bg-surface border-t border-border mt-auto">
      <div class="max-w-7xl mx-auto px-6 py-8 flex flex-col md:flex-row justify-between items-center gap-4">
        <div class="text-primary font-marianne font-bold text-lg">
          ProfilsActifs
        </div>
        <div class="text-text-muted text-sm font-marianne">
          Plateforme gouvernementale de mise en relation emploi.
        </div>
      </div>
    </footer>
  </div>
</template>
