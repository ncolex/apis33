#!/bin/bash

# Test script for Scraperr API

echo "Testing Scraperr API endpoints..."

# Test 1: Check if API docs are accessible
echo -e "\n1. Testing API documentation endpoint..."
curl -X GET http://localhost:8000/docs

echo -e "\n\n2. Testing scrape job submission..."
# Test 2: Submit a scrape job
curl -X POST http://localhost:8000/api/submit-scrape-job \
  -H "Content-Type: application/json" \
  -d '{
    "url": "http://quotes.toscrape.com/",
    "elements": [
      {
        "name": "Quotes",
        "xpath": "//span[@class=\"text\"]",
        "url": "http://quotes.toscrape.com/"
      }
    ],
    "job_options": {
      "multi_page_scrape": false,
      "custom_headers": {}
    }
  }'

echo -e "\n\n3. Waiting for job to process (sleeping 10 seconds)..."
sleep 10

# Test 3: List jobs to get the job ID
echo -e "\n4. Getting list of jobs..."
JOBS_RESPONSE=$(curl -s -X GET http://localhost:8000/api/jobs)

# Extract the first job ID from the response
JOB_ID=$(echo $JOBS_RESPONSE | python3 -c "import sys, json; print(json.load(sys.stdin)['jobs'][0]['id'])" 2>/dev/null || echo "unknown")
echo "Retrieved job ID: $JOB_ID"

# Test 4: Get details of the job if we have a valid ID
if [ "$JOB_ID" != "unknown" ]; then
    echo -e "\n5. Testing job details endpoint for job ID: $JOB_ID"
    curl -X GET http://localhost:8000/api/job/$JOB_ID
fi

# Test 5: Delete all jobs
echo -e "\n\n6. Testing job deletion..."
curl -X DELETE http://localhost:8000/api/delete-scrape-jobs

echo -e "\n\nAPI tests completed."