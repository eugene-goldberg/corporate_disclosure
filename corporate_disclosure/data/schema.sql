-- Corporate Data Schema for ESRS Disclosure
-- This schema is designed to hold corporate operational data
-- that will be queried to answer ESRS disclosure questions

USE corporate_data;

-- Company Information
CREATE TABLE company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    headquarters_country VARCHAR(100),
    industry_sector VARCHAR(100),
    founded_year INT,
    website VARCHAR(255)
);

-- Governance Structure
CREATE TABLE governance_bodies (
    body_id INT PRIMARY KEY AUTO_INCREMENT,
    body_name VARCHAR(100) NOT NULL,
    body_type ENUM('Board', 'Executive', 'Supervisory', 'Advisory') NOT NULL,
    description TEXT
);

CREATE TABLE governance_members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    body_id INT,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(100),
    gender ENUM('Male', 'Female', 'Other', 'Not Disclosed'),
    start_date DATE,
    sustainability_expertise BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (body_id) REFERENCES governance_bodies(body_id)
);

CREATE TABLE board_meetings (
    meeting_id INT PRIMARY KEY AUTO_INCREMENT,
    body_id INT,
    meeting_date DATE NOT NULL,
    sustainability_topics_discussed TEXT,
    attendees INT,
    total_members INT,
    FOREIGN KEY (body_id) REFERENCES governance_bodies(body_id)
);

-- Employee and Workforce Data
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(50) UNIQUE,
    gender ENUM('Male', 'Female', 'Other', 'Not Disclosed'),
    age_group ENUM('Under 30', '30-50', 'Over 50'),
    country VARCHAR(100),
    region VARCHAR(100),
    contract_type ENUM('Permanent', 'Temporary', 'Part-time', 'Contractor'),
    department VARCHAR(100),
    hire_date DATE,
    termination_date DATE,
    salary_band VARCHAR(50),
    has_disability BOOLEAN DEFAULT FALSE
);

CREATE TABLE employee_training (
    training_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    training_type VARCHAR(100),
    training_category ENUM('Sustainability', 'Safety', 'Technical', 'Leadership', 'Compliance', 'Other'),
    hours DECIMAL(5,2),
    completion_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE workplace_incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_date DATE NOT NULL,
    incident_type ENUM('Injury', 'Near Miss', 'Environmental', 'Other'),
    severity ENUM('Minor', 'Moderate', 'Severe', 'Fatal'),
    location VARCHAR(255),
    description TEXT,
    lost_time_days INT DEFAULT 0
);

-- Environmental Data
CREATE TABLE facilities (
    facility_id INT PRIMARY KEY AUTO_INCREMENT,
    facility_name VARCHAR(255),
    facility_type ENUM('Manufacturing', 'Office', 'Warehouse', 'Retail', 'Data Center', 'Other'),
    country VARCHAR(100),
    region VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    near_protected_area BOOLEAN DEFAULT FALSE,
    water_stress_area BOOLEAN DEFAULT FALSE
);

