"""
Script to test all disclosure questions and identify data gaps
Runs each question through the API and analyzes responses for missing data
"""

import json
import requests
import time
from datetime import datetime
from typing import Dict, List, Any
import re

# API configuration
API_URL = "http://localhost:8001"

def load_disclosure_questions():
    """Load all questions from disclosure_questions.json"""
    with open('disclosure_questions.json', 'r') as f:
        return json.load(f)

def test_question(question: str) -> Dict[str, Any]:
    """Test a single question through the API"""
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
        return {
            "error": str(e),
            "question": question
        }

def analyze_response_for_gaps(response: Dict[str, Any]) -> List[str]:
    """Analyze response for indicators of missing data"""
    gaps = []
    
    # Common patterns indicating missing data
    missing_data_patterns = [
        # Direct statements
        r"data.*not.*available",
        r"data.*not.*retrieved",
        r"unable.*retrieve",
        r"no.*data.*found",
        r"data.*retrieval.*unsuccessful",
        r"specific.*data.*could not be.*retrieved",
        r"absence of.*data",
        r"lack.*data",
        r"data.*limitations",
        r"data.*gaps",
        r"not.*captured",
        r"could not.*extract",
        r"failed.*retrieve",
        r"error.*retrieving",
        r"database.*error",
        r"operational.*error",
        
        # Placeholder patterns
        r"\[Insert.*\]",
        r"\[.*data.*\]",
        r"XX+",
        r"placeholder",
        
        # Zero or null results
        r"0.*results",
        r"no.*results",
        r"empty.*results",
        r"null.*value",
        
        # Specific data types often missing
        r"training.*data.*not",
        r"engagement.*data.*not",
        r"stakeholder.*data.*not",
        r"policy.*data.*not",
        r"target.*data.*not",
        r"biodiversity.*data.*not",
        r"lobbying.*data.*not",
        r"community.*data.*not",
        r"incident.*data.*not"
    ]
    
    # Check the answer text
    answer_text = response.get('answer', '').lower()
    
    for pattern in missing_data_patterns:
        if re.search(pattern, answer_text):
            # Extract context around the match
            matches = re.finditer(pattern, answer_text)
            for match in matches:
                start = max(0, match.start() - 50)
                end = min(len(answer_text), match.end() + 50)
                context = answer_text[start:end].strip()
                gaps.append(f"Pattern '{pattern}' found: ...{context}...")
    
    # Check query results for errors or empty results
    query_results = response.get('query_results', {})
    for query_name, result in query_results.items():
        if isinstance(result, dict):
            if not result.get('success', True):
                gaps.append(f"Query '{query_name}' failed: {result.get('error', 'Unknown error')}")
            elif result.get('data') == '[]' or result.get('data') == '':
                gaps.append(f"Query '{query_name}' returned no data")
    
    # Check for specific indicators
    if "sustainability targets" in answer_text and "no.*target" in answer_text:
        gaps.append("Missing sustainability targets data")
    
    if "stakeholder engagement" in answer_text and ("no.*engagement" in answer_text or "data.*not.*available" in answer_text):
        gaps.append("Missing stakeholder engagement data")
    
    return gaps

def main():
    """Main function to test all questions"""
    print("Loading disclosure questions...")
    all_questions = load_disclosure_questions()
    
    results = []
    data_gaps_summary = {}
    
    total_questions = sum(len(questions) for questions in all_questions.values())
    question_count = 0
    
    print(f"\nTesting {total_questions} questions...\n")
    
    # Process each category
    for category, questions in all_questions.items():
        print(f"\n{'='*60}")
        print(f"Category: {category}")
        print(f"{'='*60}")
        
        category_gaps = []
        
        for question_obj in questions:
            question_count += 1
            question_text = question_obj['question']
            
            print(f"\n[{question_count}/{total_questions}] Testing: {question_text[:80]}...")
            
            # Test the question
            start_time = time.time()
            response = test_question(question_text)
            elapsed_time = time.time() - start_time
            
            # Analyze for gaps
            gaps = analyze_response_for_gaps(response)
            
            result = {
                "category": category,
                "question": question_text,
                "processing_time": elapsed_time,
                "has_gaps": len(gaps) > 0,
                "gaps": gaps,
                "error": response.get('error')
            }
            
            results.append(result)
            
            if gaps:
                category_gaps.extend(gaps)
                print(f"  ⚠️  Found {len(gaps)} data gaps")
                for gap in gaps[:2]:  # Show first 2 gaps
                    print(f"     - {gap[:100]}...")
            else:
                print(f"  ✓  No data gaps detected")
            
            # Rate limiting
            time.sleep(1)
        
        if category_gaps:
            data_gaps_summary[category] = category_gaps
    
    # Generate report
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_file = f"data_gaps_analysis_{timestamp}.json"
    
    report = {
        "timestamp": datetime.now().isoformat(),
        "total_questions": total_questions,
        "questions_with_gaps": sum(1 for r in results if r['has_gaps']),
        "categories_with_gaps": list(data_gaps_summary.keys()),
        "detailed_results": results,
        "gaps_by_category": data_gaps_summary
    }
    
    with open(report_file, 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"\n{'='*60}")
    print("SUMMARY")
    print(f"{'='*60}")
    print(f"Total questions tested: {total_questions}")
    print(f"Questions with data gaps: {report['questions_with_gaps']}")
    print(f"Categories with gaps: {len(data_gaps_summary)}")
    print(f"\nDetailed report saved to: {report_file}")
    
    # Print most common gap types
    all_gaps = []
    for gaps in data_gaps_summary.values():
        all_gaps.extend(gaps)
    
    print(f"\nMost common data gaps:")
    gap_types = {}
    for gap in all_gaps:
        # Extract key terms
        if "stakeholder" in gap.lower():
            gap_types["Stakeholder data"] = gap_types.get("Stakeholder data", 0) + 1
        elif "training" in gap.lower():
            gap_types["Training data"] = gap_types.get("Training data", 0) + 1
        elif "target" in gap.lower():
            gap_types["Targets data"] = gap_types.get("Targets data", 0) + 1
        elif "policy" in gap.lower() or "policies" in gap.lower():
            gap_types["Policy data"] = gap_types.get("Policy data", 0) + 1
        elif "biodiversity" in gap.lower():
            gap_types["Biodiversity data"] = gap_types.get("Biodiversity data", 0) + 1
        elif "community" in gap.lower():
            gap_types["Community data"] = gap_types.get("Community data", 0) + 1
        elif "lobbying" in gap.lower():
            gap_types["Lobbying data"] = gap_types.get("Lobbying data", 0) + 1
    
    for gap_type, count in sorted(gap_types.items(), key=lambda x: x[1], reverse=True):
        print(f"  - {gap_type}: {count} occurrences")

if __name__ == "__main__":
    main()