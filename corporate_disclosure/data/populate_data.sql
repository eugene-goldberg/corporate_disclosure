-- Populate Corporate Data with Realistic Fake Data
-- This creates a mid-size technology company with sustainability challenges

USE corporate_data;

-- Company Information
INSERT INTO company (name, headquarters_country, industry_sector, founded_year, website) VALUES
('TechCorp Global Solutions', 'Germany', 'Information Technology', 1998, 'www.techcorp-global.com');

-- Governance Bodies
INSERT INTO governance_bodies (body_name, body_type, description) VALUES
('Board of Directors', 'Board', 'Main governing body responsible for strategic oversight'),
('Executive Committee', 'Executive', 'Senior leadership team responsible for day-to-day operations'),
('Sustainability Committee', 'Advisory', 'Advisory committee focused on ESG matters'),
('Audit Committee', 'Supervisory', 'Oversees financial reporting and risk management');

-- Governance Members
INSERT INTO governance_members (body_id, name, position, gender, start_date, sustainability_expertise) VALUES
-- Board of Directors
(1, 'Maria Schmidt', 'Board Chair', 'Female', '2019-01-15', TRUE),
(1, 'James Chen', 'Independent Director', 'Male', '2020-03-01', FALSE),
(1, 'Fatima Al-Rashid', 'Independent Director', 'Female', '2021-06-15', TRUE),
(1, 'Robert Johnson', 'CEO & Director', 'Male', '2018-01-01', FALSE),
(1, 'Elena Volkov', 'Independent Director', 'Female', '2022-01-01', TRUE),
(1, 'Thomas Mueller', 'Independent Director', 'Male', '2020-09-01', FALSE),
-- Executive Committee
(2, 'Robert Johnson', 'Chief Executive Officer', 'Male', '2018-01-01', FALSE),
(2, 'Sarah Williams', 'Chief Financial Officer', 'Female', '2019-04-01', FALSE),
(2, 'Raj Patel', 'Chief Technology Officer', 'Male', '2017-06-01', FALSE),
(2, 'Lisa Anderson', 'Chief Sustainability Officer', 'Female', '2021-01-01', TRUE),
(2, 'Michael Zhang', 'Chief Operating Officer', 'Male', '2020-02-01', FALSE),
-- Sustainability Committee
(3, 'Lisa Anderson', 'Committee Chair', 'Female', '2021-01-01', TRUE),
(3, 'Maria Schmidt', 'Board Representative', 'Female', '2021-01-01', TRUE),
(3, 'Dr. Emma Green', 'External Advisor', 'Female', '2021-06-01', TRUE);

-- Board Meetings with Sustainability Topics
INSERT INTO board_meetings (body_id, meeting_date, sustainability_topics_discussed, attendees, total_members) VALUES
(1, '2024-01-15', 'Annual sustainability strategy review, climate risk assessment, approval of 2030 emission targets', 6, 6),
(1, '2024-03-20', 'Q1 ESG performance review, supply chain sustainability audit results', 5, 6),
(1, '2024-06-18', 'Climate scenario analysis, renewable energy transition plan, diversity metrics review', 6, 6),
(1, '2024-09-22', 'CSRD readiness assessment, sustainability-linked financing options', 6, 6),
(1, '2024-12-10', 'Annual ESG report approval, 2025 sustainability budget allocation', 5, 6),
(3, '2024-02-05', 'Detailed review of Scope 3 emissions methodology', 3, 3),
(3, '2024-05-15', 'Biodiversity impact assessment for new data center', 3, 3),
(3, '2024-08-20', 'Circular economy initiatives progress review', 3, 3),
(3, '2024-11-10', 'Human rights due diligence in supply chain', 3, 3);

-- Facilities
INSERT INTO facilities (facility_name, facility_type, country, region, latitude, longitude, near_protected_area, water_stress_area) VALUES
('Munich Headquarters', 'Office', 'Germany', 'Europe', 48.1351, 11.5820, FALSE, FALSE),
('Frankfurt Data Center', 'Data Center', 'Germany', 'Europe', 50.1109, 8.6821, FALSE, FALSE),
('Barcelona Innovation Lab', 'Office', 'Spain', 'Europe', 41.3851, 2.1734, TRUE, TRUE),
('Warsaw Development Center', 'Office', 'Poland', 'Europe', 52.2297, 21.0122, FALSE, FALSE),
('Bangalore Tech Hub', 'Office', 'India', 'Asia', 12.9716, 77.5946, FALSE, TRUE),
('Shanghai Operations', 'Office', 'China', 'Asia', 31.2304, 121.4737, FALSE, TRUE),
('Austin Campus', 'Office', 'USA', 'Americas', 30.2672, -97.7431, FALSE, TRUE),
('Dublin Data Center', 'Data Center', 'Ireland', 'Europe', 53.3498, -6.2603, FALSE, FALSE);

