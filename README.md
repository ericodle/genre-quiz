# Music Genre Classification Quiz

A Rails web application for testing human music genre classification using the same test sets (FMA and GTZAN) used in ML research.

## Features

- Quiz on FMA (16 genres, 2,490 songs) or GTZAN (10 genres, 160 songs) test sets
- Randomized questions with HTML5 audio playback
- Progress tracking and detailed results by genre

## Quick Start

1. **Build and setup:**
   ```bash
   docker compose build
   docker compose run --rm web rails db:create db:migrate
   docker compose run --rm web rails audio:seed
   ```

2. **Start everything:**
   ```bash
   docker compose up -d
   ```

3. **Access:** Open `http://localhost:3003`

## Usage

1. Select a dataset (FMA or GTZAN) and number of questions
2. Listen to audio clips and select the genre
3. View results with accuracy breakdown by genre

## Dataset Info

**FMA:** 16 genres, MP3 format, ~2,490 test files  
**GTZAN:** 10 genres, WAV format, 160 test files

Audio files are mounted from:
- FMA: `/home/eo/MGRP/fma-data/splits/test/` → `/app/audio/fma-test`
- GTZAN: `/home/eo/MGRP/gtzan-data/splits/test/` → `/app/audio/gtzan-test`

## Common Commands

```bash
# View logs
docker compose logs -f web

# Reset database
docker compose run --rm web rails db:reset
docker compose run --rm web rails audio:seed

# Rails console
docker compose run --rm web rails console

# Stop
docker compose down
```

## Troubleshooting

- **Port in use:** Change port in `docker-compose.yml` (e.g., `"3004:3003"`)
- **Audio files not found:** Verify paths exist and are mounted correctly
- **Database issues:** Check `docker compose ps` and `docker compose logs db`
