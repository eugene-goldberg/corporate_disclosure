"""
Example client for the Corporate Disclosure API
Demonstrates how to use the API endpoints
"""

import requests
import json
from typing import Dict, Any

# API base URL
BASE_URL = "http://localhost:8000"

def check_health():
    """Check if the API is healthy"""
    response = requests.get(f"{BASE_URL}/health")
    return response.json()

def get_all_questions():
    """Get all available disclosure questions"""
    response = requests.get(f"{BASE_URL}/questions")
    return response.json()

def get_categories():
    """Get list of all categories"""
    response = requests.get(f"{BASE_URL}/categories")
    return response.json()

def get_questions_by_category(category: str):
    """Get questions for a specific category"""
    response = requests.get(f"{BASE_URL}/questions/{category}")
    return response.json()

def answer_question(question: str, include_sql: bool = True, include_reasoning: bool = True):
    """Answer a specific disclosure question"""
    payload = {
        "question": question,
        "include_sql": include_sql,
        "include_reasoning": include_reasoning,
        "context": {"year": 2024}
    }
    response = requests.post(f"{BASE_URL}/answer", json=payload)
    return response.json()

def answer_batch_questions(questions: list):
    """Answer multiple questions in one request"""
    payload = [
        {
            "question": q,
            "include_sql": True,
            "include_reasoning": True,
            "context": {"year": 2024}
        }
        for q in questions
    ]
    response = requests.post(f"{BASE_URL}/answer/batch", json=payload)
    return response.json()

def main():
    """Example usage of the API"""
    print("Corporate Disclosure API Client Example")
    print("=" * 50)
    
    # 1. Check API health
    print("\n1. Checking API health...")
    health = check_health()
    print(f"   Status: {health['status']}")
    print(f"   Database connected: {health['database_connected']}")
    
    # 2. Get categories
    print("\n2. Getting categories...")
    categories = get_categories()
    print(f"   Found {len(categories)} categories:")
    for cat in categories[:5]:  # Show first 5
        print(f"   - {cat}")
    
    # 3. Get questions from a specific category
    print("\n3. Getting questions from 'environmental_climate_change'...")
    category_data = get_questions_by_category("environmental_climate_change")
    print(f"   Category: {category_data['category']}")
    print(f"   Number of questions: {category_data['count']}")
    print(f"   First question: {category_data['questions'][0]['question']}")
    
    # 4. Answer a specific question
    print("\n4. Answering a disclosure question...")
    test_question = "What are the gross Scope 1, Scope 2, and Scope 3 greenhouse gas (GHG) emissions in metric tonnes of CO2 equivalent?"
    
    answer_response = answer_question(test_question)
    print(f"   Question: {answer_response['question'][:100]}...")
    print(f"   Processing time: {answer_response['processing_time']:.2f} seconds")
    print(f"   Answer preview: {answer_response['answer'][:200]}...")
    
    if answer_response.get('sql_queries'):
        print(f"   Number of SQL queries generated: {len(answer_response['sql_queries'])}")
    
    # 5. Batch request example
    print("\n5. Answering multiple questions...")
    batch_questions = [
        "How is sustainability-related performance integrated into incentive schemes?",
        "What policies have been adopted to manage material sustainability matters?"
    ]
    
    batch_responses = answer_batch_questions(batch_questions)
    print(f"   Processed {len(batch_responses)} questions")
    for i, resp in enumerate(batch_responses):
        print(f"   Question {i+1}: {resp['question'][:80]}...")
        print(f"   Processing time: {resp.get('processing_time', 0):.2f} seconds")

if __name__ == "__main__":
    # Make sure the API server is running before executing this
    try:
        main()
    except requests.ConnectionError:
        print("Error: Could not connect to API server. Make sure it's running on http://localhost:8000")
    except Exception as e:
        print(f"Error: {e}")