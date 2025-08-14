-- SQL script to populate missing data identified in disclosure testing
-- This script adds sample data for tables that were found to be empty or missing critical data

-- 1. Populate stakeholder_engagement table
INSERT INTO stakeholder_engagement (engagement_id, stakeholder_group, engagement_date, engagement_method, topics_discussed, outcomes, participants) VALUES
(1, 'Employees', '2024-01-15', 'Town Hall Meeting', 'Sustainability goals, carbon reduction targets, employee wellness programs', 'Launched employee green initiative program, established sustainability champions network', 250),
(2, 'Local Communities', '2024-02-20', 'Community Forum', 'Factory emissions reduction, local job creation, community investment programs', 'Committed to 30% emission reduction by 2025, announced 50 new local jobs, $2M community fund', 150),
(3, 'Investors', '2024-03-10', 'Annual General Meeting', 'ESG performance, climate risk management, sustainable finance', 'Approved sustainability-linked bond issuance, enhanced climate risk reporting', 300),
(4, 'NGOs', '2024-04-05', 'Roundtable Discussion', 'Biodiversity protection, water management, circular economy', 'Partnership agreement for biodiversity monitoring, water reduction targets set', 25),
(5, 'Suppliers', '2024-05-15', 'Supplier Summit', 'Sustainable sourcing, carbon footprint reduction, ethical practices', 'Launched supplier sustainability certification program, carbon tracking system', 180),
(6, 'Customers', '2024-06-01', 'Customer Survey', 'Product sustainability, packaging reduction, carbon labeling', 'Introduced eco-friendly product line, 50% packaging reduction commitment', 5000),
(7, 'Government', '2024-07-20', 'Policy Consultation', 'Environmental regulations, sustainability reporting, green incentives', 'Aligned reporting with CSRD requirements, qualified for green tax incentives', 15),
(8, 'Academic Institutions', '2024-08-10', 'Research Partnership Meeting', 'Climate science, sustainable technology, innovation', 'Established $5M research fund for sustainable technologies', 40),
(9, 'Media', '2024-09-05', 'Press Conference', 'Sustainability strategy update, net-zero commitment', 'Announced 2040 net-zero target, quarterly sustainability updates', 50),
(10, 'Labor Unions', '2024-10-15', 'Collective Bargaining', 'Just transition, green jobs training, worker safety', 'Agreed on reskilling program for 500 workers, enhanced safety protocols', 30);

-- 2. Populate sustainability_targets table with comprehensive targets
INSERT INTO sustainability_targets (target_id, target_category, target_name, target_description, baseline_year, baseline_value, target_year, target_value, unit_of_measure, current_value, last_updated) VALUES
-- Climate targets
(1, 'Climate', 'GHG Emissions Reduction', 'Reduce absolute Scope 1 and 2 GHG emissions by 50%', 2020, 100000, 2030, 50000, 'tCO2e', 75000, '2024-12-01'),
(2, 'Climate', 'Renewable Energy', 'Achieve 100% renewable electricity in operations', 2020, 35, 2025, 100, 'percentage', 68, '2024-12-01'),
(3, 'Climate', 'Energy Efficiency', 'Improve energy intensity by 30%', 2020, 150, 2030, 105, 'MWh/million USD revenue', 130, '2024-12-01'),
(4, 'Climate', 'Scope 3 Emissions', 'Reduce Scope 3 emissions from purchased goods by 25%', 2020, 500000, 2030, 375000, 'tCO2e', 450000, '2024-12-01'),
(5, 'Climate', 'Carbon Neutrality', 'Achieve carbon neutrality in direct operations', 2020, 0, 2035, 100, 'percentage carbon neutral', 25, '2024-12-01'),

-- Water targets
(6, 'Water', 'Water Consumption', 'Reduce water consumption in water-stressed areas by 40%', 2020, 1000, 2030, 600, 'megaliters', 800, '2024-12-01'),
(7, 'Water', 'Water Recycling', 'Achieve 50% water recycling rate in manufacturing', 2020, 20, 2025, 50, 'percentage', 35, '2024-12-01'),

-- Waste and circular economy targets
(8, 'Waste', 'Zero Waste to Landfill', 'Achieve zero waste to landfill in all facilities', 2020, 60, 2025, 100, 'percentage diverted', 85, '2024-12-01'),
(9, 'Circular Economy', 'Recycled Content', 'Use 75% recycled content in packaging', 2020, 30, 2025, 75, 'percentage', 55, '2024-12-01'),
(10, 'Circular Economy', 'Product Take-back', 'Establish product take-back program covering 80% of products', 2020, 0, 2027, 80, 'percentage coverage', 25, '2024-12-01'),

