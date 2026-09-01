# Base de données

Postgres 16 local, géré par `docker-compose`.

```
db/
├── migrations/001_init.sql   # schéma (tables, types, contraintes)
├── seeds/001_profils.sql     # 5 profils fictifs + vidéos + certifs + consentements
├── run.sh                    # applique migrations + seeds sur une base existante
└── README.md
```

## Démarrer

```sh
cp .env.example .env        # une fois — ajuste les identifiants si besoin
docker compose up -d postgres
```

À la **première création** du volume, `migrations/` puis `seeds/` sont
appliqués automatiquement (montés dans `/docker-entrypoint-initdb.d`).

Identifiants et port viennent de `.env` (`POSTGRES_USER`, `POSTGRES_PASSWORD`,
`POSTGRES_DB`, `POSTGRES_PORT`). Connexion depuis l'hôte :
`postgres://<POSTGRES_USER>:<POSTGRES_PASSWORD>@localhost:<POSTGRES_PORT>/<POSTGRES_DB>`

## Repartir de zéro

```sh
docker compose down -v      # supprime le volume pgdata
docker compose up -d postgres
```

## Rejouer migrations / seeds sans recréer le volume

Nécessite `psql` en local.

```sh
./db/run.sh                 # migrations + seeds
./db/run.sh --no-seed       # migrations seulement
```

Les migrations sont idempotentes. Le seed supprime d'abord les profils de
démo (`*@demo.jibjob`) avant de les réinsérer.

## Schéma

| Table                     | Points clés |
|---------------------------|-------------|
| `profils`                 | `competences text[]`, `email` unique, `mot_de_passe_hash`, `date_naissance` **NOT NULL** |
| `videos`                  | `type` = `lien` \| `upload` ; `taille_octets` obligatoire si `upload`, interdit si `lien` (CHECK) |
| `questions`               | `options jsonb`, `poids numeric` — **ajoutées à la main**, pas de seed |
| `reponses_questionnaire`  | `UNIQUE(profil_id, question_id)` — pas de seed (dépend des questions) |
| `resultats_certification` | 1 ligne par profil : `score_total`, `badge_obtenu` |
| `consentements`           | table distincte : `date_consentement` (date + heure), `version_texte`, `texte_accepte` |

Toutes les FK vers `profils` sont en `ON DELETE CASCADE`.

## Ajouter les questions

```sql
INSERT INTO questions (texte, options, poids) VALUES
  ('Votre question ?', '["Jamais","Parfois","Souvent","Toujours"]', 1.5);
```
