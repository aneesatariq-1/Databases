
DROP DATABASE IF EXISTS bid_management;
CREATE DATABASE bid_management;
USE bid_management;


-- 1. Person
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Street VARCHAR(100),
    City VARCHAR(50)
);

-- 2. Supplier
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(100),
    TaxID VARCHAR(50),
    Certification VARCHAR(100),
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- 3. Bidder
CREATE TABLE Bidder (
    BidderID INT PRIMARY KEY,
    LicenseNumber VARCHAR(50),
    ExperienceYears INT,
    ProjectsHandled VARCHAR(200),
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- 4. Department
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Building VARCHAR(50),
    Floor VARCHAR(20),
    Phone VARCHAR(20)
);

-- 5. Manager
CREATE TABLE Manager (
    ManagerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    DepartmentID INT,
    ContactNo VARCHAR(20),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- 6. Tender
CREATE TABLE Tender (
    TenderID INT PRIMARY KEY,
    Title VARCHAR(100),
    Description TEXT,
    Deadline DATE,
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID)
);

-- 7. Bid
CREATE TABLE Bid (
    BidID INT PRIMARY KEY,
    BidAmount DECIMAL(10, 2),
    BidDate DATE,
    SupplierID INT,
    TenderID INT,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (TenderID) REFERENCES Tender(TenderID)
);

