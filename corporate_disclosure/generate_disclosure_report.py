"""
Generate a complete disclosure report showing the full workflow for each question
Output includes: question, prompt, SQL, and synthesized answer
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from langchain_community.utilities.sql_database import SQLDatabase
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from sqlalchemy import create_engine
import json
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()


def generate_disclosure_report():
    """Generate complete disclosure report with all workflow steps"""
    
    # Initialize components
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    connection_string = f"mysql+pymysql://{os.getenv('MYSQL_USER', 'chinook_user')}:{os.getenv('MYSQL_PASSWORD', 'chinook_pass')}@{os.getenv('MYSQL_HOST', 'localhost')}:{os.getenv('MYSQL_PORT', 3306)}/corporate_data"
    engine = create_engine(connection_string)
    db = SQLDatabase(engine)
    
    # Open output file
    output_file = "corporate_disclosure_complete_report.md"
    
    with open(output_file, 'w') as f:
        # Write header
        f.write("# Corporate Disclosure AI Agent - Complete Workflow Report\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("This report demonstrates the complete workflow from disclosure question to final answer.\n")
        f.write("For each question, it shows:\n")
        f.write("1. Original disclosure question\n")
        f.write("2. Augmented prompt with schema\n")
        f.write("3. Generated SQL queries\n")
        f.write("4. Synthesized answer from data\n\n")
        f.write("---\n\n")
        
        # Define test questions
        test_questions = [
            {
                "category": "GOVERNANCE (ESRS 2 GOV-3)",
                "question": "How is sustainability-related performance integrated into incentive schemes for members of the administrative, management, and supervisory bodies?"
            },
            {
                "category": "CLIMATE (ESRS E1-6)",
                "question": "What are the gross Scope 1, Scope 2, and Scope 3 greenhouse gas (GHG) emissions in metric tonnes of CO2 equivalent?"
            },
            {
                "category": "SOCIAL - OWN WORKFORCE (ESRS S1-9)",
                "question": "Provide key characteristics of the own workforce, including a breakdown of employees by gender, region, and contract type."
            },
            {
                "category": "WATER & MARINE RESOURCES (ESRS E3-4)",
                "question": "Disclose information on water consumption, withdrawal, and discharge, particularly in areas of high water stress."
            },
            {
                "category": "BUSINESS CONDUCT (ESRS G1-4)",
                "question": "Disclose information on payment practices, particularly regarding the average time to pay invoices and late payments to small and medium-sized enterprises (SMEs)."
            }
        ]
        
        # Process each question
        for i, test_case in enumerate(test_questions, 1):
            f.write(f"## {i}. {test_case['category']}\n\n")
            
            # 1. Original Question
            f.write("### 1.1 Original Disclosure Question\n")
            f.write(f"> {test_case['question']}\n\n")
            
            # 2. Augmented Prompt
            f.write("### 1.2 Augmented Prompt with Schema\n")
            f.write("```\n")
            
            prompt = f"""You are an expert at translating corporate disclosure questions into SQL queries.

Database Schema:
- company: Company information (company_id, name, headquarters_country, industry_sector)
- governance_bodies: Board and committee structures (body_id, body_name, body_type)
- governance_members: Member details (member_id, body_id, name, position, gender, sustainability_expertise)
- board_meetings: Meeting records (meeting_id, body_id, meeting_date, sustainability_topics_discussed, attendees)
- executive_compensation: Executive pay (comp_id, member_id, year, base_salary_usd, bonus_usd, sustainability_linked_bonus_usd, sustainability_kpi_description)
- employees: Workforce data (employee_id, gender, age_group, country, region, contract_type, department, hire_date, termination_date, salary_band, has_disability)
- employee_training: Training records (training_id, employee_id, training_type, training_category, hours, completion_date)
- facilities: Locations (facility_id, facility_name, facility_type, country, region, water_stress_area, near_protected_area)
- energy_consumption: Energy use (consumption_id, facility_id, year, month, energy_type, is_renewable, consumption_mwh, cost_usd)
- ghg_emissions: Emissions data (emission_id, facility_id, year, month, scope, emission_source, co2_tonnes, calculation_method)
- water_usage: Water metrics (usage_id, facility_id, year, month, water_source, withdrawal_megaliters, discharge_megaliters, consumption_megaliters)
- waste_generation: Waste data (waste_id, facility_id, year, month, waste_type, disposal_method, quantity_tonnes)
- suppliers: Supplier info (supplier_id, supplier_name, country, supplier_tier, supplier_type, is_sme, sustainability_certified)
- supplier_transactions: Payments (transaction_id, supplier_id, invoice_date, payment_date, amount_usd, payment_terms_days)
- sustainability_targets: ESG targets (target_id, target_category, target_name, baseline_year, baseline_value, target_year, target_value, current_value)
- policies: Corporate policies (policy_id, policy_name, policy_category, effective_date, policy_text, applies_to_suppliers)
- stakeholder_engagement: Engagement records (engagement_id, stakeholder_group, engagement_date, engagement_method, topics_discussed, outcomes)

