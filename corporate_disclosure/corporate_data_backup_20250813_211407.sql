-- MySQL dump 10.13  Distrib 8.0.43, for Linux (aarch64)
--
-- Host: localhost    Database: corporate_data
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `board_meetings`
--

DROP TABLE IF EXISTS `board_meetings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_meetings` (
  `meeting_id` int NOT NULL AUTO_INCREMENT,
  `body_id` int DEFAULT NULL,
  `meeting_date` date NOT NULL,
  `sustainability_topics_discussed` text,
  `attendees` int DEFAULT NULL,
  `total_members` int DEFAULT NULL,
  PRIMARY KEY (`meeting_id`),
  KEY `body_id` (`body_id`),
  KEY `idx_meetings_date` (`meeting_date`),
  CONSTRAINT `board_meetings_ibfk_1` FOREIGN KEY (`body_id`) REFERENCES `governance_bodies` (`body_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_meetings`
--

LOCK TABLES `board_meetings` WRITE;
/*!40000 ALTER TABLE `board_meetings` DISABLE KEYS */;
INSERT INTO `board_meetings` VALUES (1,1,'2024-01-15','Annual sustainability strategy review, climate risk assessment, approval of 2030 emission targets',6,6),(2,1,'2024-03-20','Q1 ESG performance review, supply chain sustainability audit results',5,6),(3,1,'2024-06-18','Climate scenario analysis, renewable energy transition plan, diversity metrics review',6,6),(4,1,'2024-09-22','CSRD readiness assessment, sustainability-linked financing options',6,6),(5,1,'2024-12-10','Annual ESG report approval, 2025 sustainability budget allocation',5,6),(6,3,'2024-02-05','Detailed review of Scope 3 emissions methodology',3,3),(7,3,'2024-05-15','Biodiversity impact assessment for new data center',3,3),(8,3,'2024-08-20','Circular economy initiatives progress review',3,3),(9,3,'2024-11-10','Human rights due diligence in supply chain',3,3);
/*!40000 ALTER TABLE `board_meetings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community_projects`
--

DROP TABLE IF EXISTS `community_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_projects` (
  `project_id` int NOT NULL AUTO_INCREMENT,
  `project_name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `investment_usd` decimal(12,2) DEFAULT NULL,
  `beneficiaries` int DEFAULT NULL,
  `project_type` enum('Education','Health','Environment','Economic Development','Other') DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community_projects`
--

LOCK TABLES `community_projects` WRITE;
/*!40000 ALTER TABLE `community_projects` DISABLE KEYS */;
INSERT INTO `community_projects` VALUES (1,'Digital Skills Academy','Munich, Germany','2023-09-01','2024-08-31',250000.00,500,'Education','Free coding bootcamp for unemployed youth'),(2,'Clean River Initiative','Bangalore, India','2024-01-01','2024-12-31',150000.00,5000,'Environment','River cleanup and community awareness program'),(3,'Tech for Good Hackathon','Multiple Locations','2024-03-15','2024-03-17',75000.00,300,'Other','Hackathon focused on sustainability solutions');
/*!40000 ALTER TABLE `community_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `headquarters_country` varchar(100) DEFAULT NULL,
  `industry_sector` varchar(100) DEFAULT NULL,
  `founded_year` int DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'TechCorp Global Solutions','Germany','Information Technology',1998,'www.techcorp-global.com');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compliance_incidents`
--

DROP TABLE IF EXISTS `compliance_incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compliance_incidents` (
  `incident_id` int NOT NULL AUTO_INCREMENT,
  `incident_date` date DEFAULT NULL,
  `incident_type` enum('Environmental','Labor','Anti-corruption','Data Privacy','Other') DEFAULT NULL,
  `description` text,
  `fine_amount_usd` decimal(12,2) DEFAULT NULL,
  `remediation_status` enum('Open','In Progress','Resolved') DEFAULT NULL,
  PRIMARY KEY (`incident_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compliance_incidents`
--

LOCK TABLES `compliance_incidents` WRITE;
/*!40000 ALTER TABLE `compliance_incidents` DISABLE KEYS */;
INSERT INTO `compliance_incidents` VALUES (1,'2024-02-15','Data Privacy','Minor GDPR violation - late data deletion request',15000.00,'Resolved');
/*!40000 ALTER TABLE `compliance_incidents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_training`
--

DROP TABLE IF EXISTS `employee_training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_training` (
  `training_id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int DEFAULT NULL,
  `training_type` varchar(100) DEFAULT NULL,
  `training_category` enum('Sustainability','Safety','Technical','Leadership','Compliance','Other') DEFAULT NULL,
  `hours` decimal(5,2) DEFAULT NULL,
  `completion_date` date DEFAULT NULL,
  PRIMARY KEY (`training_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `employee_training_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_training`
--

LOCK TABLES `employee_training` WRITE;
/*!40000 ALTER TABLE `employee_training` DISABLE KEYS */;
INSERT INTO `employee_training` VALUES (1,1,'Climate Risk Management','Sustainability',16.00,'2024-02-15'),(2,1,'Advanced Python Programming','Technical',40.00,'2024-05-20'),(3,2,'ESG Reporting Standards','Sustainability',24.00,'2024-03-10'),(4,2,'Leadership Excellence','Leadership',32.00,'2024-07-15'),(5,3,'Cybersecurity Fundamentals','Technical',20.00,'2024-01-20'),(6,4,'IFRS Updates','Compliance',16.00,'2024-04-05'),(7,5,'Digital Marketing Strategies','Other',24.00,'2024-06-10'),(8,6,'Safety in the Workplace','Safety',8.00,'2024-01-30'),(9,7,'Diversity and Inclusion','Other',12.00,'2024-02-28'),(10,8,'Machine Learning Basics','Technical',40.00,'2024-08-15'),(11,10,'Accessibility in Design','Technical',16.00,'2024-03-25'),(12,11,'Renewable Energy Technologies','Sustainability',20.00,'2024-04-15'),(13,12,'Agile Methodologies','Technical',24.00,'2024-09-10'),(14,15,'Anti-Corruption Compliance','Compliance',8.00,'2024-02-20');
/*!40000 ALTER TABLE `employee_training` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `employee_code` varchar(50) DEFAULT NULL,
  `gender` enum('Male','Female','Other','Not Disclosed') DEFAULT NULL,
  `age_group` enum('Under 30','30-50','Over 50') DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `contract_type` enum('Permanent','Temporary','Part-time','Contractor') DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `termination_date` date DEFAULT NULL,
  `salary_band` varchar(50) DEFAULT NULL,
  `has_disability` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  KEY `idx_employees_country` (`country`),
  KEY `idx_employees_gender` (`gender`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'DE001','Male','30-50','Germany','Europe','Permanent','Engineering','2019-01-15',NULL,'Senior',0),(2,'DE002','Female','30-50','Germany','Europe','Permanent','Management','2018-03-01',NULL,'Executive',0),(3,'DE003','Male','Under 30','Germany','Europe','Permanent','Engineering','2022-06-01',NULL,'Junior',0),(4,'DE004','Female','30-50','Germany','Europe','Permanent','Finance','2020-09-15',NULL,'Senior',1),(5,'DE005','Other','Under 30','Germany','Europe','Temporary','Marketing','2023-01-10',NULL,'Junior',0),(6,'DE006','Male','Over 50','Germany','Europe','Permanent','Sales','2015-04-20',NULL,'Senior',0),(7,'DE007','Female','30-50','Germany','Europe','Part-time','HR','2021-02-15',NULL,'Mid',0),(8,'DE008','Male','30-50','Germany','Europe','Permanent','Engineering','2019-11-01',NULL,'Senior',0),(9,'DE009','Female','Under 30','Germany','Europe','Contractor','IT Support','2023-06-01',NULL,'Junior',0),(10,'DE010','Male','30-50','Germany','Europe','Permanent','Product','2020-01-15',NULL,'Senior',1),(11,'ES001','Female','30-50','Spain','Europe','Permanent','Research','2020-03-01',NULL,'Senior',0),(12,'ES002','Male','Under 30','Spain','Europe','Temporary','Engineering','2023-09-01',NULL,'Junior',0),(13,'ES003','Female','30-50','Spain','Europe','Permanent','Design','2019-05-15',NULL,'Mid',0),(14,'ES004','Male','Over 50','Spain','Europe','Permanent','Management','2016-01-20',NULL,'Executive',0),(15,'ES005','Female','Under 30','Spain','Europe','Permanent','Marketing','2022-07-01',NULL,'Junior',1),(16,'PL001','Male','30-50','Poland','Europe','Permanent','Engineering','2018-06-15',NULL,'Senior',0),(17,'PL002','Female','Under 30','Poland','Europe','Permanent','QA','2022-03-01',NULL,'Junior',0),(18,'PL003','Male','30-50','Poland','Europe','Permanent','Engineering','2019-09-01',NULL,'Mid',0),(19,'PL004','Female','30-50','Poland','Europe','Permanent','Product','2020-01-10',NULL,'Senior',0),(20,'PL005','Male','Under 30','Poland','Europe','Contractor','IT Support','2023-02-15',NULL,'Junior',0),(21,'IN001','Male','30-50','India','Asia','Permanent','Engineering','2019-04-01',NULL,'Senior',0),(22,'IN002','Female','Under 30','India','Asia','Permanent','Engineering','2022-08-15',NULL,'Junior',0),(23,'IN003','Male','30-50','India','Asia','Permanent','Support','2020-11-01',NULL,'Mid',1),(24,'IN004','Female','30-50','India','Asia','Permanent','Finance','2018-02-20',NULL,'Senior',0),(25,'IN005','Male','Under 30','India','Asia','Temporary','Marketing','2023-05-01',NULL,'Junior',0),(26,'CN001','Female','30-50','China','Asia','Permanent','Sales','2019-07-15',NULL,'Senior',0),(27,'CN002','Male','Under 30','China','Asia','Permanent','Engineering','2023-01-20',NULL,'Junior',0),(28,'CN003','Female','30-50','China','Asia','Permanent','Operations','2020-05-10',NULL,'Mid',0),(29,'CN004','Male','Over 50','China','Asia','Permanent','Management','2017-03-01',NULL,'Executive',0),(30,'CN005','Female','Under 30','China','Asia','Contractor','Design','2023-08-15',NULL,'Junior',0),(31,'US001','Male','30-50','USA','Americas','Permanent','Sales','2020-09-01',NULL,'Senior',0),(32,'US002','Female','30-50','USA','Americas','Permanent','Business Dev','2019-01-15',NULL,'Executive',0),(33,'US003','Other','Under 30','USA','Americas','Permanent','Engineering','2022-06-20',NULL,'Mid',0),(34,'US004','Male','Over 50','USA','Americas','Permanent','Legal','2018-04-10',NULL,'Executive',1),(35,'US005','Female','Under 30','USA','Americas','Temporary','Marketing','2023-03-01',NULL,'Junior',0);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `energy_consumption`
--

DROP TABLE IF EXISTS `energy_consumption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `energy_consumption` (
  `consumption_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `month` int DEFAULT NULL,
  `energy_type` enum('Electricity','Natural Gas','Oil','Coal','Solar','Wind','Hydro','Nuclear','Biomass','Other') DEFAULT NULL,
  `is_renewable` tinyint(1) DEFAULT NULL,
  `consumption_mwh` decimal(12,3) DEFAULT NULL,
  `cost_usd` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`consumption_id`),
  KEY `facility_id` (`facility_id`),
  KEY `idx_energy_year` (`year`),
  CONSTRAINT `energy_consumption_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `energy_consumption`
--

LOCK TABLES `energy_consumption` WRITE;
/*!40000 ALTER TABLE `energy_consumption` DISABLE KEYS */;
INSERT INTO `energy_consumption` VALUES (1,1,2024,1,'Electricity',0,450.500,67575.00),(2,1,2024,1,'Natural Gas',0,320.000,28800.00),(3,1,2024,1,'Solar',1,45.000,0.00),(4,1,2024,2,'Electricity',0,420.000,63000.00),(5,1,2024,2,'Natural Gas',0,280.000,25200.00),(6,1,2024,2,'Solar',1,52.000,0.00),(7,2,2024,1,'Electricity',0,2800.000,420000.00),(8,2,2024,1,'Wind',1,1200.000,156000.00),(9,2,2024,2,'Electricity',0,2750.000,412500.00),(10,2,2024,2,'Wind',1,1250.000,162500.00),(11,3,2024,1,'Electricity',0,180.000,32400.00),(12,3,2024,1,'Solar',1,60.000,0.00),(13,3,2024,2,'Electricity',0,170.000,30600.00),(14,3,2024,2,'Solar',1,70.000,0.00),(15,4,2024,1,'Electricity',0,220.000,26400.00),(16,4,2024,1,'Natural Gas',0,150.000,12000.00),(17,5,2024,1,'Electricity',0,380.000,34200.00),(18,6,2024,1,'Electricity',0,290.000,29000.00),(19,7,2024,1,'Electricity',0,200.000,40000.00),(20,8,2024,1,'Electricity',0,2200.000,308000.00),(21,8,2024,1,'Wind',1,800.000,96000.00);
/*!40000 ALTER TABLE `energy_consumption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `executive_compensation`
--

DROP TABLE IF EXISTS `executive_compensation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `executive_compensation` (
  `comp_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `base_salary_usd` decimal(12,2) DEFAULT NULL,
  `bonus_usd` decimal(12,2) DEFAULT NULL,
  `sustainability_linked_bonus_usd` decimal(12,2) DEFAULT NULL,
  `sustainability_kpi_description` text,
  PRIMARY KEY (`comp_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `executive_compensation_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `governance_members` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `executive_compensation`
--

LOCK TABLES `executive_compensation` WRITE;
/*!40000 ALTER TABLE `executive_compensation` DISABLE KEYS */;
INSERT INTO `executive_compensation` VALUES (1,7,2024,850000.00,425000.00,127500.00,'30% of bonus linked to ESG targets: emissions reduction, diversity metrics'),(2,8,2024,550000.00,220000.00,55000.00,'25% of bonus linked to ESG targets: financial sustainability metrics'),(3,9,2024,480000.00,192000.00,38400.00,'20% of bonus linked to technology innovation for sustainability'),(4,10,2024,450000.00,180000.00,90000.00,'50% of bonus linked to achieving sustainability targets'),(5,11,2024,500000.00,200000.00,40000.00,'20% of bonus linked to operational efficiency and emissions');
/*!40000 ALTER TABLE `executive_compensation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facilities` (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(255) DEFAULT NULL,
  `facility_type` enum('Manufacturing','Office','Warehouse','Retail','Data Center','Other') DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `near_protected_area` tinyint(1) DEFAULT '0',
  `water_stress_area` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`facility_id`),
  KEY `idx_facilities_country` (`country`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES (1,'Munich Headquarters','Office','Germany','Europe',48.13510000,11.58200000,0,0),(2,'Frankfurt Data Center','Data Center','Germany','Europe',50.11090000,8.68210000,0,0),(3,'Barcelona Innovation Lab','Office','Spain','Europe',41.38510000,2.17340000,1,1),(4,'Warsaw Development Center','Office','Poland','Europe',52.22970000,21.01220000,0,0),(5,'Bangalore Tech Hub','Office','India','Asia',12.97160000,77.59460000,0,1),(6,'Shanghai Operations','Office','China','Asia',31.23040000,121.47370000,0,1),(7,'Austin Campus','Office','USA','Americas',30.26720000,-97.74310000,0,1),(8,'Dublin Data Center','Data Center','Ireland','Europe',53.34980000,-6.26030000,0,0);
/*!40000 ALTER TABLE `facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_metrics`
--

DROP TABLE IF EXISTS `financial_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_metrics` (
  `metric_id` int NOT NULL AUTO_INCREMENT,
  `year` int DEFAULT NULL,
  `quarter` int DEFAULT NULL,
  `revenue_usd` decimal(15,2) DEFAULT NULL,
  `operating_expenses_usd` decimal(15,2) DEFAULT NULL,
  `sustainability_investments_usd` decimal(12,2) DEFAULT NULL,
  `carbon_tax_provision_usd` decimal(12,2) DEFAULT NULL,
  `climate_risk_provision_usd` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`metric_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_metrics`
--

LOCK TABLES `financial_metrics` WRITE;
/*!40000 ALTER TABLE `financial_metrics` DISABLE KEYS */;
INSERT INTO `financial_metrics` VALUES (1,2023,1,125000000.00,95000000.00,2500000.00,500000.00,1000000.00),(2,2023,2,132000000.00,98000000.00,2800000.00,520000.00,1100000.00),(3,2023,3,128000000.00,96000000.00,3000000.00,550000.00,1200000.00),(4,2023,4,145000000.00,105000000.00,3500000.00,600000.00,1500000.00),(5,2024,1,138000000.00,102000000.00,4000000.00,650000.00,1800000.00);
/*!40000 ALTER TABLE `financial_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ghg_emissions`
--

DROP TABLE IF EXISTS `ghg_emissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ghg_emissions` (
  `emission_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `month` int DEFAULT NULL,
  `scope` enum('Scope 1','Scope 2','Scope 3') DEFAULT NULL,
  `emission_source` varchar(255) DEFAULT NULL,
  `co2_tonnes` decimal(12,3) DEFAULT NULL,
  `calculation_method` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`emission_id`),
  KEY `facility_id` (`facility_id`),
  KEY `idx_emissions_year` (`year`),
  CONSTRAINT `ghg_emissions_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ghg_emissions`
--

LOCK TABLES `ghg_emissions` WRITE;
/*!40000 ALTER TABLE `ghg_emissions` DISABLE KEYS */;
INSERT INTO `ghg_emissions` VALUES (1,1,2024,1,'Scope 1','Natural Gas Heating',57.600,'IPCC Emission Factors'),(2,1,2024,2,'Scope 1','Natural Gas Heating',50.400,'IPCC Emission Factors'),(3,2,2024,1,'Scope 1','Backup Generators',12.500,'Fuel Consumption Records'),(4,2,2024,2,'Scope 1','Backup Generators',8.300,'Fuel Consumption Records'),(5,1,2024,1,'Scope 1','Company Vehicles',15.200,'Fuel Consumption Records'),(6,1,2024,1,'Scope 2','Purchased Electricity',180.200,'Location-based'),(7,1,2024,2,'Scope 2','Purchased Electricity',168.000,'Location-based'),(8,2,2024,1,'Scope 2','Purchased Electricity',1120.000,'Location-based'),(9,2,2024,2,'Scope 2','Purchased Electricity',1100.000,'Location-based'),(10,3,2024,1,'Scope 2','Purchased Electricity',90.000,'Location-based'),(11,3,2024,2,'Scope 2','Purchased Electricity',85.000,'Location-based'),(12,1,2024,1,'Scope 3','Business Travel',125.500,'Spend-based Method'),(13,1,2024,2,'Scope 3','Business Travel',142.300,'Spend-based Method'),(14,1,2024,1,'Scope 3','Employee Commuting',89.200,'Average-data Method'),(15,1,2024,2,'Scope 3','Employee Commuting',87.500,'Average-data Method'),(16,1,2024,1,'Scope 3','Purchased Goods',450.000,'Spend-based Method');
/*!40000 ALTER TABLE `ghg_emissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `governance_bodies`
--

DROP TABLE IF EXISTS `governance_bodies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `governance_bodies` (
  `body_id` int NOT NULL AUTO_INCREMENT,
  `body_name` varchar(100) NOT NULL,
  `body_type` enum('Board','Executive','Supervisory','Advisory') NOT NULL,
  `description` text,
  PRIMARY KEY (`body_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `governance_bodies`
--

LOCK TABLES `governance_bodies` WRITE;
/*!40000 ALTER TABLE `governance_bodies` DISABLE KEYS */;
INSERT INTO `governance_bodies` VALUES (1,'Board of Directors','Board','Main governing body responsible for strategic oversight'),(2,'Executive Committee','Executive','Senior leadership team responsible for day-to-day operations'),(3,'Sustainability Committee','Advisory','Advisory committee focused on ESG matters'),(4,'Audit Committee','Supervisory','Oversees financial reporting and risk management');
/*!40000 ALTER TABLE `governance_bodies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `governance_members`
--

DROP TABLE IF EXISTS `governance_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `governance_members` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `body_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `position` varchar(100) DEFAULT NULL,
  `gender` enum('Male','Female','Other','Not Disclosed') DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `sustainability_expertise` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`member_id`),
  KEY `body_id` (`body_id`),
  CONSTRAINT `governance_members_ibfk_1` FOREIGN KEY (`body_id`) REFERENCES `governance_bodies` (`body_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `governance_members`
--

LOCK TABLES `governance_members` WRITE;
/*!40000 ALTER TABLE `governance_members` DISABLE KEYS */;
INSERT INTO `governance_members` VALUES (1,1,'Maria Schmidt','Board Chair','Female','2019-01-15',1),(2,1,'James Chen','Independent Director','Male','2020-03-01',0),(3,1,'Fatima Al-Rashid','Independent Director','Female','2021-06-15',1),(4,1,'Robert Johnson','CEO & Director','Male','2018-01-01',0),(5,1,'Elena Volkov','Independent Director','Female','2022-01-01',1),(6,1,'Thomas Mueller','Independent Director','Male','2020-09-01',0),(7,2,'Robert Johnson','Chief Executive Officer','Male','2018-01-01',0),(8,2,'Sarah Williams','Chief Financial Officer','Female','2019-04-01',0),(9,2,'Raj Patel','Chief Technology Officer','Male','2017-06-01',0),(10,2,'Lisa Anderson','Chief Sustainability Officer','Female','2021-01-01',1),(11,2,'Michael Zhang','Chief Operating Officer','Male','2020-02-01',0),(12,3,'Lisa Anderson','Committee Chair','Female','2021-01-01',1),(13,3,'Maria Schmidt','Board Representative','Female','2021-01-01',1),(14,3,'Dr. Emma Green','External Advisor','Female','2021-06-01',1);
/*!40000 ALTER TABLE `governance_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lobbying_activities`
--

DROP TABLE IF EXISTS `lobbying_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lobbying_activities` (
  `activity_id` int NOT NULL AUTO_INCREMENT,
  `year` int DEFAULT NULL,
  `organization_name` varchar(255) DEFAULT NULL,
  `topic` varchar(255) DEFAULT NULL,
  `amount_usd` decimal(12,2) DEFAULT NULL,
  `activity_type` enum('Direct Lobbying','Trade Association','Political Contribution','Other') DEFAULT NULL,
  PRIMARY KEY (`activity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lobbying_activities`
--

LOCK TABLES `lobbying_activities` WRITE;
/*!40000 ALTER TABLE `lobbying_activities` DISABLE KEYS */;
INSERT INTO `lobbying_activities` VALUES (1,2024,'Tech Industry Association Europe','Digital Services Act Implementation',50000.00,'Trade Association'),(2,2024,'Sustainable Business Coalition','EU Green Deal Support',35000.00,'Trade Association'),(3,2024,'Direct EU Engagement','AI Act Consultation',25000.00,'Direct Lobbying');
/*!40000 ALTER TABLE `lobbying_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materials_sourced`
--

DROP TABLE IF EXISTS `materials_sourced`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materials_sourced` (
  `material_id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `material_category` enum('Raw','Processed','Recycled','Bio-based') DEFAULT NULL,
  `is_renewable` tinyint(1) DEFAULT NULL,
  `is_recycled` tinyint(1) DEFAULT NULL,
  `quantity_tonnes` decimal(12,3) DEFAULT NULL,
  `year` int DEFAULT NULL,
  PRIMARY KEY (`material_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `materials_sourced_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materials_sourced`
--

LOCK TABLES `materials_sourced` WRITE;
/*!40000 ALTER TABLE `materials_sourced` DISABLE KEYS */;
/*!40000 ALTER TABLE `materials_sourced` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `policies`
--

DROP TABLE IF EXISTS `policies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `policies` (
  `policy_id` int NOT NULL AUTO_INCREMENT,
  `policy_name` varchar(255) DEFAULT NULL,
  `policy_category` enum('Environmental','Social','Governance','Ethics','Supply Chain') DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `last_reviewed` date DEFAULT NULL,
  `policy_text` text,
  `applies_to_suppliers` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`policy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `policies`
--

LOCK TABLES `policies` WRITE;
/*!40000 ALTER TABLE `policies` DISABLE KEYS */;
INSERT INTO `policies` VALUES (1,'Environmental Management Policy','Environmental','2022-01-01','2024-01-15','Comprehensive policy outlining our commitment to environmental protection...',1),(2,'Code of Business Conduct','Ethics','2021-06-01','2023-12-01','Our code of conduct establishes ethical standards for all employees...',1),(3,'Human Rights Policy','Social','2022-07-01','2024-02-01','We respect and support human rights as outlined in the UN Declaration...',1),(4,'Anti-Corruption Policy','Governance','2021-01-01','2023-11-15','Zero tolerance for corruption, bribery, and unethical business practices...',1),(5,'Diversity & Inclusion Policy','Social','2023-01-01','2024-01-01','Commitment to creating an inclusive workplace that values diversity...',0),(6,'Data Privacy Policy','Governance','2021-05-25','2023-05-25','Ensuring protection of personal data in compliance with GDPR...',1),(7,'Sustainable Procurement Policy','Supply Chain','2023-04-01','2024-04-01','Guidelines for sustainable and ethical sourcing practices...',1);
/*!40000 ALTER TABLE `policies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_incidents`
--

DROP TABLE IF EXISTS `product_incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_incidents` (
  `incident_id` int NOT NULL AUTO_INCREMENT,
  `incident_date` date DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `incident_type` enum('Safety','Quality','Recall','Other') DEFAULT NULL,
  `affected_units` int DEFAULT NULL,
  `description` text,
  `remediation_cost_usd` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`incident_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_incidents`
--

LOCK TABLES `product_incidents` WRITE;
/*!40000 ALTER TABLE `product_incidents` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_incidents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stakeholder_engagement`
--

DROP TABLE IF EXISTS `stakeholder_engagement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stakeholder_engagement` (
  `engagement_id` int NOT NULL AUTO_INCREMENT,
  `stakeholder_group` enum('Employees','Investors','Customers','Communities','NGOs','Regulators') DEFAULT NULL,
  `engagement_date` date DEFAULT NULL,
  `engagement_method` enum('Survey','Meeting','Workshop','Consultation','Other') DEFAULT NULL,
  `topics_discussed` text,
  `outcomes` text,
  `participants` int DEFAULT NULL,
  PRIMARY KEY (`engagement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stakeholder_engagement`
--

LOCK TABLES `stakeholder_engagement` WRITE;
/*!40000 ALTER TABLE `stakeholder_engagement` DISABLE KEYS */;
INSERT INTO `stakeholder_engagement` VALUES (1,'Investors','2024-01-25','Meeting','ESG strategy, climate risks, CSRD readiness','Positive feedback on sustainability targets',25),(2,'Employees','2024-02-15','Survey','Workplace satisfaction, sustainability awareness','78% engagement rate, identified training needs',450),(3,'Communities','2024-03-10','Workshop','Local environmental impacts, job opportunities','Partnership on skills training program',50),(4,'NGOs','2024-03-20','Consultation','Supply chain transparency, human rights','Agreement on third-party audit program',8);
/*!40000 ALTER TABLE `stakeholder_engagement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_transactions`
--

DROP TABLE IF EXISTS `supplier_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `amount_usd` decimal(12,2) DEFAULT NULL,
  `payment_terms_days` int DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `supplier_transactions_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_transactions`
--

LOCK TABLES `supplier_transactions` WRITE;
/*!40000 ALTER TABLE `supplier_transactions` DISABLE KEYS */;
INSERT INTO `supplier_transactions` VALUES (1,1,'2024-01-15','2024-02-14',125000.00,30),(2,1,'2024-02-15','2024-03-16',128000.00,30),(3,2,'2024-01-10','2024-01-25',45000.00,15),(4,3,'2024-01-20','2024-03-05',89000.00,45),(5,4,'2024-01-25','2024-02-24',23000.00,30),(6,5,'2024-01-05','2024-01-12',8500.00,7),(7,6,'2024-02-01','2024-03-15',35000.00,45),(8,7,'2024-01-30','2024-04-15',156000.00,75),(9,8,'2024-02-10','2024-02-20',12000.00,10),(10,9,'2024-01-18','2024-02-28',67000.00,45),(11,10,'2024-01-22','2024-01-29',4500.00,7);
/*!40000 ALTER TABLE `supplier_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(255) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `supplier_tier` enum('Tier 1','Tier 2','Tier 3') DEFAULT NULL,
  `supplier_type` enum('Raw Materials','Components','Services','Logistics','Other') DEFAULT NULL,
  `is_sme` tinyint(1) DEFAULT '0',
  `sustainability_certified` tinyint(1) DEFAULT '0',
  `certification_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`supplier_id`),
  KEY `idx_suppliers_country` (`country`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'CloudTech Infrastructure','USA','Tier 1','Services',0,1,'ISO 14001'),(2,'GreenPower Solutions','Germany','Tier 1','Services',1,1,'RE100'),(3,'TechComponents Asia','Taiwan','Tier 1','Components',0,0,NULL),(4,'SecureLogistics EU','Netherlands','Tier 1','Logistics',0,1,'ISO 14001'),(5,'EcoClean Services','Germany','Tier 1','Services',1,1,'EMAS'),(6,'DataSafe Backup','Ireland','Tier 1','Services',1,0,NULL),(7,'Innovation Materials','China','Tier 2','Raw Materials',0,0,NULL),(8,'Sustainable Packaging Co','Sweden','Tier 1','Components',1,1,'FSC'),(9,'GlobalTech Supplies','India','Tier 1','Components',0,1,'ISO 45001'),(10,'LocalIT Support','Germany','Tier 1','Services',1,0,NULL);
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sustainability_targets`
--

DROP TABLE IF EXISTS `sustainability_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sustainability_targets` (
  `target_id` int NOT NULL AUTO_INCREMENT,
  `target_category` enum('Climate','Water','Waste','Biodiversity','Social','Governance') DEFAULT NULL,
  `target_name` varchar(255) DEFAULT NULL,
  `target_description` text,
  `baseline_year` int DEFAULT NULL,
  `baseline_value` decimal(12,3) DEFAULT NULL,
  `target_year` int DEFAULT NULL,
  `target_value` decimal(12,3) DEFAULT NULL,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `current_value` decimal(12,3) DEFAULT NULL,
  `last_updated` date DEFAULT NULL,
  PRIMARY KEY (`target_id`),
  KEY `idx_targets_category` (`target_category`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sustainability_targets`
--

LOCK TABLES `sustainability_targets` WRITE;
/*!40000 ALTER TABLE `sustainability_targets` DISABLE KEYS */;
INSERT INTO `sustainability_targets` VALUES (1,'Climate','Scope 1+2 GHG Reduction','Reduce absolute Scope 1 and 2 emissions by 50%',2020,25000.000,2030,12500.000,'tCO2e',18500.000,'2024-03-31'),(2,'Climate','100% Renewable Electricity','Source 100% renewable electricity for all operations',2020,25.000,2025,100.000,'Percentage',45.000,'2024-03-31'),(3,'Water','Water Consumption Reduction','Reduce water consumption intensity by 30%',2020,2.500,2030,1.750,'ML per FTE',2.100,'2024-03-31'),(4,'Waste','Zero Waste to Landfill','Achieve zero waste to landfill across all facilities',2020,35.000,2025,0.000,'Percentage to landfill',18.000,'2024-03-31'),(5,'Social','Gender Balance','Achieve 40% female representation in management',2020,28.000,2025,40.000,'Percentage',33.000,'2024-03-31'),(6,'Social','Employee Training','Average 40 hours training per employee per year',2020,20.000,2025,40.000,'Hours',28.000,'2024-03-31'),(7,'Governance','Supplier Sustainability','80% of suppliers by spend with sustainability certification',2022,45.000,2025,80.000,'Percentage',62.000,'2024-03-31');
/*!40000 ALTER TABLE `sustainability_targets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waste_generation`
--

DROP TABLE IF EXISTS `waste_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waste_generation` (
  `waste_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `month` int DEFAULT NULL,
  `waste_type` enum('Hazardous','Non-hazardous','Recyclable','Organic') DEFAULT NULL,
  `disposal_method` enum('Landfill','Incineration','Recycling','Composting','Recovery','Other') DEFAULT NULL,
  `quantity_tonnes` decimal(12,3) DEFAULT NULL,
  PRIMARY KEY (`waste_id`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `waste_generation_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waste_generation`
--

LOCK TABLES `waste_generation` WRITE;
/*!40000 ALTER TABLE `waste_generation` DISABLE KEYS */;
INSERT INTO `waste_generation` VALUES (1,1,2024,1,'Non-hazardous','Recycling',8.500),(2,1,2024,1,'Non-hazardous','Landfill',2.300),(3,1,2024,1,'Hazardous','Recovery',0.500),(4,2,2024,1,'Non-hazardous','Recycling',15.200),(5,2,2024,1,'Hazardous','Recovery',2.100),(6,3,2024,1,'Non-hazardous','Recycling',3.200),(7,3,2024,1,'Organic','Composting',0.800);
/*!40000 ALTER TABLE `waste_generation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `water_usage`
--

DROP TABLE IF EXISTS `water_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `water_usage` (
  `usage_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `month` int DEFAULT NULL,
  `water_source` enum('Municipal','Groundwater','Surface Water','Rainwater','Recycled') DEFAULT NULL,
  `withdrawal_megaliters` decimal(12,3) DEFAULT NULL,
  `discharge_megaliters` decimal(12,3) DEFAULT NULL,
  `consumption_megaliters` decimal(12,3) DEFAULT NULL,
  PRIMARY KEY (`usage_id`),
  KEY `facility_id` (`facility_id`),
  CONSTRAINT `water_usage_ibfk_1` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `water_usage`
--

LOCK TABLES `water_usage` WRITE;
/*!40000 ALTER TABLE `water_usage` DISABLE KEYS */;
INSERT INTO `water_usage` VALUES (1,1,2024,1,'Municipal',2.500,2.200,0.300),(2,1,2024,2,'Municipal',2.300,2.000,0.300),(3,2,2024,1,'Municipal',8.500,7.800,0.700),(4,2,2024,2,'Municipal',8.200,7.500,0.700),(5,3,2024,1,'Municipal',1.200,1.000,0.200),(6,3,2024,1,'Rainwater',0.300,0.000,0.300),(7,5,2024,1,'Municipal',3.500,3.000,0.500),(8,6,2024,1,'Municipal',2.800,2.400,0.400),(9,7,2024,1,'Municipal',1.800,1.500,0.300);
/*!40000 ALTER TABLE `water_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workplace_incidents`
--

DROP TABLE IF EXISTS `workplace_incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workplace_incidents` (
  `incident_id` int NOT NULL AUTO_INCREMENT,
  `incident_date` date NOT NULL,
  `incident_type` enum('Injury','Near Miss','Environmental','Other') DEFAULT NULL,
  `severity` enum('Minor','Moderate','Severe','Fatal') DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `description` text,
  `lost_time_days` int DEFAULT '0',
  PRIMARY KEY (`incident_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workplace_incidents`
--

LOCK TABLES `workplace_incidents` WRITE;
/*!40000 ALTER TABLE `workplace_incidents` DISABLE KEYS */;
INSERT INTO `workplace_incidents` VALUES (1,'2024-01-15','Injury','Minor','Munich Headquarters','Slip and fall in parking lot',2),(2,'2024-02-20','Near Miss','Minor','Frankfurt Data Center','Near miss with electrical equipment',0),(3,'2024-03-10','Injury','Moderate','Warsaw Development Center','Ergonomic injury from workstation',5);
/*!40000 ALTER TABLE `workplace_incidents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-14  2:14:07
