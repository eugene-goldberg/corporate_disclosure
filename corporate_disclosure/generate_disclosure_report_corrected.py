"""
Corrected version of disclosure report generation with all SQL and interpretation fixes
Processes ALL questions from disclosure_questions.json
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


def generate_corrected_disclosure_report():
    """Generate complete disclosure report with corrected SQL queries and interpretations"""
    
    # Initialize components
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    connection_string = f"mysql+pymysql://{os.getenv('MYSQL_USER', 'chinook_user')}:{os.getenv('MYSQL_PASSWORD', 'chinook_pass')}@{os.getenv('MYSQL_HOST', 'localhost')}:{os.getenv('MYSQL_PORT', 3306)}/corporate_data"
    engine = create_engine(connection_string)
    db = SQLDatabase(engine)
    
    # Load all disclosure questions
    all_questions = load_disclosure_questions()
    
    # Get database schema
    schema = get_database_schema()
    
    # Open output file
    output_file = "corporate_disclosure_corrected_report.md"
    
    with open(output_file, 'w') as f:
        # Write header
        f.write("# Corporate Disclosure AI Agent - Complete Report (All Questions)\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("This report covers ALL questions from disclosure_questions.json\n")
        f.write("Format: Original Question → Augmented Prompt → Generated SQL → Synthesized Answer\n\n")
        f.write("---\n\n")
        
        # Process each category
        question_counter = 0
        
        for category, questions in all_questions.items():
            # Write category header
            category_title = category.replace('_', ' ').title()
            f.write(f"# {category_title}\n\n")
            
            # Process each question in the category
            for question_obj in questions:
                question_counter += 1
                question = question_obj['question']
                
                f.write(f"## {question_counter}. {question}\n\n")
                
                # 1. Original Question
                f.write("### Original Disclosure Question\n")
                f.write(f"> {question}\n\n")
                
                # 2. Augmented Prompt
                f.write("### Augmented Prompt\n")
                f.write("```\n")
                
                prompt = f"""You are an expert at translating corporate disclosure questions into SQL queries.

{schema}

Additional Context:
- Reporting year: 2024
- Company operates globally with facilities in multiple countries
- Data includes environmental, social, and governance metrics

Question: {question}

Generate SQL queries to comprehensively answer this disclosure question. Consider:
- Join multiple tables when needed
- Use aggregations (SUM, COUNT, AVG, etc.)
- Filter by year 2024 where applicable
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
                
                f.write(prompt)
                f.write("\n```\n\n")
                
                # 3. Generate SQL
                f.write("### Generated SQL Queries\n\n")
                
                try:
                    response = llm.invoke([
                        SystemMessage(content="You are an expert SQL developer for sustainability reporting. Return only valid JSON."),
                        HumanMessage(content=prompt)
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
                    
                    f.write(f"**AI Reasoning:** {sql_result.get('reasoning', 'No reasoning provided')}\n\n")
                    
                    # Execute queries and collect results
                    all_results = {}
                    
                    for j, query in enumerate(sql_result.get('queries', []), 1):
                        f.write(f"#### Query {j}: {query.get('name', 'Unnamed Query')}\n")
                        f.write(f"**Purpose:** {query.get('purpose', 'No purpose provided')}\n\n")
                        f.write("```sql\n")
                        f.write(query.get('sql', '-- No SQL provided'))
                        f.write("\n```\n\n")
                        
                        # Execute query
                        try:
                            sql_query = query.get('sql', '')
                            if sql_query and not sql_query.startswith('--'):
                                result = db.run(sql_query)
                                all_results[query.get('name', f'Query {j}')] = result
                                f.write("**Results:**\n")
                                if len(str(result)) > 1000:
                                    f.write(f"```\n{str(result)[:1000]}...\n[Truncated - {len(str(result))} total characters]\n```\n\n")
                                else:
                                    f.write(f"```\n{result}\n```\n\n")
                            else:
                                f.write("**Results:** Query not executed (no valid SQL)\n\n")
                        except Exception as e:
                            f.write(f"**Error:** {e}\n\n")
                            all_results[query.get('name', f'Query {j}')] = f"Error: {e}"
                    
                    # 4. Synthesized Answer
                    f.write("### Synthesized Answer\n\n")
                    
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
                    
                    f.write(answer_response.content)
                    f.write("\n\n---\n\n")
                    
                except Exception as e:
                    f.write(f"**Error in processing:** {e}\n\n---\n\n")
            
            f.write("\n")  # Extra space between categories
        
        # Write footer
        f.write("## Report Summary\n\n")
        f.write(f"This report processed {question_counter} disclosure questions across all ESRS categories:\n\n")
        f.write("- General Disclosures (Governance, Strategy, IRO Management, Metrics & Targets)\n")
        f.write("- Environmental (Climate Change, Pollution, Water, Biodiversity, Circular Economy)\n")
        f.write("- Social (Own Workforce, Value Chain Workers, Communities, Consumers)\n")
        f.write("- Governance (Business Conduct)\n\n")
        f.write("Each question followed the complete workflow: Question → Augmented Prompt → SQL Generation → Execution → Synthesis\n")
        
    print(f"\nComplete disclosure report generated: {output_file}")
    print(f"Total questions processed: {question_counter}")
    print(f"File size: {os.path.getsize(output_file):,} bytes")
    return output_file


if __name__ == "__main__":
    print("Generating Comprehensive Corporate Disclosure Report...")
    print("This will process ALL questions from disclosure_questions.json")
    print("Please wait, this may take several minutes...\n")
    
    output_file = generate_corrected_disclosure_report()
    
    print(f"\nReport generation complete!")
    print(f"View the report: {output_file}")