Question: {test_case['question']}

Generate SQL queries to comprehensively answer this disclosure question. Consider:
- Join multiple tables when needed
- Use aggregations (SUM, COUNT, AVG, etc.)
- Filter by year 2024 where applicable
- Include all relevant data points
- Consider both quantitative metrics and qualitative information

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
            
            f.write(prompt)
            f.write("\n```\n\n")
            
            # 3. Generate SQL
            f.write("### 1.3 Generated SQL Queries\n")
            
            try:
                response = llm.invoke([
                    SystemMessage(content="You are an expert SQL developer for sustainability reporting. Return only valid JSON."),
                    HumanMessage(content=prompt)
                ])
                
                sql_result = json.loads(response.content)
                
                f.write(f"**AI Reasoning:** {sql_result['reasoning']}\n\n")
                
                # Execute queries and collect results
                all_results = {}
                
                for j, query in enumerate(sql_result['queries'], 1):
                    f.write(f"#### Query {j}: {query['name']}\n")
                    f.write(f"**Purpose:** {query['purpose']}\n\n")
                    f.write("```sql\n")
                    f.write(query['sql'])
                    f.write("\n```\n\n")
                    
                    # Execute query
                    try:
                        result = db.run(query['sql'])
                        all_results[query['name']] = result
                        f.write("**Results:**\n")
                        if len(str(result)) > 1000:
                            f.write(f"```\n{str(result)[:1000]}...\n[Truncated - {len(str(result))} total characters]\n```\n\n")
                        else:
                            f.write(f"```\n{result}\n```\n\n")
                    except Exception as e:
                        f.write(f"**Error:** {e}\n\n")
                        all_results[query['name']] = f"Error: {e}"
                
                # 4. Synthesized Answer
                f.write("### 1.4 Synthesized Answer\n")
                
                synthesis_prompt = f"""
Based on the following query results, provide a comprehensive, professional answer to this disclosure question following CSRD/ESRS standards:

Question: {test_case['question']}

Data Retrieved:
{json.dumps(all_results, indent=2, default=str)[:3000]}

Provide a formal disclosure answer that:
1. Directly addresses all aspects of the question
2. Uses specific data points from the query results
3. Provides context and explanations where needed
4. Follows ESRS disclosure standards for clarity and completeness
5. Notes any data limitations or gaps
6. Uses professional language appropriate for regulatory disclosure

Structure the answer with clear headings and bullet points where appropriate.
"""
                
                answer_response = llm.invoke([
                    SystemMessage(content="You are a sustainability reporting expert preparing CSRD-compliant disclosures."),
                    HumanMessage(content=synthesis_prompt)
                ])
                
                f.write(answer_response.content)
                f.write("\n\n---\n\n")
                
            except Exception as e:
                f.write(f"**Error in processing:** {e}\n\n---\n\n")
        
        # Write footer
        f.write("## Report Summary\n\n")
        f.write(f"This report demonstrates how the AI agent processes {len(test_questions)} different ESRS disclosure questions:\n\n")
        f.write("1. **Governance**: Executive compensation and sustainability incentives\n")
        f.write("2. **Climate**: GHG emissions reporting by scope\n")
        f.write("3. **Social**: Workforce demographics and characteristics\n")
        f.write("4. **Water**: Water usage in stressed areas\n")
        f.write("5. **Business Conduct**: Payment practices and SME relationships\n\n")
        f.write("Each question follows the complete workflow from natural language question to SQL generation to professional disclosure text.\n")
        
    print(f"\nComplete disclosure report generated: {output_file}")
    print(f"File size: {os.path.getsize(output_file):,} bytes")
    return output_file


if __name__ == "__main__":
    print("Generating Corporate Disclosure Report...")
    print("This will create a comprehensive report showing the complete workflow.")
    print("Processing 5 disclosure questions...\n")
    
    output_file = generate_disclosure_report()
    
    print(f"\nReport generation complete!")
    print(f"View the report: {output_file}")