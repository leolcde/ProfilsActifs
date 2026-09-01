\set ON_ERROR_STOP on

DO $$
BEGIN
    IF (SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public') <> 6
        THEN RAISE EXCEPTION 'schema: 6 tables attendues'; END IF;
    IF (SELECT count(*) FROM profils) < 5
        THEN RAISE EXCEPTION 'seed profils incomplet'; END IF;
    IF (SELECT count(*) FROM videos) < 5
        THEN RAISE EXCEPTION 'seed videos incomplet'; END IF;
    IF (SELECT count(*) FROM consentements) < 5
        THEN RAISE EXCEPTION 'seed consentements incomplet'; END IF;
    RAISE NOTICE 'DB OK';
END $$;