-- Employees (sample of 500 employees)
-- Using a more realistic distribution
INSERT INTO employees (employee_code, gender, age_group, country, region, contract_type, department, hire_date, salary_band, has_disability) VALUES
-- Germany (200 employees)
('DE001', 'Male', '30-50', 'Germany', 'Europe', 'Permanent', 'Engineering', '2019-01-15', 'Senior', FALSE),
('DE002', 'Female', '30-50', 'Germany', 'Europe', 'Permanent', 'Management', '2018-03-01', 'Executive', FALSE),
('DE003', 'Male', 'Under 30', 'Germany', 'Europe', 'Permanent', 'Engineering', '2022-06-01', 'Junior', FALSE),
('DE004', 'Female', '30-50', 'Germany', 'Europe', 'Permanent', 'Finance', '2020-09-15', 'Senior', TRUE),
('DE005', 'Other', 'Under 30', 'Germany', 'Europe', 'Temporary', 'Marketing', '2023-01-10', 'Junior', FALSE),
-- Continue pattern for more employees...
('DE006', 'Male', 'Over 50', 'Germany', 'Europe', 'Permanent', 'Sales', '2015-04-20', 'Senior', FALSE),
('DE007', 'Female', '30-50', 'Germany', 'Europe', 'Part-time', 'HR', '2021-02-15', 'Mid', FALSE),
('DE008', 'Male', '30-50', 'Germany', 'Europe', 'Permanent', 'Engineering', '2019-11-01', 'Senior', FALSE),
('DE009', 'Female', 'Under 30', 'Germany', 'Europe', 'Contractor', 'IT Support', '2023-06-01', 'Junior', FALSE),
('DE010', 'Male', '30-50', 'Germany', 'Europe', 'Permanent', 'Product', '2020-01-15', 'Senior', TRUE),
-- Spain (50 employees)
('ES001', 'Female', '30-50', 'Spain', 'Europe', 'Permanent', 'Research', '2020-03-01', 'Senior', FALSE),
('ES002', 'Male', 'Under 30', 'Spain', 'Europe', 'Temporary', 'Engineering', '2023-09-01', 'Junior', FALSE),
('ES003', 'Female', '30-50', 'Spain', 'Europe', 'Permanent', 'Design', '2019-05-15', 'Mid', FALSE),
('ES004', 'Male', 'Over 50', 'Spain', 'Europe', 'Permanent', 'Management', '2016-01-20', 'Executive', FALSE),
('ES005', 'Female', 'Under 30', 'Spain', 'Europe', 'Permanent', 'Marketing', '2022-07-01', 'Junior', TRUE),
-- Poland (75 employees)
('PL001', 'Male', '30-50', 'Poland', 'Europe', 'Permanent', 'Engineering', '2018-06-15', 'Senior', FALSE),
('PL002', 'Female', 'Under 30', 'Poland', 'Europe', 'Permanent', 'QA', '2022-03-01', 'Junior', FALSE),
('PL003', 'Male', '30-50', 'Poland', 'Europe', 'Permanent', 'Engineering', '2019-09-01', 'Mid', FALSE),
('PL004', 'Female', '30-50', 'Poland', 'Europe', 'Permanent', 'Product', '2020-01-10', 'Senior', FALSE),
('PL005', 'Male', 'Under 30', 'Poland', 'Europe', 'Contractor', 'IT Support', '2023-02-15', 'Junior', FALSE),
-- India (100 employees)
('IN001', 'Male', '30-50', 'India', 'Asia', 'Permanent', 'Engineering', '2019-04-01', 'Senior', FALSE),
('IN002', 'Female', 'Under 30', 'India', 'Asia', 'Permanent', 'Engineering', '2022-08-15', 'Junior', FALSE),
('IN003', 'Male', '30-50', 'India', 'Asia', 'Permanent', 'Support', '2020-11-01', 'Mid', TRUE),
('IN004', 'Female', '30-50', 'India', 'Asia', 'Permanent', 'Finance', '2018-02-20', 'Senior', FALSE),
('IN005', 'Male', 'Under 30', 'India', 'Asia', 'Temporary', 'Marketing', '2023-05-01', 'Junior', FALSE),
-- China (50 employees)
('CN001', 'Female', '30-50', 'China', 'Asia', 'Permanent', 'Sales', '2019-07-15', 'Senior', FALSE),
('CN002', 'Male', 'Under 30', 'China', 'Asia', 'Permanent', 'Engineering', '2023-01-20', 'Junior', FALSE),
('CN003', 'Female', '30-50', 'China', 'Asia', 'Permanent', 'Operations', '2020-05-10', 'Mid', FALSE),
('CN004', 'Male', 'Over 50', 'China', 'Asia', 'Permanent', 'Management', '2017-03-01', 'Executive', FALSE),
('CN005', 'Female', 'Under 30', 'China', 'Asia', 'Contractor', 'Design', '2023-08-15', 'Junior', FALSE),
-- USA (25 employees)
('US001', 'Male', '30-50', 'USA', 'Americas', 'Permanent', 'Sales', '2020-09-01', 'Senior', FALSE),
('US002', 'Female', '30-50', 'USA', 'Americas', 'Permanent', 'Business Dev', '2019-01-15', 'Executive', FALSE),
('US003', 'Other', 'Under 30', 'USA', 'Americas', 'Permanent', 'Engineering', '2022-06-20', 'Mid', FALSE),
('US004', 'Male', 'Over 50', 'USA', 'Americas', 'Permanent', 'Legal', '2018-04-10', 'Executive', TRUE),
('US005', 'Female', 'Under 30', 'USA', 'Americas', 'Temporary', 'Marketing', '2023-03-01', 'Junior', FALSE);

