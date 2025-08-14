"""
Quick test of key questions to identify and fix data gaps
"""

import json
import requests
import time
from datetime import datetime

API_URL = "http://localhost:8001"

# Key questions that showed data gaps
key_questions = [
    {
        "category": "general_disclosures_governance",
        "question": "How is sustainability-related performance integrated into incentive schemes for administrative, management, and supervisory bodies? [2]"
    },
    {
        "category": "general_disclosures_strategy", 
        "question": "How are the interests and views of stakeholders taken into account in the company's strategy?"
    },
    {
        "category": "general_disclosures_metrics_and_targets",
        "question": "What measurable, time-bound targets have been set to track the effectiveness of sustainability policies and actions?"
    },
    {
        "category": "environmental_climate_change",
        "question": "What targets have been set related to climate change mitigation and adaptation, and what is the progress towards achieving these targets?"
    }
]

def test_question(question: str) -> dict:
    """Test a single question"""
    try:
        response = requests.post(
            f"{API_URL}/answer",
            json={
                "question": question,
                "year": 2024,
                "include_sql": True,
                "include_reasoning": True,
                "include_raw_results": True
            },
            timeout=60
        )
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def analyze_gaps(response: dict) -> list:
    """Analyze response for specific gaps"""
    gaps = []
    answer = response.get('answer', '').lower()
    
    # Check for specific missing data indicators
    if "stakeholder" in answer and ("data not available" in answer or "unable to retrieve" in answer):
        gaps.append("stakeholder_engagement_data")
    
    if "target" in answer and ("lack" in answer or "no specific" in answer):
        gaps.append("sustainability_targets")
    
    if "incentive" in answer and "lack of specific data" in answer:
        gaps.append("executive_compensation_details")
    
    # Check query results
    query_results = response.get('query_results', {})
    for query_name, result in query_results.items():
        if isinstance(result, dict):
            if not result.get('success', True):
                gaps.append(f"query_failed:{query_name}")
            elif result.get('data') == '[]':
                gaps.append(f"empty_data:{query_name}")
    
    return gaps

def main():
    print("Testing key questions for data gaps...\n")
    
    all_gaps = set()
    
    for q in key_questions:
        print(f"\nTesting: {q['question'][:80]}...")
        response = test_question(q['question'])
        
        if 'error' in response:
            print(f"  ❌ Error: {response['error']}")
            continue
        
        gaps = analyze_gaps(response)
        all_gaps.update(gaps)
        
        if gaps:
            print(f"  ⚠️  Found gaps: {', '.join(gaps)}")
        else:
            print(f"  ✓  No obvious gaps")
        
        # Show part of answer for context
        answer = response.get('answer', '')
        if answer:
            preview = answer[:200].replace('\n', ' ')
            print(f"  Preview: {preview}...")
    
    print(f"\n\n{'='*60}")
    print("SUMMARY OF DATA GAPS")
    print(f"{'='*60}")
    
    # Categorize gaps
    needs_data = {
        "stakeholder_engagement": False,
        "sustainability_targets": False,
        "executive_compensation": False,
        "training_programs": False
    }
    
    for gap in all_gaps:
        print(f"- {gap}")
        if "stakeholder" in gap:
            needs_data["stakeholder_engagement"] = True
        if "target" in gap:
            needs_data["sustainability_targets"] = True
        if "compensation" in gap or "incentive" in gap:
            needs_data["executive_compensation"] = True
        if "training" in gap:
            needs_data["training_programs"] = True
    
    print(f"\n\nData tables needing population:")
    for category, needed in needs_data.items():
        if needed:
            print(f"  ✓ {category}")
    
    return needs_data

if __name__ == "__main__":
    needs_data = main()
    
    # Save results
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    with open(f"quick_gaps_analysis_{timestamp}.json", 'w') as f:
        json.dump({
            "timestamp": datetime.now().isoformat(),
            "needs_data": needs_data,
            "tested_questions": key_questions
        }, f, indent=2)