# Corporate Disclosure API

A FastAPI-based REST API for the Corporate Disclosure Agent that answers ESRS disclosure questions using AI.

## Features

- **GET endpoints** to retrieve available disclosure questions by category
- **POST endpoints** to answer disclosure questions with AI-generated SQL and comprehensive responses
- **Batch processing** support for multiple questions
- **Health check** endpoint for monitoring
- **Automatic API documentation** via Swagger UI and ReDoc
- **CORS support** for cross-origin requests

## Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Set up environment variables in `.env`:
```
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=chinook_user
MYSQL_PASSWORD=chinook_pass
MYSQL_DATABASE=corporate_data
OPENAI_API_KEY=your_openai_api_key
API_PORT=8000
API_HOST=0.0.0.0
```

3. Ensure MySQL database is running with the corporate_data schema

## Running the API

```bash
python api_server.py
```

The API will start on `http://localhost:8000` by default.

## API Endpoints

### Health Check
- `GET /health` - Check API and database connectivity

### Questions
- `GET /questions` - Get all disclosure questions organized by category
- `GET /questions/{category}` - Get questions for a specific category
- `GET /categories` - Get list of all available categories

### Answer Questions
- `POST /answer` - Answer a single disclosure question
- `POST /answer/batch` - Answer multiple questions (max 10 per request)

## API Documentation

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Example Usage

### Answer a Single Question

```python
import requests

response = requests.post("http://localhost:8000/answer", json={
    "question": "What are the gross Scope 1, Scope 2, and Scope 3 GHG emissions?",
    "context": {"year": 2024},
    "include_sql": True,
    "include_reasoning": True
})

result = response.json()
print(result["answer"])
```

### Get Questions by Category

```python
response = requests.get("http://localhost:8000/questions/environmental_climate_change")
questions = response.json()
```

### Batch Processing

```python
questions = [
    {"question": "Question 1", "include_sql": True},
    {"question": "Question 2", "include_sql": False}
]

response = requests.post("http://localhost:8000/answer/batch", json=questions)
results = response.json()
```

## Response Format

### Question Answer Response
```json
{
    "question": "The original question",
    "answer": "Comprehensive ESRS-compliant answer",
    "sql_queries": [
        {
            "name": "Query name",
            "sql": "SELECT ...",
            "purpose": "What this query retrieves"
        }
    ],
    "reasoning": "AI reasoning for SQL generation",
    "query_results": {
        "Query name": "Results data"
    },
    "processing_time": 2.5,
    "timestamp": "2024-01-15T10:30:00"
}
```

## Error Handling

The API returns appropriate HTTP status codes:
- `200` - Success
- `400` - Bad request (e.g., too many questions in batch)
- `404` - Resource not found (e.g., invalid category)
- `500` - Internal server error

Error responses include detail messages:
```json
{
    "detail": "Error description"
}
```

## Performance Considerations

- Single question processing typically takes 2-5 seconds
- Batch requests are processed sequentially
- Maximum 10 questions per batch request
- Database connection pooling is used for efficiency

## Security Notes

- CORS is currently set to allow all origins (`*`) - restrict in production
- No authentication is implemented - add as needed
- SQL injection is prevented by using parameterized queries
- Input validation is performed via Pydantic models