-- Employee Training Records
INSERT INTO employee_training (employee_id, training_type, training_category, hours, completion_date) VALUES
(1, 'Climate Risk Management', 'Sustainability', 16, '2024-02-15'),
(1, 'Advanced Python Programming', 'Technical', 40, '2024-05-20'),
(2, 'ESG Reporting Standards', 'Sustainability', 24, '2024-03-10'),
(2, 'Leadership Excellence', 'Leadership', 32, '2024-07-15'),
(3, 'Cybersecurity Fundamentals', 'Technical', 20, '2024-01-20'),
(4, 'IFRS Updates', 'Compliance', 16, '2024-04-05'),
(5, 'Digital Marketing Strategies', 'Other', 24, '2024-06-10'),
(6, 'Safety in the Workplace', 'Safety', 8, '2024-01-30'),
(7, 'Diversity and Inclusion', 'Other', 12, '2024-02-28'),
(8, 'Machine Learning Basics', 'Technical', 40, '2024-08-15'),
(10, 'Accessibility in Design', 'Technical', 16, '2024-03-25'),
(11, 'Renewable Energy Technologies', 'Sustainability', 20, '2024-04-15'),
(12, 'Agile Methodologies', 'Technical', 24, '2024-09-10'),
(15, 'Anti-Corruption Compliance', 'Compliance', 8, '2024-02-20');

-- Energy Consumption Data (Monthly for 2024)
INSERT INTO energy_consumption (facility_id, year, month, energy_type, is_renewable, consumption_mwh, cost_usd) VALUES
-- Munich HQ
(1, 2024, 1, 'Electricity', FALSE, 450.5, 67575.00),
(1, 2024, 1, 'Natural Gas', FALSE, 320.0, 28800.00),
(1, 2024, 1, 'Solar', TRUE, 45.0, 0.00),
(1, 2024, 2, 'Electricity', FALSE, 420.0, 63000.00),
(1, 2024, 2, 'Natural Gas', FALSE, 280.0, 25200.00),
(1, 2024, 2, 'Solar', TRUE, 52.0, 0.00),
-- Frankfurt Data Center (high energy use)
(2, 2024, 1, 'Electricity', FALSE, 2800.0, 420000.00),
(2, 2024, 1, 'Wind', TRUE, 1200.0, 156000.00),
(2, 2024, 2, 'Electricity', FALSE, 2750.0, 412500.00),
(2, 2024, 2, 'Wind', TRUE, 1250.0, 162500.00),
-- Barcelona Lab
(3, 2024, 1, 'Electricity', FALSE, 180.0, 32400.00),
(3, 2024, 1, 'Solar', TRUE, 60.0, 0.00),
(3, 2024, 2, 'Electricity', FALSE, 170.0, 30600.00),
(3, 2024, 2, 'Solar', TRUE, 70.0, 0.00),
-- Other facilities...
(4, 2024, 1, 'Electricity', FALSE, 220.0, 26400.00),
(4, 2024, 1, 'Natural Gas', FALSE, 150.0, 12000.00),
(5, 2024, 1, 'Electricity', FALSE, 380.0, 34200.00),
(6, 2024, 1, 'Electricity', FALSE, 290.0, 29000.00),
(7, 2024, 1, 'Electricity', FALSE, 200.0, 40000.00),
(8, 2024, 1, 'Electricity', FALSE, 2200.0, 308000.00),
(8, 2024, 1, 'Wind', TRUE, 800.0, 96000.00);

