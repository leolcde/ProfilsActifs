<div id="top">

<div align="center">

# <code> JibJob </code>

Web platform built with Go and Vue, containerized with Docker Compose.

![Static Badge](https://img.shields.io/badge/Go-00ADD8.svg?style=flat&logo=go&logoColor=white)
![Static Badge](https://img.shields.io/badge/Vue.js-4FC08D.svg?style=flat&logo=vuedotjs&logoColor=white)
![Static Badge](https://img.shields.io/badge/Vite-646CFF.svg?style=flat&logo=vite&logoColor=white)
![Static Badge](https://img.shields.io/badge/TypeScript-3178C6.svg?style=flat&logo=typescript&logoColor=white)
![Static Badge](https://img.shields.io/badge/Docker-2496ED.svg?style=flat&logo=docker&logoColor=white)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development](#development)
- [CI](#ci)
- [Acknowledgments](#acknowledgments)

---

## Overview

JibJob is a full-stack web application. The backend is a Go HTTP service exposing
a JSON API, and the frontend is a Vue 3 single-page app built with Vite. Both run as
containers orchestrated by Docker Compose, with the frontend proxying `/api` to the backend.

---

## Project Structure

```sh
└── JibJob/
   ├── backend/
   │   ├── main.go            # HTTP server, API routes
   │   ├── go.mod
   │   └── Dockerfile         # multi-stage build → distroless
   ├── frontend/
   │   ├── src/               # Vue components, entry point
   │   ├── index.html
   │   ├── vite.config.ts     # dev server + /api proxy
   │   ├── package.json
   │   └── Dockerfile         # node dev server
   ├── .github/workflows/
   │   └── build.yml          # build check (Go + Vue + docker compose)
   └── docker-compose.yml
```

---

## Getting Started

### Prerequisites

- Docker and Docker Compose v2

### Run the stack

```sh
git clone git@github.com:leolcde/JibJob.git
cd JibJob
docker compose up --build
```

Services:

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:8080 (health check: `/api/health`)

---

## Development

Run each part without Docker:

```sh
# backend
cd backend && go run .

# frontend
cd frontend && npm install && npm run dev
```

The Vite dev server proxies `/api` to the backend, so both hot-reload independently.

---

## CI

Every push to `dev` and every pull request runs [`build.yml`](.github/workflows/build.yml):

- `go build` + `go vet` on the backend
- `npm ci` + `npm run build` on the frontend
- `docker compose build` on the full stack

---

## Acknowledgments

- Credit `contributors: leolcde, mrmlrs`

[![][back-to-top]](#top)

</div>

[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square
