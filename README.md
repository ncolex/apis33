# Scraperr API utilities

This repository now bundles a small HTTP server that mimics the behaviour of the
`jpyles0524/scraperr_api` container image so that the included
[`test_api.sh`](test_api.sh) script can be executed locally without Docker. The
server relies only on Python's standard library which makes it suitable for
restricted environments.

## Running the API locally

```bash
python -m scraperr_api.server
```

The server listens on port `8000` by default and implements the following
endpoints:

- `GET /docs` – returns a short HTML description of the API.
- `POST /api/submit-scrape-job` – accepts a job definition and stores it in the
  SQLite database located at `data/database.db`.
- `GET /api/jobs` – lists previously submitted jobs.
- `GET /api/job/<job_id>` – returns the details for a specific job.
- `DELETE /api/delete-scrape-jobs` – removes all stored jobs.

## Verifying the API

Once the server is running you can execute the bundled tests:

```bash
bash test_api.sh
```

The script issues a submission request, polls the job list to extract an ID and
verifies that the job detail and deletion endpoints respond correctly.
