"""
Fixed complete workflow demonstration with proper SQL extraction
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from langchain_community.utilities.sql_database import SQLDatabase
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from sqlalchemy import create_engine
import json
from dotenv import load_dotenv

load_dotenv()


def demonstrate_complete_workflow():
    """Demonstrate the complete workflow for disclosure questions"""
    
    # Initialize components
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    connection_string = f"mysql+pymysql://{os.getenv('MYSQL_USER', 'chinook_user')}:{os.getenv('MYSQL_PASSWORD', 'chinook_pass')}@{os.getenv('MYSQL_HOST', 'localhost')}:{os.getenv('MYSQL_PORT', 3306)}/corporate_data"
    engine = create_engine(connection_string)
    db = SQLDatabase(engine)
    
    # Schema context
    schema_context = """
    Database Tables:
    - company: Company information
    - governance_bodies & governance_members: Board and committee structures  
    - board_meetings: Meeting records with sustainability topics
    - executive_compensation: Executive pay including sustainability-linked bonuses
    - employees: Workforce demographics (gender, age_group, country, region, contract_type)
    - facilities: Company locations (water_stress_area, near_protected_area)
    - ghg_emissions: Scope 1, 2, 3 emissions data (year, month, scope, emission_source, co2_tonnes)
    - energy_consumption: Energy use by type and facility (is_renewable, consumption_mwh)
    - water_usage: Water withdrawal, discharge, consumption (withdrawal_megaliters, etc.)
    - sustainability_targets: ESG targets and progress
    """
    
    # Test questions
    test_questions = [
        {
            "category": "GOVERNANCE",
            "question": "How is sustainability-related performance integrated into incentive schemes for members of the administrative, management, and supervisory bodies?"
        },
        {
            "category": "CLIMATE",
            "question": "What are the gross Scope 1, Scope 2, and Scope 3 greenhouse gas (GHG) emissions in metric tonnes of CO2 equivalent?"
        },
        {
            "category": "SOCIAL",
            "question": "Provide key characteristics of the own workforce, including a breakdown of employees by gender, region, and contract type."
        },
        {
            "category": "WATER",
            "question": "Disclose information on water consumption, withdrawal, and discharge, particularly in areas of high water stress."
        }
    ]
    
    for test_case in test_questions:
        print("\n" + "="*80)
        print(f"DISCLOSURE CATEGORY: {test_case['category']}")
        print("="*80)
        
        # 1. Original Question
        print("\n1. ORIGINAL DISCLOSURE QUESTION:")
        print("-"*60)
        print(test_case['question'])
        
        # 2. Augmented Prompt
        prompt = f"""
You are an expert at translating corporate disclosure questions into SQL queries.

{schema_context}

Question: {test_case['question']}

Generate SQL queries to answer this question. Consider:
- Join multiple tables if needed
- Use aggregations (SUM, COUNT, AVG)
- Filter by year 2024 where applicable
- Include all relevant data points

Provide your response as a JSON object with this structure:
{{
    "queries": [
        {{
            "name": "Query Name",
            "sql": "SELECT ...",
            "purpose": "What this retrieves"
        }}
    ],
    "reasoning": "Your approach"
}}
"""
        
        print("\n2. AUGMENTED PROMPT WITH SCHEMA:")
        print("-"*60)
        print(prompt[:800] + "..." if len(prompt) > 800 else prompt)
        
        # 3. Generate SQL
        print("\n3. AI-GENERATED SQL QUERIES:")
        print("-"*60)
        
        response = llm.invoke([
            SystemMessage(content="You are an expert SQL developer for sustainability reporting. Return only valid JSON."),
            HumanMessage(content=prompt)
        ])
        
        try:
            sql_result = json.loads(response.content)
            print(f"Reasoning: {sql_result['reasoning']}\n")
            
            # 4. Execute queries and show results
            print("\n4. QUERY EXECUTION AND RAW DATA:")
            print("-"*60)
            
            all_results = {}
            for i, query in enumerate(sql_result['queries'], 1):
                print(f"\nQuery {i}: {query['name']}")
                print(f"Purpose: {query['purpose']}")
                print(f"SQL: {query['sql']}")
                
                try:
                    result = db.run(query['sql'])
                    all_results[query['name']] = result
                    print(f"Result: {result[:200]}..." if len(str(result)) > 200 else f"Result: {result}")
                except Exception as e:
                    print(f"Error: {e}")
                    all_results[query['name']] = f"Error: {e}"
            
            # 5. Synthesized Answer
            print("\n5. SYNTHESIZED ANSWER:")
            print("-"*60)
            
            synthesis_prompt = f"""
Based on the following query results, provide a comprehensive answer to this disclosure question:

Question: {test_case['question']}

Data Retrieved:
{json.dumps(all_results, indent=2, default=str)}

Provide a professional, CSRD-compliant answer that:
1. Directly addresses the question
2. Uses specific data points
3. Follows formal disclosure standards
4. Notes any data limitations
"""
            
            answer_response = llm.invoke([
                SystemMessage(content="You are a sustainability reporting expert preparing formal disclosures."),
                HumanMessage(content=synthesis_prompt)
            ])
            
            print(answer_response.content)
            
        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
            print(f"Raw response: {response.content}")


if __name__ == "__main__":
    print("CORPORATE DISCLOSURE AGENT - COMPLETE WORKFLOW DEMONSTRATION")
    print("="*80)
    demonstrate_complete_workflow()
    print("\n\nDEMONSTRATION COMPLETE")