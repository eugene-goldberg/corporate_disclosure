"""
Demonstration of how ESRS disclosure questions map to the corporate database schema
"""

import json
from corporate_disclosure.agents.disclosure_agent import DisclosureAgent
from dotenv import load_dotenv

load_dotenv()


def demonstrate_question_mappings():
    """Show how different types of disclosure questions map to SQL queries"""
    
    # Initialize the agent
    agent = DisclosureAgent()
    
    # Sample questions from different ESRS categories
    test_questions = [
        {
            "category": "Governance (ESRS 2 GOV-1)",
            "question": "How are the administrative, management, and supervisory bodies informed about sustainability matters, and which matters were addressed during the reporting period?"
        },
        {
            "category": "Climate (ESRS E1)",
            "question": "What are the gross Scope 1, Scope 2, and Scope 3 greenhouse gas (GHG) emissions in metric tonnes of CO2 equivalent?"
        },
        {
            "category": "Energy (ESRS E1)",
            "question": "What is the company's total energy consumption and energy mix, broken down by renewable and non-renewable sources?"
        },
        {
            "category": "Social - Own Workforce (ESRS S1)",
            "question": "Provide key characteristics of the own workforce, including a breakdown of employees by gender, region, and contract type."
        },
        {
            "category": "Social - Diversity (ESRS S1)",
            "question": "Disclose information on health and safety, diversity, the gender pay gap, and training and skills development."
        },
        {
            "category": "Water (ESRS E3)",
            "question": "Disclose information on water consumption, withdrawal, and discharge, particularly in areas of high water stress."
        },
        {
            "category": "Business Conduct (ESRS G1)",
            "question": "Disclose information on payment practices, particularly regarding the average time to pay invoices and late payments to small and medium-sized enterprises (SMEs)."
        }
    ]
    
    # Process each question and show the mapping
    for test_case in test_questions:
        print("\n" + "="*80)
        print(f"CATEGORY: {test_case['category']}")
        print(f"QUESTION: {test_case['question']}")
        print("="*80)
        
        # Generate SQL
        sql_result = agent.question_to_sql(test_case['question'])
        
        print("\nAPPROACH:", sql_result['reasoning'])
        print("\nGENERATED SQL QUERIES:")
        
        for i, query in enumerate(sql_result['queries'], 1):
            print(f"\n{i}. {query['name']} - {query['purpose']}")
            print("SQL:")
            print(query['sql'])
            
        # Execute and get results
        query_results = agent.execute_queries(sql_result['queries'])
        
        print("\nQUERY RESULTS:")
        for name, result in query_results.items():
            if result['success']:
                print(f"\n{name}:")
                print(f"Data retrieved: {result['data'][:200]}..." if len(str(result['data'])) > 200 else result['data'])
            else:
                print(f"\n{name}: ERROR - {result['error']}")
        
        # Get synthesized answer
        answer = agent.synthesize_answer(test_case['question'], query_results)
        print("\nSYNTHESIZED ANSWER:")
        print(answer[:500] + "..." if len(answer) > 500 else answer)
        print("\n" + "-"*80)


def show_schema_mapping():
    """Show how ESRS topics map to database tables"""
    
    mapping = {
        "ESRS 2 - General Disclosures": {
            "Governance": ["governance_bodies", "governance_members", "board_meetings", "executive_compensation"],
            "Strategy": ["company", "sustainability_targets", "financial_metrics"],
            "Impact/Risk Management": ["policies", "compliance_incidents", "stakeholder_engagement"],
            "Metrics & Targets": ["sustainability_targets"]
        },
        "ESRS E1 - Climate Change": {
            "Emissions": ["ghg_emissions", "facilities"],
            "Energy": ["energy_consumption", "facilities"],
            "Targets": ["sustainability_targets"],
            "Financial Effects": ["financial_metrics"]
        },
        "ESRS E2 - Pollution": {
            "Emissions": ["ghg_emissions"],
            "Waste": ["waste_generation"],
            "Incidents": ["compliance_incidents"]
        },
        "ESRS E3 - Water": {
            "Water Use": ["water_usage", "facilities"],
            "Water Stress Areas": ["facilities"]
        },
        "ESRS E5 - Circular Economy": {
            "Materials": ["materials_sourced", "suppliers"],
            "Waste": ["waste_generation"]
        },
        "ESRS S1 - Own Workforce": {
            "Demographics": ["employees"],
            "Safety": ["workplace_incidents"],
            "Training": ["employee_training"],
            "Compensation": ["employees", "executive_compensation"]
        },
        "ESRS S2 - Value Chain Workers": {
            "Suppliers": ["suppliers", "supplier_transactions"]
        },
        "ESRS G1 - Business Conduct": {
            "Policies": ["policies"],
            "Compliance": ["compliance_incidents"],
            "Lobbying": ["lobbying_activities"],
            "Payments": ["supplier_transactions", "suppliers"]
        }
    }
    
    print("\nESRS STANDARDS TO DATABASE SCHEMA MAPPING")
    print("="*80)
    
    for standard, topics in mapping.items():
        print(f"\n{standard}")
        for topic, tables in topics.items():
            print(f"  {topic}: {', '.join(tables)}")


if __name__ == "__main__":
    print("CORPORATE DISCLOSURE QUESTION MAPPING DEMONSTRATION")
    print("="*80)
    
    # Show the schema mapping
    show_schema_mapping()
    
    # Demonstrate question processing
    print("\n\nQUESTION PROCESSING EXAMPLES")
    demonstrate_question_mappings()