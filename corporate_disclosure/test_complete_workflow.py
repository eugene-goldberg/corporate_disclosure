"""
Complete workflow demonstration showing:
1. Original disclosure question
2. Augmented prompt with schema
3. Generated SQL
4. Synthesized answer from data
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from corporate_disclosure.agents.disclosure_agent import DisclosureAgent
from langchain_community.utilities.sql_database import SQLDatabase
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from sqlalchemy import create_engine
import json
from dotenv import load_dotenv

load_dotenv()


class DetailedDisclosureAgent(DisclosureAgent):
    """Extended agent that shows all intermediate steps"""
    
    def answer_disclosure_question_detailed(self, question: str, context: dict = None):
        """Show complete workflow with all intermediate steps"""
        
        print("\n" + "="*80)
        print("COMPLETE DISCLOSURE WORKFLOW")
        print("="*80)
        
        # Step 1: Show original question
        print("\n1. ORIGINAL DISCLOSURE QUESTION:")
        print("-"*60)
        print(question)
        
        # Step 2: Show augmented prompt with schema
        print("\n2. AUGMENTED PROMPT WITH SCHEMA INFORMATION:")
        print("-"*60)
        
        sql_prompt = f"""
You are an expert at translating corporate disclosure questions into SQL queries.

Database Schema Context:
{self.schema_context}

DETAILED TABLE STRUCTURES:
- employees: employee_id, employee_code, gender, age_group, country, region, contract_type, department, hire_date, termination_date, salary_band, has_disability
- governance_members: member_id, body_id, name, position, gender, start_date, sustainability_expertise
- governance_bodies: body_id, body_name, body_type, description
- board_meetings: meeting_id, body_id, meeting_date, sustainability_topics_discussed, attendees, total_members
- executive_compensation: comp_id, member_id, year, base_salary_usd, bonus_usd, sustainability_linked_bonus_usd, sustainability_kpi_description
- ghg_emissions: emission_id, facility_id, year, month, scope, emission_source, co2_tonnes, calculation_method
- energy_consumption: consumption_id, facility_id, year, month, energy_type, is_renewable, consumption_mwh, cost_usd
- water_usage: usage_id, facility_id, year, month, water_source, withdrawal_megaliters, discharge_megaliters, consumption_megaliters
- facilities: facility_id, facility_name, facility_type, country, region, latitude, longitude, near_protected_area, water_stress_area
- suppliers: supplier_id, supplier_name, country, supplier_tier, supplier_type, is_sme, sustainability_certified
- sustainability_targets: target_id, target_category, target_name, target_description, baseline_year, baseline_value, target_year, target_value, unit_of_measure, current_value
- policies: policy_id, policy_name, policy_category, effective_date, last_reviewed, policy_text, applies_to_suppliers

Additional Context:
- Reporting year: {context.get('year', 2024) if context else 2024}
- Company operates globally with facilities in multiple countries
- Data includes environmental, social, and governance metrics

Question: {question}

Generate the SQL query(ies) needed to answer this question comprehensively.
Consider:
1. You may need multiple queries to gather all relevant data
2. Use appropriate JOINs to connect related tables
3. Include aggregations where needed (SUM, COUNT, AVG, etc.)
4. Consider time periods and filtering
5. Think about both quantitative data and qualitative information

Return a JSON object with:
{{
    "queries": [
        {{
            "name": "descriptive name",
            "sql": "the SQL query",
            "purpose": "what this query retrieves"
        }}
    ],
    "reasoning": "explanation of approach"
}}
"""
        
        print(sql_prompt[:1500] + "..." if len(sql_prompt) > 1500 else sql_prompt)
        
        # Step 3: Generate SQL
        print("\n3. GENERATED SQL QUERIES:")
        print("-"*60)
        
        response = self.llm.invoke([
            SystemMessage(content="You are an expert SQL developer for sustainability reporting."),
            HumanMessage(content=sql_prompt)
        ])
        
        try:
            sql_generation = json.loads(response.content)
        except:
            sql_generation = {
                "queries": [{"name": "Query", "sql": response.content, "purpose": "Answer question"}],
                "reasoning": "Direct generation"
            }
            
        print(f"Reasoning: {sql_generation['reasoning']}\n")
        for i, query in enumerate(sql_generation['queries'], 1):
            print(f"Query {i} - {query['name']}:")
            print(f"Purpose: {query['purpose']}")
            print(f"SQL:\n{query['sql']}\n")
        
        # Step 4: Execute queries and show raw results
        print("\n4. QUERY EXECUTION RESULTS:")
        print("-"*60)
        
        query_results = {}
        for query in sql_generation['queries']:
            try:
                result = self.db.run(query['sql'])
                query_results[query['name']] = {
                    'data': result,
                    'purpose': query['purpose'],
                    'success': True
                }
                print(f"\n{query['name']}:")
                print(f"Result: {result[:500]}..." if len(str(result)) > 500 else f"Result: {result}")
            except Exception as e:
                query_results[query['name']] = {
                    'error': str(e),
                    'purpose': query['purpose'],
                    'success': False
                }
                print(f"\n{query['name']}:")
                print(f"Error: {e}")
        
        # Step 5: Synthesize answer
        print("\n5. SYNTHESIZED ANSWER:")
        print("-"*60)
        
        final_answer = self.synthesize_answer(question, query_results)
        print(final_answer)
        
        return {
            'question': question,
            'prompt': sql_prompt,
            'sql_queries': sql_generation['queries'],
            'reasoning': sql_generation['reasoning'],
            'query_results': query_results,
            'answer': final_answer
        }


def demonstrate_complete_workflow():
    """Demonstrate the complete workflow for multiple disclosure questions"""
    
    # Initialize the detailed agent
    agent = DetailedDisclosureAgent()
    
    # Test questions covering different ESRS areas
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
        print("\n\n" + "#"*80)
        print(f"# DISCLOSURE CATEGORY: {test_case['category']}")
        print("#"*80)
        
        result = agent.answer_disclosure_question_detailed(test_case['question'])
        
        # Save results for documentation
        print("\n" + "-"*60)
        print("WORKFLOW COMPLETE")
        print("-"*60)


if __name__ == "__main__":
    print("CORPORATE DISCLOSURE AGENT - COMPLETE WORKFLOW DEMONSTRATION")
    print("="*80)
    print("This demonstration shows the full process from question to answer:")
    print("1. Original disclosure question")
    print("2. Augmented prompt with database schema")
    print("3. AI-generated SQL queries")
    print("4. Query execution results")
    print("5. Synthesized disclosure answer")
    
    demonstrate_complete_workflow()
    
    print("\n\nDEMONSTRATION COMPLETE")