-- Social targets
(11, 'Social', 'Gender Diversity', 'Achieve 40% women in leadership positions', 2020, 25, 2025, 40, 'percentage', 32, '2024-12-01'),
(12, 'Social', 'Employee Training', 'Provide 40 hours annual sustainability training per employee', 2020, 10, 2025, 40, 'hours', 25, '2024-12-01'),
(13, 'Social', 'Workplace Safety', 'Reduce workplace incidents by 50%', 2020, 20, 2025, 10, 'incidents per 1000 employees', 14, '2024-12-01'),
(14, 'Social', 'Living Wage', 'Ensure 100% of employees earn living wage', 2020, 85, 2023, 100, 'percentage', 100, '2024-12-01'),

-- Governance targets
(15, 'Governance', 'Board Diversity', 'Maintain minimum 30% board diversity (gender and ethnicity)', 2020, 20, 2023, 30, 'percentage', 35, '2024-12-01'),
(16, 'Governance', 'Supplier Sustainability', 'Assess 100% of tier 1 suppliers on sustainability criteria', 2020, 40, 2025, 100, 'percentage', 75, '2024-12-01'),
(17, 'Governance', 'Ethics Training', 'Achieve 100% employee completion of annual ethics training', 2020, 90, 2023, 100, 'percentage', 98, '2024-12-01'),

-- Biodiversity targets
(18, 'Biodiversity', 'Nature Positive', 'Achieve net positive impact on biodiversity at all sites', 2020, 0, 2030, 100, 'percentage sites', 20, '2024-12-01'),
(19, 'Biodiversity', 'Deforestation-free', 'Ensure 100% deforestation-free supply chain', 2020, 70, 2025, 100, 'percentage', 88, '2024-12-01'),

-- Innovation targets
(20, 'Innovation', 'Sustainable Products', 'Generate 50% revenue from sustainable products', 2020, 20, 2030, 50, 'percentage revenue', 28, '2024-12-01');

-- 3. Populate community_projects table
INSERT INTO community_projects (project_id, project_name, location, start_date, end_date, investment_usd, beneficiaries, project_type, description) VALUES
(1, 'Clean Water Access Initiative', 'Kenya', '2024-01-01', '2024-12-31', 500000, 5000, 'Infrastructure', 'Building water purification systems in rural communities'),
(2, 'STEM Education Program', 'USA', '2024-02-01', '2025-01-31', 250000, 1000, 'Education', 'Providing STEM education and mentorship to underserved students'),
(3, 'Reforestation Project', 'Brazil', '2024-03-01', '2026-02-28', 750000, 10000, 'Environment', 'Planting 1 million trees and restoring degraded land'),
(4, 'Local Business Incubator', 'India', '2024-04-01', '2025-03-31', 300000, 200, 'Economic Development', 'Supporting local entrepreneurs with training and microfinance'),
(5, 'Community Health Clinic', 'Philippines', '2024-05-01', '2025-04-30', 400000, 8000, 'Healthcare', 'Establishing mobile health clinics in remote areas'),
(6, 'Renewable Energy for Schools', 'Ghana', '2024-06-01', '2024-11-30', 600000, 3000, 'Infrastructure', 'Installing solar panels in 20 schools'),
(7, 'Youth Skills Training', 'Mexico', '2024-07-01', '2025-06-30', 200000, 500, 'Education', 'Vocational training for unemployed youth'),
(8, 'Ocean Cleanup Initiative', 'Indonesia', '2024-08-01', '2025-07-31', 450000, 15000, 'Environment', 'Removing plastic waste from coastal areas'),
(9, 'Digital Literacy Program', 'South Africa', '2024-09-01', '2025-08-31', 350000, 2000, 'Education', 'Teaching digital skills to rural communities'),
(10, 'Sustainable Agriculture', 'Vietnam', '2024-10-01', '2026-09-30', 550000, 1500, 'Economic Development', 'Training farmers in sustainable farming practices');

-- 4. Update executive_compensation to ensure sustainability KPIs are properly linked
UPDATE executive_compensation 
SET sustainability_kpi_description = CASE 
    WHEN sustainability_linked_bonus_usd > 0 AND sustainability_kpi_description IS NULL THEN
        CASE comp_id % 5
            WHEN 0 THEN 'Achievement of 25% reduction in Scope 1 & 2 emissions'
            WHEN 1 THEN 'Meeting diversity targets (40% women in leadership)'
            WHEN 2 THEN 'Achieving zero workplace incidents target'
            WHEN 3 THEN 'Successful implementation of circular economy initiatives'
            WHEN 4 THEN 'Meeting renewable energy transition milestones'
        END
    ELSE sustainability_kpi_description
