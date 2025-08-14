"""
Corporate Disclosure AI Agent
Translates ESRS disclosure questions into SQL queries and synthesizes comprehensive answers
"""

from typing import Dict, List, Any, Optional
from langchain_community.utilities.sql_database import SQLDatabase
from langchain_core.messages import HumanMessage, SystemMessage
from langchain_openai import ChatOpenAI
from sqlalchemy import create_engine
import json
import os
from dotenv import load_dotenv

load_dotenv()


class DisclosureAgent:
    """AI Agent for corporate disclosure reporting"""
    
    def __init__(self, llm: Optional[ChatOpenAI] = None, db: Optional[SQLDatabase] = None):
        """Initialize the disclosure agent with LLM and database connections"""
        
        # Initialize LLM if not provided
        if llm is None:
            self.llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
        else:
            self.llm = llm
            
        # Initialize database connection if not provided
        if db is None:
            connection_string = f"mysql+pymysql://{os.getenv('MYSQL_USER', 'chinook_user')}:{os.getenv('MYSQL_PASSWORD', 'chinook_pass')}@{os.getenv('MYSQL_HOST', 'localhost')}:{os.getenv('MYSQL_PORT', 3306)}/corporate_data"
            engine = create_engine(connection_string)
            self.db = SQLDatabase(engine)
        else:
            self.db = db
            
        # Load the database schema context
        self.schema_context = self._get_schema_context()
        
    def _get_schema_context(self) -> str:
        """Get a summary of the database schema for the LLM"""
        schema_summary = """
        Database Schema Summary:
        - company: Company information
        - governance_bodies & governance_members: Board and committee structures
        - board_meetings: Meeting records with sustainability topics
        - employees: Workforce demographics and details
        - employee_training: Training records including sustainability training
        - workplace_incidents: Safety incidents and injuries
        - facilities: Company locations and characteristics
        - energy_consumption: Energy use by type and facility
        - ghg_emissions: Scope 1, 2, 3 emissions data
        - water_usage: Water withdrawal, discharge, consumption
        - waste_generation: Waste by type and disposal method
        - suppliers & supplier_transactions: Supply chain data
        - sustainability_targets: ESG targets and progress
        - policies: Corporate policies
        - executive_compensation: Executive pay including sustainability-linked bonuses
        - stakeholder_engagement: Stakeholder interaction records
        - financial_metrics: Financial data including sustainability investments
        - compliance_incidents: Violations and fines
        - lobbying_activities: Political engagement
        """
        return schema_summary
        
    def question_to_sql(self, question: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Translate a disclosure question into SQL query(ies)
        
        Args:
            question: The disclosure question to answer
            context: Additional context about the question (e.g., reporting period)
            
        Returns:
            Dictionary with SQL queries and reasoning
        """
        
        # Build the prompt for SQL generation
        sql_prompt = f"""
        You are an expert at translating corporate disclosure questions into SQL queries.
        
        Database Schema Context:
        {self.schema_context}
        
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
        
        response = self.llm.invoke([
            SystemMessage(content="You are an expert SQL developer for sustainability reporting."),
            HumanMessage(content=sql_prompt)
        ])
        
        # Parse the JSON response
        try:
            result = json.loads(response.content)
            return result
        except json.JSONDecodeError:
            # Fallback if response isn't valid JSON
            return {
                "queries": [{
                    "name": "Generated Query",
                    "sql": response.content,
                    "purpose": "Answer disclosure question"
                }],
                "reasoning": "Direct SQL generation"
            }
    
    def execute_queries(self, queries: List[Dict[str, str]]) -> Dict[str, Any]:
        """Execute SQL queries and return results"""
        results = {}
        
        for query in queries:
            try:
                query_result = self.db.run(query['sql'])
                results[query['name']] = {
                    'data': query_result,
                    'purpose': query['purpose'],
                    'success': True
                }
            except Exception as e:
                results[query['name']] = {
                    'error': str(e),
                    'purpose': query['purpose'],
                    'success': False
                }
                
        return results
    
    def synthesize_answer(self, question: str, query_results: Dict[str, Any]) -> str:
        """
        Synthesize a comprehensive answer from query results
        
        Args:
            question: The original disclosure question
            query_results: Results from executed SQL queries
            
        Returns:
            A comprehensive answer to the disclosure question
        """
        
        # Prepare the data summary
        data_summary = "\n\n".join([
            f"**{name}** ({result['purpose']}):\n{result.get('data', result.get('error', 'No data'))}"
            for name, result in query_results.items()
        ])
        
        synthesis_prompt = f"""
        You are preparing a corporate sustainability disclosure report.
        
        Original Question: {question}
        
        Data Retrieved:
        {data_summary}
        
        Please provide a comprehensive, professional answer that:
        1. Directly addresses the disclosure question
        2. Uses specific data points from the query results
        3. Provides context and explanation where needed
        4. Follows ESRS disclosure standards for clarity and completeness
        5. Highlights any data gaps or limitations
        6. Uses a formal, factual tone appropriate for regulatory disclosure
        
        Format the answer with clear structure and include specific metrics where available.
        """
        
        response = self.llm.invoke([
            SystemMessage(content="You are a sustainability reporting expert preparing CSRD-compliant disclosures."),
            HumanMessage(content=synthesis_prompt)
        ])
        
        return response.content
    
    def answer_disclosure_question(self, question: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """
        Complete pipeline: question → SQL → execution → synthesis
        
        Args:
            question: The disclosure question to answer
            context: Additional context
            
        Returns:
            Dictionary with queries, results, and final answer
        """
        
        # Step 1: Generate SQL queries
        sql_generation = self.question_to_sql(question, context)
        
        # Step 2: Execute queries
        query_results = self.execute_queries(sql_generation['queries'])
        
        # Step 3: Synthesize answer
        final_answer = self.synthesize_answer(question, query_results)
        
        return {
            'question': question,
            'sql_queries': sql_generation['queries'],
            'reasoning': sql_generation['reasoning'],
            'query_results': query_results,
            'answer': final_answer
        }


# Example usage
if __name__ == "__main__":
    # Initialize the agent
    agent = DisclosureAgent()
    
    # Example disclosure question
    test_question = "How are the administrative, management, and supervisory bodies informed about sustainability matters, and which matters were addressed during the reporting period?"
    
    # Get the answer
    result = agent.answer_disclosure_question(test_question)
    
    print("Question:", result['question'])
    print("\nSQL Queries Generated:")
    for query in result['sql_queries']:
        print(f"\n{query['name']}:")
        print(query['sql'])
    print("\nFinal Answer:")
    print(result['answer'])