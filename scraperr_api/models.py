"""Simple dataclasses that model the Scraperr API payloads."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from typing import Any, Dict, List, Optional


class ValidationError(ValueError):
    """Raised when incoming data does not match the expected schema."""


@dataclass
class ScrapeElement:
    name: str
    xpath: str
    url: Optional[str] = None

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "ScrapeElement":
        try:
            name = str(data["name"])
            xpath = str(data["xpath"])
        except KeyError as exc:
            raise ValidationError(f"Missing required element field: {exc.args[0]}") from exc
        url = data.get("url")
        if url is not None:
            url = str(url)
        return cls(name=name, xpath=xpath, url=url)

    def to_dict(self) -> Dict[str, Optional[str]]:
        return {"name": self.name, "xpath": self.xpath, "url": self.url}


@dataclass
class JobOptions:
    multi_page_scrape: bool = False
    custom_headers: Dict[str, str] = field(default_factory=dict)

    @classmethod
    def from_dict(cls, data: Optional[Dict[str, Any]]) -> "JobOptions":
        if data is None:
            return cls()
        return cls(
            multi_page_scrape=bool(data.get("multi_page_scrape", False)),
            custom_headers={str(k): str(v) for k, v in data.get("custom_headers", {}).items()},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "multi_page_scrape": self.multi_page_scrape,
            "custom_headers": dict(self.custom_headers),
        }


@dataclass
class SubmitScrapeJobRequest:
    url: str
    elements: List[ScrapeElement] = field(default_factory=list)
    job_options: JobOptions = field(default_factory=JobOptions)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "SubmitScrapeJobRequest":
        if "url" not in data:
            raise ValidationError("The 'url' field is required.")
        url = str(data["url"])
        elements_data = data.get("elements", []) or []
        if not isinstance(elements_data, list):
            raise ValidationError("The 'elements' field must be a list.")
        elements = [ScrapeElement.from_dict(item) for item in elements_data]
        job_options = JobOptions.from_dict(data.get("job_options"))
        return cls(url=url, elements=elements, job_options=job_options)

    @classmethod
    def from_json(cls, payload: str) -> "SubmitScrapeJobRequest":
        import json

        return cls.from_dict(json.loads(payload))

    def to_dict(self) -> Dict[str, Any]:
        return {
            "url": self.url,
            "elements": [element.to_dict() for element in self.elements],
            "job_options": self.job_options.to_dict(),
        }


@dataclass
class JobSummary:
    id: str
    url: str
    status: str
    created_at: datetime

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "url": self.url,
            "status": self.status,
            "created_at": self.created_at.isoformat(),
        }


@dataclass
class JobDetail(JobSummary):
    request_payload: SubmitScrapeJobRequest = field(default_factory=SubmitScrapeJobRequest)
    results: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> Dict[str, Any]:
        base = super().to_dict()
        base.update(
            {
                "request_payload": self.request_payload.to_dict(),
                "results": self.results,
            }
        )
        return base
