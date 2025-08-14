"""
Check existing data and populate only what's missing
"""

import pymysql
from datetime import datetime, timedelta
import random

def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='rootpassword',
        database='corporate_data',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )

def check_and_populate():
    connection = get_connection()
    
    try:
        with connection.cursor() as cursor:
            # Check stakeholder_engagement
            cursor.execute("SELECT COUNT(*) as count FROM stakeholder_engagement WHERE YEAR(engagement_date) = 2024")
            result = cursor.fetchone()
            if result['count'] < 5:
                print("Adding more stakeholder engagement records for 2024...")
                sql = """INSERT INTO stakeholder_engagement 
                         (stakeholder_group, engagement_date, engagement_method, topics_discussed, outcomes, participants) 
                         VALUES (%s, %s, %s, %s, %s, %s)"""
                
                new_engagements = [
                    ('Employees', '2024-11-15', 'Workshop', 
                     'Climate action plans, green commuting, energy saving', 
                     'Launched green commute program, 30% participation', 180),
                    ('Investors', '2024-11-20', 'Meeting', 
                     'Q3 sustainability performance, climate targets, TCFD', 
                     'Positive feedback, enhanced disclosure commitment', 250),
                    ('Communities', '2024-12-05', 'Consultation', 
                     'Factory expansion, environmental impact, employment', 
                     'Environmental monitoring agreement, 100 new jobs', 120),
                    ('Customers', '2024-12-10', 'Survey', 
                     'Product sustainability, packaging reduction, carbon footprint', 
                     'New eco-product line launch, 50% packaging reduction', 2500),
                    ('NGOs', '2024-12-15', 'Meeting', 
                     'Biodiversity, ocean plastic, reforestation', 
                     'Signed MOU, $1M conservation fund', 15)
                ]
                
                for engagement in new_engagements:
                    cursor.execute(sql, engagement)
                connection.commit()
                print(f"✓ Added {len(new_engagements)} stakeholder engagement records")
            
            # Check sustainability_targets - need more comprehensive targets
            cursor.execute("SELECT COUNT(*) as count FROM sustainability_targets WHERE target_year >= 2024")
            result = cursor.fetchone()
            if result['count'] < 15:
                print("Adding comprehensive sustainability targets...")
                
                # First, get the max target_id
                cursor.execute("SELECT COALESCE(MAX(target_id), 0) as max_id FROM sustainability_targets")
                max_id = cursor.fetchone()['max_id']
                
                sql = """INSERT INTO sustainability_targets 
                         (target_id, target_category, target_name, target_description, 
                          baseline_year, baseline_value, target_year, target_value, 
                          unit_of_measure, current_value, last_updated) 
                         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                
                new_targets = [
                    (max_id + 1, 'Climate', 'Science-Based Target', 
                     'Reduce absolute Scope 1, 2 and 3 GHG emissions 46% by 2030 from 2020 base year', 
                     2020, 750000, 2030, 405000, 'tCO2e', 650000, '2024-12-15'),
                    
                    (max_id + 2, 'Climate', 'Net Zero Operations', 
                     'Achieve net-zero emissions across operations', 
                     2020, 100000, 2040, 0, 'tCO2e', 75000, '2024-12-15'),
                    
                    (max_id + 3, 'Water', 'Water Positive', 
                     'Become water positive in water-stressed regions', 
                     2020, 500, 2030, 200, 'megaliters net positive', 300, '2024-12-15'),
                    
                    (max_id + 4, 'Social', 'Community Investment', 
                     'Invest 1% of annual profits in community programs', 
                     2020, 0.5, 2025, 1.0, 'percentage of profit', 0.75, '2024-12-15'),
                    
                    (max_id + 5, 'Social', 'Supplier Diversity', 
                     'Source 15% from diverse suppliers (women/minority-owned)', 
                     2020, 5, 2025, 15, 'percentage', 9, '2024-12-15'),
                    
                    (max_id + 6, 'Governance', 'ESG-linked Compensation', 
                     '50% of executive compensation linked to ESG targets', 
                     2020, 20, 2025, 50, 'percentage', 35, '2024-12-15'),
                    
                    (max_id + 7, 'Biodiversity', 'Protected Areas', 
                     'Zero operations near protected areas or establish offset programs', 
                     2020, 3, 2025, 0, 'facilities near protected', 1, '2024-12-15'),
                    
                    (max_id + 8, 'Governance', 'R&D Investment', 
                     'Invest 5% of revenue in sustainable innovation R&D', 
                     2020, 2, 2025, 5, 'percentage of revenue', 3.2, '2024-12-15')
                ]
                
                for target in new_targets:
                    try:
                        cursor.execute(sql, target)
                    except pymysql.err.IntegrityError:
                        print(f"  Target {target[2]} already exists, skipping...")
                connection.commit()
                print(f"✓ Added sustainability targets")
            
            # Check community_projects
            cursor.execute("SELECT COUNT(*) as count FROM community_projects WHERE YEAR(start_date) = 2024")
            result = cursor.fetchone()
            if result['count'] < 5:
                print("Adding more community projects...")
                
                # Get max project_id
                cursor.execute("SELECT COALESCE(MAX(project_id), 0) as max_id FROM community_projects")
                max_id = cursor.fetchone()['max_id']
                
                sql = """INSERT INTO community_projects 
                         (project_id, project_name, location, start_date, end_date, 
                          investment_usd, beneficiaries, project_type, description) 
                         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"""
                
                new_projects = [
                    (max_id + 1, 'Green Schools Initiative', 'Bangladesh', 
                     '2024-01-15', '2025-01-14', 350000, 4000, 'Education', 
                     'Installing renewable energy and water recycling systems in 15 schools'),
                    
                    (max_id + 2, 'Women Entrepreneurship Program', 'Nigeria', 
                     '2024-03-01', '2025-02-28', 280000, 500, 'Economic Development', 
                     'Microfinance and business training for women entrepreneurs'),
                    
                    (max_id + 3, 'Coral Reef Restoration', 'Australia', 
                     '2024-04-01', '2026-03-31', 900000, 50000, 'Environment', 
                     'Restoring damaged coral reefs and marine biodiversity'),
                    
                    (max_id + 4, 'Rural Healthcare Access', 'Peru', 
                     '2024-06-01', '2025-05-31', 420000, 6000, 'Health', 
                     'Mobile health clinics and telemedicine for remote communities'),
                    
                    (max_id + 5, 'Urban Forest Project', 'China', 
                     '2024-08-01', '2025-07-31', 650000, 25000, 'Environment', 
                     'Creating urban green spaces and air quality improvement')
                ]
                
                for project in new_projects:
                    try:
                        cursor.execute(sql, project)
                    except pymysql.err.IntegrityError:
                        print(f"  Project {project[1]} already exists, skipping...")
                connection.commit()
                print(f"✓ Added community projects")
            
            # Update executive compensation descriptions
            print("Updating executive compensation KPI descriptions...")
            cursor.execute("""
                UPDATE executive_compensation 
                SET sustainability_kpi_description = 
                    CASE 
                        WHEN member_id % 5 = 0 THEN 'Achievement of science-based emissions targets and renewable energy goals'
                        WHEN member_id % 5 = 1 THEN 'Progress on diversity, equity & inclusion targets and employee wellbeing'
                        WHEN member_id % 5 = 2 THEN 'Implementation of circular economy initiatives and waste reduction'
                        WHEN member_id % 5 = 3 THEN 'Water stewardship goals and biodiversity protection measures'
                        WHEN member_id % 5 = 4 THEN 'Supply chain sustainability and responsible sourcing targets'
                    END
                WHERE sustainability_linked_bonus_usd > 0 
                AND (sustainability_kpi_description IS NULL OR sustainability_kpi_description = '')
            """)
            affected = cursor.rowcount
            connection.commit()
            if affected > 0:
                print(f"✓ Updated {affected} executive compensation KPI descriptions")
            
            # Final verification
            print(f"\n{'='*60}")
            print("Final Data Verification:")
            print(f"{'='*60}")
            
            tables = [
                'stakeholder_engagement',
                'sustainability_targets', 
                'community_projects',
                'executive_compensation',
                'policies',
                'lobbying_activities'
            ]
            
            for table in tables:
                cursor.execute(f"SELECT COUNT(*) as count FROM {table}")
                count = cursor.fetchone()['count']
                
                # Special check for 2024 data
                if table in ['stakeholder_engagement', 'community_projects']:
                    if 'date' in table:
                        date_field = 'engagement_date' if table == 'stakeholder_engagement' else 'start_date'
                        cursor.execute(f"SELECT COUNT(*) as count FROM {table} WHERE YEAR({date_field}) = 2024")
                        count_2024 = cursor.fetchone()['count']
                        print(f"{table}: {count} total records ({count_2024} from 2024)")
                    else:
                        print(f"{table}: {count} records")
                else:
                    print(f"{table}: {count} records")
    
    except Exception as e:
        print(f"Error: {e}")
        connection.rollback()
    finally:
        connection.close()

if __name__ == "__main__":
    print("Checking and populating missing data...")
    print("="*60)
    check_and_populate()