-- 8. Evaluation (Weak Entity)
CREATE TABLE Evaluation (
    EvaluationID INT,
    TenderID INT,
    SupplierID INT,
    Score DECIMAL(5,2),
    EvaluatorName VARCHAR(100),
    PRIMARY KEY (EvaluationID, TenderID, SupplierID),
    FOREIGN KEY (TenderID) REFERENCES Tender(TenderID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- 9. Project
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    Title VARCHAR(100),
    DepartmentID INT,
    BudgetEstimate DECIMAL(12,2),
    RiskFactor VARCHAR(50),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- 10. Payment (Weak Entity)
CREATE TABLE Payment (
    PaymentID INT,
    SupplierID INT,
    ProjectID INT,
    Amount DECIMAL(10,2),
    Status VARCHAR(20),
    PRIMARY KEY (PaymentID, SupplierID, ProjectID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);
-- Person Table
INSERT INTO Person VALUES
(1, 'Ali Raza', 'ali@gmail.com', '03001234567', 'Main Road', 'Karachi'),
(2, 'Sara Khan', 'sara@company.com', '03211234567', 'College Road', 'Lahore'),
(3, 'Usman Tariq', 'usman@gmail.com', '03007894561', 'Market Street', 'Islamabad'),
(4, 'Areeba Malik', 'areeba@yahoo.com', '03331112222', 'Garden Town', 'Lahore'),
(5, 'Bilal Hussain', 'bilal@outlook.com', '03123456789', 'F10 Markaz', 'Islamabad'),
(6, 'Zara Ahmed', 'zara@gmail.com', '03451239876', 'DHA Phase 5', 'Karachi');

-- Supplier Table
INSERT INTO Supplier VALUES
(101, 'Global Traders', 'TX-5541', 'ISO Certified', 1),
(102, 'Smart Supplies', 'TX-6622', 'Gov Registered', 3),
(103, 'Alpha Ventures', 'TX-7773', 'Private Vendor', 4),
(104, 'Prime Builders', 'TX-8889', 'NOC Approved', 5),
(105, 'IT World', 'TX-9911', 'Tech Registered', 6);

-- Bidder Table
INSERT INTO Bidder VALUES
(201, 'LIC-9876', 5, 'Bridge, Dam, Road', 1),
(202, 'LIC-5543', 2, 'IT Project, CCTV Setup', 3),
(203, 'LIC-2020', 7, 'Building Construction', 4),
(204, 'LIC-3030', 3, 'Painting, Electrical', 5),
(205, 'LIC-9090', 1, 'Networking Setup', 6);

-- Department Table
INSERT INTO Department VALUES
(701, 'Procurement Dept', 'Admin Block', '2nd Floor', '021-999999'),
(702, 'Engineering Dept', 'Tech Block', '3rd Floor', '021-123456'),
(703, 'Finance Dept', 'Main Tower', '1st Floor', '021-333444'),
(704, 'Legal Dept', 'Block B', '2nd Floor', '021-444555'),
(705, 'HR Dept', 'Annex Building', 'Ground Floor', '021-777888');

-- Manager Table
INSERT INTO Manager VALUES
(801, 'Ms. Sara Khan', 'sara@company.com', 701, '03211234567'),
(802, 'Mr. Asad Ali', 'asad@company.com', 702, '03451234567'),
(803, 'Mr. Fahad Rehman', 'fahad@company.com', 703, '03345556666'),
(804, 'Ms. Zainab Qureshi', 'zainab@company.com', 704, '03005557788'),
(805, 'Mr. Talha Nasir', 'talha@company.com', 705, '03407778888');

-- Tender Table
INSERT INTO Tender VALUES
(301, 'Office Chairs Supply', 'Procurement of ergonomic chairs', '2025-08-15', 801),
(302, 'CCTV Camera Installation', 'Setup of security cameras in offices', '2025-09-01', 802),
(303, 'Paint Building', 'Full exterior paint for head office', '2025-07-20', 804),
(304, 'Laptop Purchase', 'Procurement of 50 new laptops', '2025-07-30', 801),
(305, 'Legal Compliance Setup', 'Hire firm to audit legal docs', '2025-09-10', 804);

-- Bid Table
INSERT INTO Bid VALUES
(401, 150000.00, '2025-07-01', 101, 301),
(402, 180000.00, '2025-07-05', 102, 301),
(403, 120000.00, '2025-08-10', 103, 302),
(404, 200000.00, '2025-07-15', 104, 303),
(405, 95000.00, '2025-07-18', 105, 304);

-- Evaluation Table
INSERT INTO Evaluation VALUES
(501, 301, 101, 92.5, 'Engr. Usman'),
(502, 301, 102, 89.0, 'Ms. Sara'),
(503, 302, 103, 95.0, 'Mr. Asad'),
(504, 303, 104, 88.5, 'Ms. Zainab'),
(505, 304, 105, 94.0, 'Mr. Fahad');

-- Project Table
INSERT INTO Project VALUES
(601, 'IT Infrastructure Upgrade', 701, 5000000.00, 'Moderate'),
(602, 'Office Renovation', 702, 2000000.00, 'High'),
(603, 'Legal System Revamp', 704, 800000.00, 'Low'),
(604, 'Laptop Rollout', 701, 1200000.00, 'Moderate'),
(605, 'Parking Area Extension', 702, 2500000.00, 'Medium');

-- Payment Table
INSERT INTO Payment VALUES
(701, 101, 601, 200000.00, 'Cleared'),
(702, 102, 601, 250000.00, 'Pending'),
(703, 103, 602, 300000.00, 'Cleared'),
(704, 104, 603, 180000.00, 'Failed'),
(705, 105, 604, 100000.00, 'Cleared');
SELECT * FROM Person;
SELECT * FROM Supplier;
SELECT * FROM Bidder;
SELECT * FROM Department;
SELECT * FROM Manager;
SELECT * FROM Tender;
SELECT * FROM Bid;
SELECT * FROM Evaluation;
SELECT * FROM Project;
SELECT * FROM Payment;
SELECT * FROM Person;
SELECT Name, City FROM Person WHERE City = 'Karachi';

SELECT * FROM Supplier WHERE Certification = 'ISO Certified';
SELECT DISTINCT City FROM Person;

SELECT * FROM Bid ORDER BY BidAmount DESC;
SELECT * FROM Bid WHERE BidAmount > 150000;

SELECT CompanyName FROM Supplier
WHERE SupplierID IN (SELECT SupplierID FROM Bid WHERE BidAmount > 150000);

SELECT BidID, BidAmount FROM Bid LIMIT 3;

SELECT TenderID, COUNT(*) AS TotalBids
FROM Bid
GROUP BY TenderID;

SELECT TenderID, AVG(Score) AS AverageScore
FROM Evaluation
GROUP BY TenderID
HAVING AVG(Score) > 90;

SELECT s.CompanyName, b.BidAmount, t.Title
FROM Supplier s
JOIN Bid b ON s.SupplierID = b.SupplierID
JOIN Tender t ON b.TenderID = t.TenderID;

SELECT ProjectID, SUM(Amount) AS TotalPayments
FROM Payment
GROUP BY ProjectID
ORDER BY TotalPayments DESC;

SELECT Title, BudgetEstimate
FROM Project
WHERE BudgetEstimate > 1000000;

SELECT t.Title AS tenderTitle COUNT(b.BidID) AS TotalBids
FROM Tender t
JOIN Bid b ON t.TenderID = b.TenderID
GROUP BY t.TenderID, t.Title;
SELECT BidID, BidAmount 
FROM Bid
WHERE (BidAmount>150000);

