"""
Add more comprehensive policies to the database
"""

import pymysql
from datetime import datetime

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='rootpassword',
        database='corporate_data',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )

def add_policies():
    connection = get_connection()
    
    try:
        with connection.cursor() as cursor:
            # First check what policy categories exist
            cursor.execute("SELECT DISTINCT policy_category FROM policies")
            existing_categories = [row['policy_category'] for row in cursor.fetchall()]
            print(f"Existing policy categories: {existing_categories}")
            
            # Get max policy_id
            cursor.execute("SELECT COALESCE(MAX(policy_id), 0) as max_id FROM policies")
            max_id = cursor.fetchone()['max_id']
            
            # Add comprehensive policies for material sustainability matters
            new_policies = [
                # Environmental policies
                (max_id + 1, 'Climate Action Policy', 'Environmental', '2023-01-01', '2024-01-01',
                 'Comprehensive climate action policy outlining our commitment to achieving net-zero emissions by 2040. Includes targets for renewable energy transition, energy efficiency improvements, and supply chain decarbonization. Requires all business units to develop climate action plans aligned with science-based targets.',
                 True),
                
                (max_id + 2, 'Water Stewardship Policy', 'Environmental', '2023-03-01', '2024-03-01',
                 'Policy for responsible water management across all operations, with special focus on water-stressed regions. Mandates water risk assessments, efficiency targets, and collaboration with local communities on watershed protection. Target: 40% reduction in water consumption by 2030.',
                 True),
                
                (max_id + 3, 'Circular Economy Policy', 'Environmental', '2023-05-01', '2024-05-01',
                 'Framework for transitioning to circular business model. Requires product design for recyclability, waste reduction targets, and take-back programs. Mandates 75% recycled content in packaging by 2025 and zero waste to landfill by 2025.',
                 True),
                
                (max_id + 4, 'Deforestation-Free Supply Chain Policy', 'Environmental', '2023-07-01', '2024-07-01',
                 'Zero deforestation commitment across all commodity supply chains. Requires supplier certification, satellite monitoring of high-risk areas, and remediation plans for any violations. Applies to palm oil, soy, timber, and cattle products.',
                 True),
                
                # Social policies
                (max_id + 5, 'Human Rights Due Diligence Policy', 'Social', '2023-01-01', '2024-01-01',
                 'Comprehensive human rights policy aligned with UN Guiding Principles. Requires human rights impact assessments, grievance mechanisms, and remedy processes. Prohibits child labor, forced labor, and discrimination throughout value chain.',
                 True),
                
                (max_id + 6, 'Fair Labor Practices Policy', 'Social', '2023-02-01', '2024-02-01',
                 'Ensures fair wages, safe working conditions, and freedom of association. Mandates living wage assessments, maximum working hours, and collective bargaining rights. Includes whistleblower protection and anonymous reporting channels.',
                 True),
                
                (max_id + 7, 'Community Engagement Policy', 'Social', '2023-04-01', '2024-04-01',
                 'Framework for meaningful engagement with local communities. Requires social impact assessments, benefit-sharing agreements, and local hiring targets. Establishes community development fund of 1% of local revenue.',
                 False),
                
                (max_id + 8, 'Product Safety and Quality Policy', 'Social', '2023-06-01', '2024-06-01',
                 'Ensures highest standards of product safety and quality. Mandates rigorous testing protocols, transparent labeling, and rapid response to safety concerns. Zero tolerance for compromising customer health and safety.',
                 True),
                
                # Governance policies
                (max_id + 9, 'Business Ethics and Anti-Corruption Policy', 'Governance', '2023-01-01', '2024-01-01',
                 'Zero tolerance for corruption, bribery, and unethical business practices. Requires annual ethics training, third-party due diligence, and transparent political contributions disclosure. Includes protection for whistleblowers.',
                 True),
                
                (max_id + 10, 'Responsible AI and Data Ethics Policy', 'Governance', '2023-08-01', '2024-08-01',
                 'Governs ethical use of AI and data. Ensures privacy protection, algorithmic fairness, and transparency. Prohibits discriminatory AI applications and requires human oversight for high-stakes decisions.',
                 False),
                
                (max_id + 11, 'Sustainable Finance Policy', 'Governance', '2023-09-01', '2024-09-01',
                 'Integrates ESG factors into financial decision-making. Requires sustainability-linked financing, green bond frameworks, and TCFD-aligned climate risk disclosure. Sets minimum ESG criteria for investments.',
                 False),
                
                (max_id + 12, 'Supply Chain Transparency Policy', 'Governance', '2023-10-01', '2024-10-01',
                 'Ensures full visibility and accountability across supply chain. Requires supplier mapping, regular audits, and public disclosure of key suppliers. Mandates corrective action plans for non-compliance.',
                 True),
                
                # Cross-cutting policies
                (max_id + 13, 'Integrated Sustainability Policy', 'Environmental', '2024-01-01', '2024-12-01',
                 'Overarching policy integrating all sustainability commitments. Aligns with UN SDGs, Paris Agreement, and CSRD requirements. Establishes governance structure, accountability mechanisms, and annual reporting requirements.',
                 True),
                
                (max_id + 14, 'Stakeholder Engagement Policy', 'Social', '2024-01-01', '2024-12-01',
                 'Systematic approach to stakeholder identification, engagement, and response. Requires materiality assessments, regular dialogue, and integration of stakeholder feedback into strategy. Publishes annual stakeholder engagement report.',
                 False),
                
                (max_id + 15, 'Innovation for Sustainability Policy', 'Governance', '2024-01-01', '2024-12-01',
                 'Drives innovation towards sustainability solutions. Allocates 5% of R&D budget to sustainable innovation, establishes internal carbon pricing for project evaluation, and rewards sustainable innovation in performance management.',
                 False)
            ]
            
            # Insert new policies
            sql = """INSERT INTO policies 
                     (policy_id, policy_name, policy_category, effective_date, last_reviewed, policy_text, applies_to_suppliers) 
                     VALUES (%s, %s, %s, %s, %s, %s, %s)
                     ON DUPLICATE KEY UPDATE last_reviewed = VALUES(last_reviewed)"""
            
            inserted = 0
            for policy in new_policies:
                try:
                    cursor.execute(sql, policy)
                    if cursor.rowcount > 0:
                        inserted += 1
                except pymysql.err.IntegrityError:
                    print(f"Policy '{policy[1]}' already exists, skipping...")
            
            connection.commit()
            print(f"\n✓ Successfully added {inserted} new policies")
            
            # Verify the policies
            cursor.execute("""
                SELECT policy_category, COUNT(*) as count 
                FROM policies 
                GROUP BY policy_category
                ORDER BY count DESC
            """)
            
            print("\nPolicy count by category:")
            for row in cursor.fetchall():
                print(f"  {row['policy_category']}: {row['count']} policies")
            
            # Check policies that apply to suppliers
            cursor.execute("""
                SELECT COUNT(*) as supplier_policies 
                FROM policies 
                WHERE applies_to_suppliers = TRUE
            """)
            result = cursor.fetchone()
            print(f"\nPolicies applying to suppliers: {result['supplier_policies']}")
            
    except Exception as e:
        print(f"Error: {e}")
        connection.rollback()
    finally:
        connection.close()

if __name__ == "__main__":
    print("Adding comprehensive sustainability policies...")
    print("="*60)
    add_policies()