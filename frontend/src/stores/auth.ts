import { computed, reactive } from 'vue'

/**
 * Store d'authentification (composable maison, sans Pinia).
 *
 * Aujourd'hui : l'état est simplement persisté dans le localStorage.
 * Demain : `login` / `logout` / `register` appellent déjà les bonnes routes
 * du backend Go — il suffira que celui-ci réponde.
 */

const LS_KEY = 'auth_user'

export interface AuthUser {
  id: string
  name: string
  email: string
  role: string
}

function load(): AuthUser | null {
  try {
    const raw = localStorage.getItem(LS_KEY)
    return raw ? (JSON.parse(raw) as AuthUser) : null
  } catch {
    return null
  }
}

const state = reactive<{ user: AuthUser | null }>({
  user: load(),
})

function persist() {
  try {
    if (state.user) localStorage.setItem(LS_KEY, JSON.stringify(state.user))
    else localStorage.removeItem(LS_KEY)
  } catch {
    /* stockage indisponible : on ignore */
  }
}

function setUser(user: AuthUser) {
  state.user = user
  persist()
}

/** POST /auth/login — à activer quand le backend le gère. */
async function login(mail: string, password: string) {
  const res = await fetch('/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ mail, password }),
  })
  const body = await res.json().catch(() => ({}))
  if (!res.ok) {
    throw new Error(body.error ?? `Erreur ${res.status}`)
  }
  setUser({
    id: String(body.id ?? ''),
    name: body.name ?? '',
    email: body.mail ?? mail,
    role: body.role ?? 'candidate',
  })
}

function logout() {
  state.user = null
  persist()
  // futur : fetch('/auth/logout', { method: 'POST' })
}

export function useAuth() {
  return {
    user: computed(() => state.user),
    isAuthenticated: computed(() => state.user !== null),
    login,
    logout,
    setUser,
  }
}
