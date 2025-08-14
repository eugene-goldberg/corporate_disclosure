"""
FastAPI server for Corporate Disclosure Agent V2
Uses the same augmented prompt logic as generate_disclosure_report_corrected.py
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

from langchain_community.utilities.sql_database import SQLDatabase
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from sqlalchemy import create_engine

load_dotenv()

# Initialize FastAPI app
app = FastAPI(
    title="Corporate Disclosure API V2",
    description="Enhanced API for answering ESRS disclosure questions with augmented prompts",
    version="2.0.0",
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

# Initialize database and LLM
llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
connection_string = f"mysql+pymysql://{os.getenv('MYSQL_USER', 'chinook_user')}:{os.getenv('MYSQL_PASSWORD', 'chinook_pass')}@{os.getenv('MYSQL_HOST', 'localhost')}:{os.getenv('MYSQL_PORT', 3306)}/corporate_data"
engine = create_engine(connection_string)
db = SQLDatabase(engine)

def get_database_schema():
    """Return the complete database schema description"""
    return """Database Schema:
- company: Company information (company_id, name, headquarters_country, industry_sector, founded_year, website)
- governance_bodies: Board and committee structures (body_id, body_name, body_type, description)
- governance_members: Member details (member_id, body_id, name, position, gender, start_date, sustainability_expertise)
- board_meetings: Meeting records (meeting_id, body_id, meeting_date, sustainability_topics_discussed, attendees, total_members)
- executive_compensation: Executive pay (comp_id, member_id, year, base_salary_usd, bonus_usd, sustainability_linked_bonus_usd, sustainability_kpi_description)
- employees: Workforce data (employee_id, employee_code, gender, age_group, country, region, contract_type, department, hire_date, termination_date, salary_band, has_disability)
- employee_training: Training records (training_id, employee_id, training_type, training_category, hours, completion_date)
- workplace_incidents: Safety records (incident_id, incident_date, incident_type, severity, location, description, lost_time_days)
- facilities: Locations (facility_id, facility_name, facility_type, country, region, latitude, longitude, near_protected_area, water_stress_area)
- energy_consumption: Energy use (consumption_id, facility_id, year, month, energy_type, is_renewable, consumption_mwh, cost_usd)
- ghg_emissions: Emissions data (emission_id, facility_id, year, month, scope, emission_source, co2_tonnes, calculation_method)
- water_usage: Water metrics (usage_id, facility_id, year, month, water_source, withdrawal_megaliters, discharge_megaliters, consumption_megaliters)
- waste_generation: Waste data (waste_id, facility_id, year, month, waste_type, disposal_method, quantity_tonnes)
- suppliers: Supplier info (supplier_id, supplier_name, country, supplier_tier, supplier_type, is_sme, sustainability_certified, certification_type)
- supplier_transactions: Payments (transaction_id, supplier_id, invoice_date, payment_date, amount_usd, payment_terms_days)
- materials_sourced: Materials data (material_id, supplier_id, material_name, material_category, is_renewable, is_recycled, quantity_tonnes, year)
- financial_metrics: Financial data (metric_id, year, quarter, revenue_usd, operating_expenses_usd, sustainability_investments_usd, carbon_tax_provision_usd, climate_risk_provision_usd)
- sustainability_targets: ESG targets (target_id, target_category, target_name, target_description, baseline_year, baseline_value, target_year, target_value, unit_of_measure, current_value, last_updated)
- policies: Corporate policies (policy_id, policy_name, policy_category, effective_date, last_reviewed, policy_text, applies_to_suppliers)
- compliance_incidents: Violations (incident_id, incident_date, incident_type, description, fine_amount_usd, remediation_status)
- stakeholder_engagement: Engagement records (engagement_id, stakeholder_group, engagement_date, engagement_method, topics_discussed, outcomes, participants)
- community_projects: Community initiatives (project_id, project_name, location, start_date, end_date, investment_usd, beneficiaries, project_type, description)
- lobbying_activities: Political activities (activity_id, year, organization_name, topic, amount_usd, activity_type)
- product_incidents: Product safety (incident_id, incident_date, product_name, incident_type, affected_units, description, remediation_cost_usd)"""

def load_disclosure_questions():
    """Load all questions from disclosure_questions.json"""
    questions_file = os.path.join(os.path.dirname(__file__), 'disclosure_questions.json')
    with open(questions_file, 'r') as f:
        return json.load(f)

# Pydantic models
class QuestionRequest(BaseModel):
    question: str = Field(..., description="The disclosure question to answer")
    year: Optional[int] = Field(default=2024, description="Reporting year")
    include_augmented_prompt: bool = Field(default=False, description="Include the augmented prompt in response")
    include_sql: bool = Field(default=True, description="Include generated SQL queries in response")
    include_reasoning: bool = Field(default=True, description="Include AI reasoning in response")
    include_raw_results: bool = Field(default=False, description="Include raw query results")

class SQLQuery(BaseModel):
    name: str
    sql: str
    purpose: str

class QuestionResponse(BaseModel):
    question: str
    answer: str
    augmented_prompt: Optional[str] = None
    sql_queries: Optional[List[SQLQuery]] = None
    reasoning: Optional[str] = None
    query_results: Optional[Dict[str, Any]] = None
    processing_time: float
    timestamp: str

# Helper functions
def generate_augmented_prompt(question: str, year: int = 2024) -> str:
    """Generate the augmented prompt with full schema"""
    schema = get_database_schema()
    
    prompt = f"""You are an expert at translating corporate disclosure questions into SQL queries.

{schema}

Additional Context:
- Reporting year: {year}
- Company operates globally with facilities in multiple countries
- Data includes environmental, social, and governance metrics

Question: {question}

