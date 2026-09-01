BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'video_type') THEN
        CREATE TYPE video_type AS ENUM ('lien', 'upload');
    END IF;
END$$;

CREATE TABLE IF NOT EXISTS profils (
    id                bigserial PRIMARY KEY,
    nom               text        NOT NULL,
    competences       text[]      NOT NULL DEFAULT '{}',
    secteur           text,
    localisation      text,
    email             text        NOT NULL UNIQUE,
    mot_de_passe_hash text        NOT NULL,
    date_naissance    date        NOT NULL,
    created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS videos (
    id            bigserial PRIMARY KEY,
    profil_id     bigint      NOT NULL REFERENCES profils(id) ON DELETE CASCADE,
    type          video_type  NOT NULL,
    url           text        NOT NULL,
    taille_octets bigint,
    created_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT taille_requise_si_upload CHECK (
        (type = 'upload' AND taille_octets IS NOT NULL)
        OR (type = 'lien' AND taille_octets IS NULL)
    )
);

CREATE INDEX IF NOT EXISTS idx_videos_profil_id ON videos(profil_id);

CREATE TABLE IF NOT EXISTS questions (
    id      bigserial PRIMARY KEY,
    texte   text          NOT NULL,
    options jsonb         NOT NULL DEFAULT '[]',
    poids   numeric(4,2)  NOT NULL DEFAULT 1.0
);

CREATE TABLE IF NOT EXISTS reponses_questionnaire (
    id              bigserial PRIMARY KEY,
    profil_id       bigint NOT NULL REFERENCES profils(id)   ON DELETE CASCADE,
    question_id     bigint NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    reponse_choisie text   NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (profil_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_reponses_profil_id ON reponses_questionnaire(profil_id);

CREATE TABLE IF NOT EXISTS resultats_certification (
    profil_id    bigint       PRIMARY KEY REFERENCES profils(id) ON DELETE CASCADE,
    score_total  numeric(6,2) NOT NULL DEFAULT 0,
    badge_obtenu boolean      NOT NULL DEFAULT false,
    calcule_at   timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS consentements (
    id                bigserial   PRIMARY KEY,
    profil_id         bigint      NOT NULL REFERENCES profils(id) ON DELETE CASCADE,
    date_consentement timestamptz NOT NULL DEFAULT now(),
    version_texte     text        NOT NULL,
    texte_accepte     text        NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_consentements_profil_id ON consentements(profil_id);

COMMIT;
