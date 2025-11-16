"""Minimal HTTP server that exposes the Scraperr API endpoints."""

from __future__ import annotations

import json
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Dict, Tuple
from urllib.parse import urlparse

from .models import SubmitScrapeJobRequest, ValidationError
from .storage import JobStore

DATA_PATH = Path("data") / "database.db"


def _json_response(status: HTTPStatus, payload: Dict[str, object]) -> Tuple[int, bytes, str]:
    body = json.dumps(payload).encode("utf-8")
    return status, body, "application/json"


class ScraperrRequestHandler(BaseHTTPRequestHandler):
    store = JobStore(DATA_PATH)

    def _send_json(self, status: HTTPStatus, payload: Dict[str, object]) -> None:
        status_code, body, content_type = _json_response(status, payload)
        self.send_response(status_code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _read_json_body(self) -> Dict[str, object]:
        try:
            content_length = int(self.headers.get("Content-Length", "0"))
        except ValueError:
            content_length = 0
        body = self.rfile.read(content_length) if content_length else b""
        if not body:
            return {}
        return json.loads(body.decode("utf-8"))

    def do_GET(self) -> None:  # noqa: N802
        parsed_path = urlparse(self.path)
        if parsed_path.path == "/docs":
            self._serve_docs()
            return
        if parsed_path.path == "/health":
            self._send_json(HTTPStatus.OK, {"status": "ok"})
            return
        if parsed_path.path == "/api/jobs":
            jobs = [job.to_dict() for job in self.store.list_jobs()]
            self._send_json(HTTPStatus.OK, {"jobs": jobs})
            return
        if parsed_path.path.startswith("/api/job/"):
            job_id = parsed_path.path.split("/api/job/")[-1]
            job = self.store.get_job(job_id)
            if job is None:
                self._send_json(HTTPStatus.NOT_FOUND, {"detail": "Job not found"})
            else:
                self._send_json(HTTPStatus.OK, job.to_dict())
            return

        self._send_json(HTTPStatus.NOT_FOUND, {"detail": "Endpoint not found"})

    def do_POST(self) -> None:  # noqa: N802
        parsed_path = urlparse(self.path)
        if parsed_path.path == "/api/submit-scrape-job":
            body = self._read_json_body()
            try:
                request = SubmitScrapeJobRequest.from_dict(body)
            except ValidationError as exc:
                self._send_json(HTTPStatus.BAD_REQUEST, {"detail": str(exc)})
                return
            response = self.store.create_job(request)
            self._send_json(HTTPStatus.CREATED, response)
            return

        self._send_json(HTTPStatus.NOT_FOUND, {"detail": "Endpoint not found"})

    def do_DELETE(self) -> None:  # noqa: N802
        parsed_path = urlparse(self.path)
        if parsed_path.path == "/api/delete-scrape-jobs":
            self.store.delete_jobs()
            self._send_json(HTTPStatus.OK, {"status": "deleted"})
            return
        self._send_json(HTTPStatus.NOT_FOUND, {"detail": "Endpoint not found"})

    def _serve_docs(self) -> None:
        html = (
            "<html><head><title>Scraperr API Docs</title></head>"
            "<body><h1>Scraperr API</h1>"
            "<p>This lightweight server implements the endpoints required "
            "by the test_api.sh script.</p>"
            "<ul>"
            "<li>POST /api/submit-scrape-job</li>"
            "<li>GET /api/jobs</li>"
            "<li>GET /api/job/&lt;job_id&gt;</li>"
            "<li>DELETE /api/delete-scrape-jobs</li>"
            "</ul>"
            "</body></html>"
        ).encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(html)))
        self.end_headers()
        self.wfile.write(html)

    def log_message(self, format: str, *args) -> None:  # noqa: A003
        """Silence the default stdout logging to keep test output clean."""

        return


def run(host: str = "0.0.0.0", port: int = 8000) -> None:
    """Start the threaded HTTP server."""

    with ThreadingHTTPServer((host, port), ScraperrRequestHandler) as httpd:
        httpd.serve_forever()


if __name__ == "__main__":
    run()