Generate SQL queries to comprehensively answer this disclosure question. Consider:
- Join multiple tables when needed
- Use aggregations (SUM, COUNT, AVG, etc.)
- Filter by year {year} where applicable
- Include all relevant data points
- Consider both quantitative metrics and qualitative information
- For boolean fields, use TRUE/FALSE not 1/0 or string values
- Be careful with data types (don't average text fields)

Return your response as a JSON object:
{{
    "queries": [
        {{
            "name": "Descriptive name for the query",
            "sql": "SELECT ...",
            "purpose": "What this query retrieves"
        }}
    ],
    "reasoning": "Your approach to answering the question"
}}"""
    
    return prompt

def process_disclosure_question(question: str, year: int = 2024) -> Dict[str, Any]:
    """Process a disclosure question using the same logic as the corrected report generator"""
    
    # Generate augmented prompt
    augmented_prompt = generate_augmented_prompt(question, year)
    
    # Get SQL queries from LLM
    try:
        response = llm.invoke([
            SystemMessage(content="You are an expert SQL developer for sustainability reporting. Return only valid JSON."),
            HumanMessage(content=augmented_prompt)
        ])
        
        # Parse the JSON response
        try:
            sql_result = json.loads(response.content)
        except json.JSONDecodeError:
            # If JSON parsing fails, create a simple structure
            sql_result = {
                "queries": [{
                    "name": "Query Parse Error",
                    "sql": "-- Unable to parse SQL response",
                    "purpose": "Error in SQL generation"
                }],
                "reasoning": "JSON parsing error in response"
            }
        
        # Execute queries and collect results
        all_results = {}
        
        for query in sql_result.get('queries', []):
            try:
                sql_query = query.get('sql', '')
                if sql_query and not sql_query.startswith('--'):
                    result = db.run(sql_query)
                    all_results[query.get('name', 'Unnamed Query')] = {
                        'data': result,
                        'success': True,
                        'purpose': query.get('purpose', '')
                    }
                else:
                    all_results[query.get('name', 'Unnamed Query')] = {
                        'error': 'Invalid SQL query',
                        'success': False,
                        'purpose': query.get('purpose', '')
                    }
            except Exception as e:
                all_results[query.get('name', 'Unnamed Query')] = {
                    'error': str(e),
                    'success': False,
                    'purpose': query.get('purpose', '')
                }
        
        # Generate comprehensive answer
        synthesis_prompt = f"""Based on the following query results, provide a comprehensive, professional answer to this disclosure question following CSRD/ESRS standards:

Question: {question}

Data Retrieved:
{json.dumps(all_results, indent=2, default=str)[:3000]}

Provide a formal disclosure answer that:
1. Directly addresses all aspects of the question
2. Uses specific data points from the query results
3. Provides context and explanations where needed
4. Follows ESRS disclosure standards for clarity and completeness
5. Notes any data limitations or gaps
6. Uses professional language appropriate for regulatory disclosure

Structure the answer with clear headings and bullet points where appropriate."""
        
        answer_response = llm.invoke([
            SystemMessage(content="You are a sustainability reporting expert preparing CSRD-compliant disclosures."),
            HumanMessage(content=synthesis_prompt)
        ])
        
        return {
            'augmented_prompt': augmented_prompt,
            'sql_queries': sql_result.get('queries', []),
            'reasoning': sql_result.get('reasoning', ''),
            'query_results': all_results,
            'answer': answer_response.content
        }
        
    except Exception as e:
        raise Exception(f"Error processing question: {str(e)}")

# API Endpoints
@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "name": "Corporate Disclosure API V2",
        "version": "2.0.0",
        "description": "Enhanced API with augmented prompts",
        "documentation": "/docs"
    }

@app.get("/health")
async def health_check():
    """Check API and database health"""
    try:
        # Test database connection
        db_connected = True
        try:
            test_result = db.run("SELECT 1")
            db_connected = True
        except Exception:
            db_connected = False
        
        return {
            "status": "healthy" if db_connected else "degraded",
            "database_connected": db_connected,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database_connected": False,
            "timestamp": datetime.now().isoformat()
        }

@app.post("/answer", response_model=QuestionResponse)
async def answer_question(request: QuestionRequest):
    """Answer a disclosure question with augmented prompt processing"""
    start_time = datetime.now()
    
    try:
        # Process the question
        result = process_disclosure_question(request.question, request.year)
        
        # Calculate processing time
        processing_time = (datetime.now() - start_time).total_seconds()
        
        # Build response based on requested fields
        response_data = {
            "question": request.question,
            "answer": result['answer'],
            "processing_time": processing_time,
            "timestamp": datetime.now().isoformat()
        }
        
        if request.include_augmented_prompt:
            response_data["augmented_prompt"] = result['augmented_prompt']
        
        if request.include_sql:
            response_data["sql_queries"] = [
                SQLQuery(**query) for query in result['sql_queries']
            ]
        
        if request.include_reasoning:
            response_data["reasoning"] = result['reasoning']
        
        if request.include_raw_results:
            response_data["query_results"] = result['query_results']
        
        return QuestionResponse(**response_data)
        
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Error processing question: {str(e)}"
        )

@app.get("/questions")
async def get_all_questions():
    """Get all available disclosure questions"""
    try:
        questions = load_disclosure_questions()
        return {
            "categories": questions,
            "total_categories": len(questions),
            "total_questions": sum(len(q) for q in questions.values())
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading questions: {str(e)}")

# Run the server
if __name__ == "__main__":
    port = int(os.getenv("API_PORT", 8001))
    host = os.getenv("API_HOST", "0.0.0.0")
    
    print(f"Starting Corporate Disclosure API V2 at {host}:{port}")
    print(f"Documentation available at http://localhost:{port}/docs")
    
    uvicorn.run("api_server_v2:app", host=host, port=port, reload=True)