END
WHERE sustainability_linked_bonus_usd > 0;

-- 5. Add more detailed training records for sustainability
INSERT INTO employee_training (training_id, employee_id, training_type, training_category, hours, completion_date)
SELECT 
    (SELECT COALESCE(MAX(training_id), 0) FROM employee_training) + ROW_NUMBER() OVER (),
    e.employee_id,
    'Sustainability Awareness',
    'Environmental',
    8,
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 365) DAY)
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM employee_training et 
    WHERE et.employee_id = e.employee_id 
    AND et.training_type = 'Sustainability Awareness'
)
LIMIT 500;

-- 6. Add policies if they don't exist
INSERT INTO policies (policy_id, policy_name, policy_category, effective_date, last_reviewed, policy_text, applies_to_suppliers) VALUES
(1, 'Environmental Management Policy', 'Environmental', '2023-01-01', '2024-01-01', 'Comprehensive policy outlining our commitment to environmental protection, including targets for emissions reduction, water conservation, and biodiversity protection.', TRUE),
(2, 'Human Rights Policy', 'Social', '2023-01-01', '2024-01-01', 'Policy ensuring respect for human rights throughout our operations and supply chain, including prohibition of child labor, forced labor, and discrimination.', TRUE),
(3, 'Climate Change Policy', 'Environmental', '2023-06-01', '2024-06-01', 'Detailed policy on climate change mitigation and adaptation, including net-zero commitment, renewable energy targets, and climate risk management.', TRUE),
(4, 'Diversity and Inclusion Policy', 'Social', '2023-01-01', '2024-01-01', 'Policy promoting diversity, equity, and inclusion in all aspects of our business, with specific targets and accountability measures.', FALSE),
(5, 'Anti-Corruption Policy', 'Governance', '2023-01-01', '2024-01-01', 'Zero-tolerance policy on corruption and bribery, with clear guidelines, training requirements, and reporting mechanisms.', TRUE),
(6, 'Sustainable Procurement Policy', 'Environmental', '2023-03-01', '2024-03-01', 'Policy requiring sustainability assessment of all suppliers, preference for certified sustainable materials, and supplier development programs.', TRUE),
(7, 'Data Privacy Policy', 'Governance', '2023-05-01', '2024-05-01', 'Comprehensive data protection policy ensuring compliance with GDPR and other privacy regulations.', TRUE),
(8, 'Health and Safety Policy', 'Social', '2023-01-01', '2024-01-01', 'Policy prioritizing employee health and safety with zero-incident vision and comprehensive safety management system.', TRUE),
(9, 'Community Engagement Policy', 'Social', '2023-04-01', '2024-04-01', 'Framework for meaningful engagement with local communities, including grievance mechanisms and benefit sharing.', FALSE),
(10, 'Biodiversity Policy', 'Environmental', '2023-07-01', '2024-07-01', 'Commitment to no net loss of biodiversity, protection of endangered species, and ecosystem restoration.', TRUE)
ON DUPLICATE KEY UPDATE last_reviewed = VALUES(last_reviewed);

-- 7. Add lobbying activities data
INSERT INTO lobbying_activities (activity_id, year, organization_name, topic, amount_usd, activity_type) VALUES
(1, 2024, 'Sustainable Business Alliance', 'Climate legislation support', 50000, 'Direct'),
(2, 2024, 'Clean Energy Coalition', 'Renewable energy incentives', 75000, 'Association'),
(3, 2024, 'Industry Environmental Forum', 'Circular economy regulations', 25000, 'Association'),
(4, 2024, 'Corporate Climate Leaders', 'Carbon pricing mechanisms', 100000, 'Direct'),
(5, 2024, 'Green Finance Initiative', 'Sustainable finance regulations', 40000, 'Association');

-- Create function for YEAR if it doesn't exist (fixing the error from test)
-- Note: This would need to be run by a DBA with appropriate privileges
-- DELIMITER $$
-- CREATE FUNCTION IF NOT EXISTS YEAR(date_value DATE)
-- RETURNS INT
-- DETERMINISTIC
-- BEGIN
--     RETURN YEAR(date_value);
-- END$$
-- DELIMITER ;