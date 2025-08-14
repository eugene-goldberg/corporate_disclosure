"""
FastAPI server for Corporate Disclosure Agent
Provides REST API endpoints to interact with the disclosure agent
"""

from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Dict, List, Any, Optional
from datetime import datetime
import json
import os
import sys
import uvicorn
from dotenv import load_dotenv

# Add parent directory to path for imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from corporate_disclosure.agents.disclosure_agent import DisclosureAgent

load_dotenv()

# Initialize FastAPI app
app = FastAPI(
    title="Corporate Disclosure API",
    description="API for answering ESRS disclosure questions using AI",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify allowed origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize the disclosure agent
disclosure_agent = DisclosureAgent()

# Load disclosure questions
def load_disclosure_questions():
    """Load all questions from disclosure_questions.json"""
    questions_file = os.path.join(os.path.dirname(__file__), 'disclosure_questions.json')
    with open(questions_file, 'r') as f:
        return json.load(f)

# Pydantic models for request/response
class QuestionRequest(BaseModel):
    question: str = Field(..., description="The disclosure question to answer")
    context: Optional[Dict[str, Any]] = Field(default=None, description="Additional context (e.g., reporting year)")
    include_sql: bool = Field(default=True, description="Include generated SQL queries in response")
    include_reasoning: bool = Field(default=True, description="Include AI reasoning in response")

class QuestionResponse(BaseModel):
    question: str
    answer: str
    sql_queries: Optional[List[Dict[str, str]]] = None
    reasoning: Optional[str] = None
    query_results: Optional[Dict[str, Any]] = None
    processing_time: Optional[float] = None
    timestamp: str

class CategoryResponse(BaseModel):
    category: str
    questions: List[Dict[str, str]]
    count: int

class HealthResponse(BaseModel):
    status: str
    database_connected: bool
    timestamp: str

# API Endpoints
@app.get("/", response_model=Dict[str, str])
async def root():
    """Root endpoint with API information"""
    return {
        "name": "Corporate Disclosure API",
        "version": "1.0.0",
        "documentation": "/docs",
        "health": "/health"
    }

@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Check API and database health"""
    try:
        # Test database connection
        db_connected = True
        try:
            test_result = disclosure_agent.db.run("SELECT 1")
            db_connected = True
        except Exception:
            db_connected = False
        
        return HealthResponse(
            status="healthy" if db_connected else "degraded",
            database_connected=db_connected,
            timestamp=datetime.now().isoformat()
        )
    except Exception as e:
        return HealthResponse(
            status="unhealthy",
            database_connected=False,
            timestamp=datetime.now().isoformat()
        )

@app.get("/questions", response_model=Dict[str, List[CategoryResponse]])
async def get_all_questions():
    """Get all available disclosure questions organized by category"""
    try:
        questions = load_disclosure_questions()
        
        categories = []
        for category, question_list in questions.items():
            categories.append(CategoryResponse(
                category=category,
                questions=question_list,
                count=len(question_list)
            ))
        
        return {
            "categories": categories,
            "total_questions": sum(cat.count for cat in categories)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading questions: {str(e)}")

@app.get("/questions/{category}", response_model=CategoryResponse)
async def get_questions_by_category(category: str):
    """Get questions for a specific category"""
    try:
        questions = load_disclosure_questions()
        
        if category not in questions:
            raise HTTPException(status_code=404, detail=f"Category '{category}' not found")
        
        return CategoryResponse(
            category=category,
            questions=questions[category],
            count=len(questions[category])
        )
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Questions file not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading questions: {str(e)}")

@app.post("/answer", response_model=QuestionResponse)
async def answer_question(request: QuestionRequest):
    """Answer a specific disclosure question"""
    start_time = datetime.now()
    
    try:
        # Process the question
        result = disclosure_agent.answer_disclosure_question(
            question=request.question,
            context=request.context
        )
        
        # Calculate processing time
        processing_time = (datetime.now() - start_time).total_seconds()
        
        # Build response based on requested fields
        response_data = {
            "question": result['question'],
            "answer": result['answer'],
            "processing_time": processing_time,
            "timestamp": datetime.now().isoformat()
        }
        
        if request.include_sql:
            response_data["sql_queries"] = result.get('sql_queries', [])
            response_data["query_results"] = result.get('query_results', {})
        
        if request.include_reasoning:
            response_data["reasoning"] = result.get('reasoning', '')
        
        return QuestionResponse(**response_data)
        
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Error processing question: {str(e)}"
        )

@app.post("/answer/batch", response_model=List[QuestionResponse])
async def answer_multiple_questions(
    questions: List[QuestionRequest],
    background_tasks: BackgroundTasks
):
    """Answer multiple disclosure questions"""
    if len(questions) > 10:
        raise HTTPException(
            status_code=400,
            detail="Maximum 10 questions allowed per batch request"
        )
    
    responses = []
    for question_request in questions:
        try:
            response = await answer_question(question_request)
            responses.append(response)
        except Exception as e:
            # Include error response for failed questions
            responses.append(QuestionResponse(
                question=question_request.question,
                answer=f"Error: {str(e)}",
                timestamp=datetime.now().isoformat(),
                processing_time=0
            ))
    
    return responses

@app.get("/categories", response_model=List[str])
async def get_categories():
    """Get list of all question categories"""
    try:
        questions = load_disclosure_questions()
        return list(questions.keys())
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading categories: {str(e)}")

# Run the server
if __name__ == "__main__":
    port = int(os.getenv("API_PORT", 8000))
    host = os.getenv("API_HOST", "0.0.0.0")
    
    print(f"Starting Corporate Disclosure API server at {host}:{port}")
    print(f"Documentation available at http://localhost:{port}/docs")
    
    uvicorn.run("api_server:app", host=host, port=port, reload=True)