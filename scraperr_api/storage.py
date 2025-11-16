"""Utility helpers for storing and retrieving job information."""

from __future__ import annotations

import json
import sqlite3
from datetime import datetime, timezone
from pathlib import Path
from threading import Lock
from typing import Any, Dict, Iterable, List, Optional
from uuid import uuid4

from .models import JobDetail, JobSummary, ScrapeElement, SubmitScrapeJobRequest


class JobStore:
    """Simple SQLite-backed persistence layer for job data."""

    def __init__(self, database_path: Path):
        self.database_path = Path(database_path)
        self.database_path.parent.mkdir(parents=True, exist_ok=True)
        self._lock = Lock()
        self._ensure_tables()

    def _get_connection(self) -> sqlite3.Connection:
        connection = sqlite3.connect(self.database_path)
        connection.row_factory = sqlite3.Row
        return connection

    def _ensure_tables(self) -> None:
        required_columns = {"id", "url", "payload", "status", "created_at", "results"}
        with self._get_connection() as connection:
            connection.execute(
                """
                CREATE TABLE IF NOT EXISTS jobs (
                    id TEXT PRIMARY KEY,
                    url TEXT NOT NULL,
                    payload TEXT NOT NULL,
                    status TEXT NOT NULL,
                    created_at TEXT NOT NULL,
                    results TEXT NOT NULL
                )
                """
            )
            existing_columns = {
                row[1]
                for row in connection.execute("PRAGMA table_info(jobs)").fetchall()
            }
            if not required_columns.issubset(existing_columns):
                connection.execute("DROP TABLE jobs")
                connection.execute(
                    """
                    CREATE TABLE jobs (
                        id TEXT PRIMARY KEY,
                        url TEXT NOT NULL,
                        payload TEXT NOT NULL,
                        status TEXT NOT NULL,
                        created_at TEXT NOT NULL,
                        results TEXT NOT NULL
                    )
                    """
                )
            connection.commit()

    def create_job(self, request: SubmitScrapeJobRequest) -> Dict[str, Any]:
        """Store the job request and return a representation for the API."""

        job_id = str(uuid4())
        created_at = datetime.now(timezone.utc)
        status = "completed"

        payload_dict = request.to_dict()
        results = self._simulate_results(request.elements, request.url)

        with self._lock:
            with self._get_connection() as connection:
                connection.execute(
                    """
                    INSERT INTO jobs (id, url, payload, status, created_at, results)
                    VALUES (?, ?, ?, ?, ?, ?)
                    """,
                    (
                        job_id,
                        request.url,
                        json.dumps(payload_dict),
                        status,
                        created_at.isoformat(),
                        json.dumps(results),
                    ),
                )
                connection.commit()

        return {
            "job_id": job_id,
            "status": status,
            "created_at": created_at.isoformat(),
            "message": "Scrape simulated successfully.",
        }

    def list_jobs(self) -> List[JobSummary]:
        with self._lock:
            with self._get_connection() as connection:
                rows = connection.execute(
                    "SELECT id, url, status, created_at FROM jobs ORDER BY created_at DESC"
                ).fetchall()

        jobs: List[JobSummary] = []
        for row in rows:
            jobs.append(
                JobSummary(
                    id=row["id"],
                    url=row["url"],
                    status=row["status"],
                    created_at=datetime.fromisoformat(row["created_at"]),
                )
            )
        return jobs

    def get_job(self, job_id: str) -> Optional[JobDetail]:
        with self._lock:
            with self._get_connection() as connection:
                row = connection.execute(
                    "SELECT * FROM jobs WHERE id = ?",
                    (job_id,),
                ).fetchone()

        if row is None:
            return None

        payload = SubmitScrapeJobRequest.from_json(row["payload"])
        results = json.loads(row["results"])

        return JobDetail(
            id=row["id"],
            url=row["url"],
            status=row["status"],
            created_at=datetime.fromisoformat(row["created_at"]),
            request_payload=payload,
            results=results,
        )

    def delete_jobs(self) -> None:
        with self._lock:
            with self._get_connection() as connection:
                connection.execute("DELETE FROM jobs")
                connection.commit()

    @staticmethod
    def _simulate_results(
        elements: Iterable[ScrapeElement], url: str
    ) -> Dict[str, List[Dict[str, str]]]:
        """Generate deterministic placeholder results for a scrape job."""

        simulated_rows: List[Dict[str, str]] = []
        for element in elements:
            simulated_rows.append(
                {
                    "name": element.name,
                    "xpath": element.xpath,
                    "source_url": element.url or url,
                    "content": f"Sample data extracted for {element.name}",
                }
            )

        return {
            "summary": [
                {
                    "description": f"Scraped {len(simulated_rows)} element(s) from {url}",
                    "status": "success",
                }
            ],
            "scraped_elements": simulated_rows,
        }
