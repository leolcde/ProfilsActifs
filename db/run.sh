#!/usr/bin/env sh
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"

[ -f "$ROOT/.env" ] && . "$ROOT/.env"

if [ -n "$DATABASE_URL" ]; then
    DB_URL="$DATABASE_URL"
else
    : "${POSTGRES_USER:?manque .env}" "${POSTGRES_PASSWORD:?manque .env}" "${POSTGRES_DB:?manque .env}"
    DB_URL="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:${POSTGRES_PORT:-5432}/${POSTGRES_DB}?sslmode=disable"
fi

echo "==> Migrations"
for f in "$DIR"/migrations/*.sql; do
    echo "    - $(basename "$f")"
    psql "$DB_URL" -v ON_ERROR_STOP=1 -q -f "$f"
done

if [ "$1" = "--no-seed" ]; then
    echo "==> Seeds ignores (--no-seed)"
    exit 0
fi

echo "==> Seeds"
for f in "$DIR"/seeds/*.sql; do
    echo "    - $(basename "$f")"
    psql "$DB_URL" -v ON_ERROR_STOP=1 -q -f "$f"
done

echo "==> OK"