CREATE TABLE energy_consumption (
    consumption_id INT PRIMARY KEY AUTO_INCREMENT,
    facility_id INT,
    year INT,
    month INT,
    energy_type ENUM('Electricity', 'Natural Gas', 'Oil', 'Coal', 'Solar', 'Wind', 'Hydro', 'Nuclear', 'Biomass', 'Other'),
    is_renewable BOOLEAN,
    consumption_mwh DECIMAL(12,3),
    cost_usd DECIMAL(12,2),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

CREATE TABLE ghg_emissions (
    emission_id INT PRIMARY KEY AUTO_INCREMENT,
    facility_id INT,
    year INT,
    month INT,
    scope ENUM('Scope 1', 'Scope 2', 'Scope 3'),
    emission_source VARCHAR(255),
    co2_tonnes DECIMAL(12,3),
    calculation_method VARCHAR(100),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

CREATE TABLE water_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    facility_id INT,
    year INT,
    month INT,
    water_source ENUM('Municipal', 'Groundwater', 'Surface Water', 'Rainwater', 'Recycled'),
    withdrawal_megaliters DECIMAL(12,3),
    discharge_megaliters DECIMAL(12,3),
    consumption_megaliters DECIMAL(12,3),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

CREATE TABLE waste_generation (
    waste_id INT PRIMARY KEY AUTO_INCREMENT,
    facility_id INT,
    year INT,
    month INT,
    waste_type ENUM('Hazardous', 'Non-hazardous', 'Recyclable', 'Organic'),
    disposal_method ENUM('Landfill', 'Incineration', 'Recycling', 'Composting', 'Recovery', 'Other'),
    quantity_tonnes DECIMAL(12,3),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

-- Supply Chain and Procurement
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(255),
    country VARCHAR(100),
    supplier_tier ENUM('Tier 1', 'Tier 2', 'Tier 3'),
    supplier_type ENUM('Raw Materials', 'Components', 'Services', 'Logistics', 'Other'),
    is_sme BOOLEAN DEFAULT FALSE,
    sustainability_certified BOOLEAN DEFAULT FALSE,
    certification_type VARCHAR(255)
);

CREATE TABLE supplier_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    invoice_date DATE,
    payment_date DATE,
    amount_usd DECIMAL(12,2),
    payment_terms_days INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE materials_sourced (
    material_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    material_name VARCHAR(255),
    material_category ENUM('Raw', 'Processed', 'Recycled', 'Bio-based'),
    is_renewable BOOLEAN,
    is_recycled BOOLEAN,
    quantity_tonnes DECIMAL(12,3),
    year INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Financial and Risk Data
CREATE TABLE financial_metrics (
    metric_id INT PRIMARY KEY AUTO_INCREMENT,
    year INT,
    quarter INT,
    revenue_usd DECIMAL(15,2),
    operating_expenses_usd DECIMAL(15,2),
    sustainability_investments_usd DECIMAL(12,2),
    carbon_tax_provision_usd DECIMAL(12,2),
    climate_risk_provision_usd DECIMAL(12,2)
);

CREATE TABLE sustainability_targets (
    target_id INT PRIMARY KEY AUTO_INCREMENT,
    target_category ENUM('Climate', 'Water', 'Waste', 'Biodiversity', 'Social', 'Governance'),
    target_name VARCHAR(255),
    target_description TEXT,
    baseline_year INT,
    baseline_value DECIMAL(12,3),
    target_year INT,
    target_value DECIMAL(12,3),
    unit_of_measure VARCHAR(50),
    current_value DECIMAL(12,3),
    last_updated DATE
);

-- Policies and Compliance
CREATE TABLE policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,
    policy_name VARCHAR(255),
    policy_category ENUM('Environmental', 'Social', 'Governance', 'Ethics', 'Supply Chain'),
    effective_date DATE,
    last_reviewed DATE,
    policy_text TEXT,
    applies_to_suppliers BOOLEAN DEFAULT FALSE
);

CREATE TABLE compliance_incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_date DATE,
    incident_type ENUM('Environmental', 'Labor', 'Anti-corruption', 'Data Privacy', 'Other'),
    description TEXT,
    fine_amount_usd DECIMAL(12,2),
    remediation_status ENUM('Open', 'In Progress', 'Resolved')
);

CREATE TABLE stakeholder_engagement (
    engagement_id INT PRIMARY KEY AUTO_INCREMENT,
    stakeholder_group ENUM('Employees', 'Investors', 'Customers', 'Communities', 'NGOs', 'Regulators'),
    engagement_date DATE,
    engagement_method ENUM('Survey', 'Meeting', 'Workshop', 'Consultation', 'Other'),
    topics_discussed TEXT,
    outcomes TEXT,
    participants INT
);

-- Executive Compensation
CREATE TABLE executive_compensation (
    comp_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    year INT,
    base_salary_usd DECIMAL(12,2),
    bonus_usd DECIMAL(12,2),
    sustainability_linked_bonus_usd DECIMAL(12,2),
    sustainability_kpi_description TEXT,
    FOREIGN KEY (member_id) REFERENCES governance_members(member_id)
);

-- Community Impact
CREATE TABLE community_projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(255),
    location VARCHAR(255),
    start_date DATE,
    end_date DATE,
    investment_usd DECIMAL(12,2),
    beneficiaries INT,
    project_type ENUM('Education', 'Health', 'Environment', 'Economic Development', 'Other'),
    description TEXT
);

-- Lobbying and Political Activities
CREATE TABLE lobbying_activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    year INT,
    organization_name VARCHAR(255),
    topic VARCHAR(255),
    amount_usd DECIMAL(12,2),
    activity_type ENUM('Direct Lobbying', 'Trade Association', 'Political Contribution', 'Other')
);

-- Product Safety and Quality
CREATE TABLE product_incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_date DATE,
    product_name VARCHAR(255),
    incident_type ENUM('Safety', 'Quality', 'Recall', 'Other'),
    affected_units INT,
    description TEXT,
    remediation_cost_usd DECIMAL(12,2)
);

-- Create indexes for better query performance
CREATE INDEX idx_emissions_year ON ghg_emissions(year);
CREATE INDEX idx_energy_year ON energy_consumption(year);
CREATE INDEX idx_employees_country ON employees(country);
CREATE INDEX idx_employees_gender ON employees(gender);
CREATE INDEX idx_facilities_country ON facilities(country);
CREATE INDEX idx_suppliers_country ON suppliers(country);
CREATE INDEX idx_meetings_date ON board_meetings(meeting_date);
CREATE INDEX idx_targets_category ON sustainability_targets(target_category);