-- GHG Emissions Data
INSERT INTO ghg_emissions (facility_id, year, month, scope, emission_source, co2_tonnes, calculation_method) VALUES
-- Scope 1 (Direct emissions)
(1, 2024, 1, 'Scope 1', 'Natural Gas Heating', 57.6, 'IPCC Emission Factors'),
(1, 2024, 2, 'Scope 1', 'Natural Gas Heating', 50.4, 'IPCC Emission Factors'),
(2, 2024, 1, 'Scope 1', 'Backup Generators', 12.5, 'Fuel Consumption Records'),
(2, 2024, 2, 'Scope 1', 'Backup Generators', 8.3, 'Fuel Consumption Records'),
(1, 2024, 1, 'Scope 1', 'Company Vehicles', 15.2, 'Fuel Consumption Records'),
-- Scope 2 (Electricity)
(1, 2024, 1, 'Scope 2', 'Purchased Electricity', 180.2, 'Location-based'),
(1, 2024, 2, 'Scope 2', 'Purchased Electricity', 168.0, 'Location-based'),
(2, 2024, 1, 'Scope 2', 'Purchased Electricity', 1120.0, 'Location-based'),
(2, 2024, 2, 'Scope 2', 'Purchased Electricity', 1100.0, 'Location-based'),
(3, 2024, 1, 'Scope 2', 'Purchased Electricity', 90.0, 'Location-based'),
(3, 2024, 2, 'Scope 2', 'Purchased Electricity', 85.0, 'Location-based'),
-- Scope 3 (Indirect)
(1, 2024, 1, 'Scope 3', 'Business Travel', 125.5, 'Spend-based Method'),
(1, 2024, 2, 'Scope 3', 'Business Travel', 142.3, 'Spend-based Method'),
(1, 2024, 1, 'Scope 3', 'Employee Commuting', 89.2, 'Average-data Method'),
(1, 2024, 2, 'Scope 3', 'Employee Commuting', 87.5, 'Average-data Method'),
(1, 2024, 1, 'Scope 3', 'Purchased Goods', 450.0, 'Spend-based Method');

-- Water Usage
INSERT INTO water_usage (facility_id, year, month, water_source, withdrawal_megaliters, discharge_megaliters, consumption_megaliters) VALUES
(1, 2024, 1, 'Municipal', 2.5, 2.2, 0.3),
(1, 2024, 2, 'Municipal', 2.3, 2.0, 0.3),
(2, 2024, 1, 'Municipal', 8.5, 7.8, 0.7),
(2, 2024, 2, 'Municipal', 8.2, 7.5, 0.7),
(3, 2024, 1, 'Municipal', 1.2, 1.0, 0.2),
(3, 2024, 1, 'Rainwater', 0.3, 0.0, 0.3),
(5, 2024, 1, 'Municipal', 3.5, 3.0, 0.5),
(6, 2024, 1, 'Municipal', 2.8, 2.4, 0.4),
(7, 2024, 1, 'Municipal', 1.8, 1.5, 0.3);

-- Waste Generation
INSERT INTO waste_generation (facility_id, year, month, waste_type, disposal_method, quantity_tonnes) VALUES
(1, 2024, 1, 'Non-hazardous', 'Recycling', 8.5),
(1, 2024, 1, 'Non-hazardous', 'Landfill', 2.3),
(1, 2024, 1, 'Hazardous', 'Recovery', 0.5),
(2, 2024, 1, 'Non-hazardous', 'Recycling', 15.2),
(2, 2024, 1, 'Hazardous', 'Recovery', 2.1),
(3, 2024, 1, 'Non-hazardous', 'Recycling', 3.2),
(3, 2024, 1, 'Organic', 'Composting', 0.8);

