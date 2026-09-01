BEGIN;

DELETE FROM profils WHERE email LIKE '%@demo.jibjob';

WITH nouveaux AS (
    INSERT INTO profils (nom, competences, secteur, localisation, email, mot_de_passe_hash, date_naissance)
    VALUES
        ('Amina Diallo',   ARRAY['Go','PostgreSQL','Docker','CI/CD'],            'Tech',       'Paris',      'amina@demo.jibjob',   '$2a$10$abcdefghijklmnopqrstuv', '1994-03-12'),
        ('Lucas Moreau',   ARRAY['Vue.js','TypeScript','UI/UX','Figma'],         'Design',     'Lyon',       'lucas@demo.jibjob',   '$2a$10$abcdefghijklmnopqrstuv', '1990-07-25'),
        ('Sofia Rossi',    ARRAY['Marketing','SEO','Rédaction','Analytics'],     'Marketing',  'Marseille',  'sofia@demo.jibjob',   '$2a$10$abcdefghijklmnopqrstuv', '1988-11-02'),
        ('Karim Benali',   ARRAY['Python','Data Science','ML','SQL'],             'Data',       'Toulouse',   'karim@demo.jibjob',   '$2a$10$abcdefghijklmnopqrstuv', '1996-01-19'),
        ('Elena Petrova',  ARRAY['Gestion de projet','Agile','Scrum','Notion'],  'Management', 'Bordeaux',   'elena@demo.jibjob',   '$2a$10$abcdefghijklmnopqrstuv', '1985-05-30')
    RETURNING id, email
)
INSERT INTO videos (profil_id, type, url, taille_octets)
SELECT id,
       CASE WHEN email IN ('amina@demo.jibjob','sofia@demo.jibjob','elena@demo.jibjob') THEN 'lien'::video_type
            ELSE 'upload'::video_type END,
       CASE WHEN email IN ('amina@demo.jibjob','sofia@demo.jibjob','elena@demo.jibjob')
            THEN 'https://youtu.be/demo-' || split_part(email, '@', 1)
            ELSE 'https://storage.jibjob.local/videos/' || split_part(email, '@', 1) || '.mp4' END,
       CASE WHEN email IN ('amina@demo.jibjob','sofia@demo.jibjob','elena@demo.jibjob') THEN NULL
            ELSE 15728640 END
FROM nouveaux;

INSERT INTO resultats_certification (profil_id, score_total, badge_obtenu)
SELECT p.id,
       CASE p.email WHEN 'amina@demo.jibjob' THEN 87.5
                    WHEN 'karim@demo.jibjob' THEN 91.0
                    WHEN 'lucas@demo.jibjob' THEN 64.0
                    WHEN 'sofia@demo.jibjob' THEN 58.5
                    ELSE 72.0 END,
       p.email IN ('amina@demo.jibjob','karim@demo.jibjob')
FROM profils p
WHERE p.email LIKE '%@demo.jibjob';

INSERT INTO consentements (profil_id, date_consentement, version_texte, texte_accepte)
SELECT p.id,
       p.created_at,
       'cgu-v1.0',
       'J''accepte les conditions générales d''utilisation et la politique de confidentialité de JibJob.'
FROM profils p
WHERE p.email LIKE '%@demo.jibjob';

COMMIT;
