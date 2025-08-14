"""
Test the Disclosure Agent with sample questions
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from corporate_disclosure.agents.disclosure_agent import DisclosureAgent
from dotenv import load_dotenv

load_dotenv()


def test_governance_question():
    """Test a governance-related disclosure question"""
    agent = DisclosureAgent()
    
    question = "How is sustainability-related performance integrated into incentive schemes for members of the administrative, management, and supervisory bodies?"
    
    print("\n" + "="*80)
    print("GOVERNANCE QUESTION TEST")
    print("="*80)
    print(f"Question: {question}\n")
    
    result = agent.answer_disclosure_question(question)
    
    print("Generated SQL Queries:")
    for query in result['sql_queries']:
        print(f"\n{query['name']}:")
        print(query['sql'][:300] + "..." if len(query['sql']) > 300 else query['sql'])
    
    print("\nFinal Answer:")
    print(result['answer'])


def test_climate_question():
    """Test a climate-related disclosure question"""
    agent = DisclosureAgent()
    
    question = "What are the gross Scope 1, Scope 2, and Scope 3 greenhouse gas (GHG) emissions in metric tonnes of CO2 equivalent?"
    
    print("\n" + "="*80)
    print("CLIMATE QUESTION TEST")
    print("="*80)
    print(f"Question: {question}\n")
    
    result = agent.answer_disclosure_question(question)
    
    print("Generated SQL Queries:")
    for query in result['sql_queries']:
        print(f"\n{query['name']}:")
        print(query['sql'])
    
    print("\nFinal Answer:")
    print(result['answer'])


def test_social_question():
    """Test a social/workforce-related disclosure question"""
    agent = DisclosureAgent()
    
    question = "Provide key characteristics of the own workforce, including a breakdown of employees by gender, region, and contract type."
    
    print("\n" + "="*80)
    print("SOCIAL QUESTION TEST")
    print("="*80)
    print(f"Question: {question}\n")
    
    result = agent.answer_disclosure_question(question)
    
    print("Generated SQL Queries:")
    for query in result['sql_queries']:
        print(f"\n{query['name']}:")
        print(query['sql'])
    
    print("\nFinal Answer:")
    print(result['answer'])


if __name__ == "__main__":
    print("CORPORATE DISCLOSURE AGENT TEST")
    print("="*80)
    
    # Test different types of questions
    test_governance_question()
    test_climate_question()
    test_social_question()
    
    print("\n" + "="*80)
    print("TEST COMPLETED")