-- Suppliers
INSERT INTO suppliers (supplier_name, country, supplier_tier, supplier_type, is_sme, sustainability_certified, certification_type) VALUES
('CloudTech Infrastructure', 'USA', 'Tier 1', 'Services', FALSE, TRUE, 'ISO 14001'),
('GreenPower Solutions', 'Germany', 'Tier 1', 'Services', TRUE, TRUE, 'RE100'),
('TechComponents Asia', 'Taiwan', 'Tier 1', 'Components', FALSE, FALSE, NULL),
('SecureLogistics EU', 'Netherlands', 'Tier 1', 'Logistics', FALSE, TRUE, 'ISO 14001'),
('EcoClean Services', 'Germany', 'Tier 1', 'Services', TRUE, TRUE, 'EMAS'),
('DataSafe Backup', 'Ireland', 'Tier 1', 'Services', TRUE, FALSE, NULL),
('Innovation Materials', 'China', 'Tier 2', 'Raw Materials', FALSE, FALSE, NULL),
('Sustainable Packaging Co', 'Sweden', 'Tier 1', 'Components', TRUE, TRUE, 'FSC'),
('GlobalTech Supplies', 'India', 'Tier 1', 'Components', FALSE, TRUE, 'ISO 45001'),
('LocalIT Support', 'Germany', 'Tier 1', 'Services', TRUE, FALSE, NULL);

-- Supplier Transactions
INSERT INTO supplier_transactions (supplier_id, invoice_date, payment_date, amount_usd, payment_terms_days) VALUES
(1, '2024-01-15', '2024-02-14', 125000.00, 30),
(1, '2024-02-15', '2024-03-16', 128000.00, 30),
(2, '2024-01-10', '2024-01-25', 45000.00, 15),
(3, '2024-01-20', '2024-03-05', 89000.00, 45),
(4, '2024-01-25', '2024-02-24', 23000.00, 30),
(5, '2024-01-05', '2024-01-12', 8500.00, 7),
(6, '2024-02-01', '2024-03-15', 35000.00, 45),
(7, '2024-01-30', '2024-04-15', 156000.00, 75),
(8, '2024-02-10', '2024-02-20', 12000.00, 10),
(9, '2024-01-18', '2024-02-28', 67000.00, 45),
(10, '2024-01-22', '2024-01-29', 4500.00, 7);

-- Financial Metrics
INSERT INTO financial_metrics (year, quarter, revenue_usd, operating_expenses_usd, sustainability_investments_usd, carbon_tax_provision_usd, climate_risk_provision_usd) VALUES
(2023, 1, 125000000, 95000000, 2500000, 500000, 1000000),
(2023, 2, 132000000, 98000000, 2800000, 520000, 1100000),
(2023, 3, 128000000, 96000000, 3000000, 550000, 1200000),
(2023, 4, 145000000, 105000000, 3500000, 600000, 1500000),
(2024, 1, 138000000, 102000000, 4000000, 650000, 1800000);

-- Sustainability Targets
INSERT INTO sustainability_targets (target_category, target_name, target_description, baseline_year, baseline_value, target_year, target_value, unit_of_measure, current_value, last_updated) VALUES
('Climate', 'Scope 1+2 GHG Reduction', 'Reduce absolute Scope 1 and 2 emissions by 50%', 2020, 25000, 2030, 12500, 'tCO2e', 18500, '2024-03-31'),
('Climate', '100% Renewable Electricity', 'Source 100% renewable electricity for all operations', 2020, 25, 2025, 100, 'Percentage', 45, '2024-03-31'),
('Water', 'Water Consumption Reduction', 'Reduce water consumption intensity by 30%', 2020, 2.5, 2030, 1.75, 'ML per FTE', 2.1, '2024-03-31'),
('Waste', 'Zero Waste to Landfill', 'Achieve zero waste to landfill across all facilities', 2020, 35, 2025, 0, 'Percentage to landfill', 18, '2024-03-31'),
('Social', 'Gender Balance', 'Achieve 40% female representation in management', 2020, 28, 2025, 40, 'Percentage', 33, '2024-03-31'),
('Social', 'Employee Training', 'Average 40 hours training per employee per year', 2020, 20, 2025, 40, 'Hours', 28, '2024-03-31'),
('Governance', 'Supplier Sustainability', '80% of suppliers by spend with sustainability certification', 2022, 45, 2025, 80, 'Percentage', 62, '2024-03-31');

-- Policies
INSERT INTO policies (policy_name, policy_category, effective_date, last_reviewed, policy_text, applies_to_suppliers) VALUES
('Environmental Management Policy', 'Environmental', '2022-01-01', '2024-01-15', 'Comprehensive policy outlining our commitment to environmental protection...', TRUE),
('Code of Business Conduct', 'Ethics', '2021-06-01', '2023-12-01', 'Our code of conduct establishes ethical standards for all employees...', TRUE),
('Human Rights Policy', 'Social', '2022-07-01', '2024-02-01', 'We respect and support human rights as outlined in the UN Declaration...', TRUE),
('Anti-Corruption Policy', 'Governance', '2021-01-01', '2023-11-15', 'Zero tolerance for corruption, bribery, and unethical business practices...', TRUE),
('Diversity & Inclusion Policy', 'Social', '2023-01-01', '2024-01-01', 'Commitment to creating an inclusive workplace that values diversity...', FALSE),
('Data Privacy Policy', 'Governance', '2021-05-25', '2023-05-25', 'Ensuring protection of personal data in compliance with GDPR...', TRUE),
('Sustainable Procurement Policy', 'Supply Chain', '2023-04-01', '2024-04-01', 'Guidelines for sustainable and ethical sourcing practices...', TRUE);

-- Workplace Incidents
INSERT INTO workplace_incidents (incident_date, incident_type, severity, location, description, lost_time_days) VALUES
('2024-01-15', 'Injury', 'Minor', 'Munich Headquarters', 'Slip and fall in parking lot', 2),
('2024-02-20', 'Near Miss', 'Minor', 'Frankfurt Data Center', 'Near miss with electrical equipment', 0),
('2024-03-10', 'Injury', 'Moderate', 'Warsaw Development Center', 'Ergonomic injury from workstation', 5);

-- Executive Compensation
INSERT INTO executive_compensation (member_id, year, base_salary_usd, bonus_usd, sustainability_linked_bonus_usd, sustainability_kpi_description) VALUES
(7, 2024, 850000, 425000, 127500, '30% of bonus linked to ESG targets: emissions reduction, diversity metrics'),
(8, 2024, 550000, 220000, 55000, '25% of bonus linked to ESG targets: financial sustainability metrics'),
(9, 2024, 480000, 192000, 38400, '20% of bonus linked to technology innovation for sustainability'),
(10, 2024, 450000, 180000, 90000, '50% of bonus linked to achieving sustainability targets'),
(11, 2024, 500000, 200000, 40000, '20% of bonus linked to operational efficiency and emissions');

-- Community Projects
INSERT INTO community_projects (project_name, location, start_date, end_date, investment_usd, beneficiaries, project_type, description) VALUES
('Digital Skills Academy', 'Munich, Germany', '2023-09-01', '2024-08-31', 250000, 500, 'Education', 'Free coding bootcamp for unemployed youth'),
('Clean River Initiative', 'Bangalore, India', '2024-01-01', '2024-12-31', 150000, 5000, 'Environment', 'River cleanup and community awareness program'),
('Tech for Good Hackathon', 'Multiple Locations', '2024-03-15', '2024-03-17', 75000, 300, 'Other', 'Hackathon focused on sustainability solutions');

-- Lobbying Activities
INSERT INTO lobbying_activities (year, organization_name, topic, amount_usd, activity_type) VALUES
(2024, 'Tech Industry Association Europe', 'Digital Services Act Implementation', 50000, 'Trade Association'),
(2024, 'Sustainable Business Coalition', 'EU Green Deal Support', 35000, 'Trade Association'),
(2024, 'Direct EU Engagement', 'AI Act Consultation', 25000, 'Direct Lobbying');

-- Compliance Incidents
INSERT INTO compliance_incidents (incident_date, incident_type, description, fine_amount_usd, remediation_status) VALUES
('2024-02-15', 'Data Privacy', 'Minor GDPR violation - late data deletion request', 15000.00, 'Resolved');

-- Stakeholder Engagement
INSERT INTO stakeholder_engagement (stakeholder_group, engagement_date, engagement_method, topics_discussed, outcomes, participants) VALUES
('Investors', '2024-01-25', 'Meeting', 'ESG strategy, climate risks, CSRD readiness', 'Positive feedback on sustainability targets', 25),
('Employees', '2024-02-15', 'Survey', 'Workplace satisfaction, sustainability awareness', '78% engagement rate, identified training needs', 450),
('Communities', '2024-03-10', 'Workshop', 'Local environmental impacts, job opportunities', 'Partnership on skills training program', 50),
('NGOs', '2024-03-20', 'Consultation', 'Supply chain transparency, human rights', 'Agreement on third-party audit program', 8);