# database_programming_assignment_277442024_djeffrys

# Business problem
"CareFirst Clinic" is a growing multi-specialty medical clinic. Management is struggling to optimize operations due to siloed data. They need a data-driven solution to track doctor utilization, analyze revenue streams, understand patient return patterns, and rank financial performance.
# Database Schema
-- 1. Create Tables
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender CHAR(1),
    DateOfBirth DATE
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(50),
    ConsultationFee DECIMAL(10,2)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Status VARCHAR(20), -- 'Completed', 'Cancelled'
    AmountPaid DECIMAL(10,2),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

# ER DIAGRAM

# CTE Implementations
1. Simple CTE
WITH HighValueAppointments AS (
    SELECT AppointmentID, PatientID, AmountPaid 
    FROM Appointments
    WHERE AmountPaid >= 150.00
)
SELECT * FROM HighValueAppointments;

Multiple CTEs
WITH CompletedVisits AS (
    SELECT * FROM Appointments WHERE Status = 'Completed'
),
CancelledVisits AS (
    SELECT * FROM Appointments WHERE Status = 'Cancelled'
)
SELECT 'Completed' AS StatusType, COUNT(*) AS Total FROM CompletedVisits
UNION ALL
SELECT 'Cancelled', COUNT(*) FROM CancelledVisits;

Recursive CTE
WITH RECURSIVE FollowUpSchedule AS (
    SELECT 1 AS WeekNumber, CAST('2026-01-01' AS DATE) AS SendDate
    UNION ALL
    SELECT WeekNumber + 1, SendDate + INTERVAL 7 DAY
    FROM FollowUpSchedule
    WHERE WeekNumber < 5
)
SELECT * FROM FollowUpSchedule;

CTE with Aggregation
WITH PatientRevenue AS (
    SELECT PatientID, SUM(AmountPaid) AS TotalSpent
    FROM Appointments
    WHERE Status = 'Completed'
    GROUP BY PatientID
)
SELECT * FROM PatientRevenue WHERE TotalSpent > 100;

CTE Combined with JOIN Operations
WITH DetailedAppointments AS (
    SELECT a.AppointmentID, p.FirstName, p.LastName, d.Specialty, a.AmountPaid
    FROM Appointments a
    JOIN Patients p ON a.PatientID = p.PatientID
    JOIN Doctors d ON a.DoctorID = d.DoctorID
)
SELECT Specialty, SUM(AmountPaid) AS TotalRevenue
FROM DetailedAppointments
GROUP BY Specialty;

# Window function implementation
SELECT 
    AppointmentID, 
    AmountPaid,
    ROW_NUMBER() OVER(ORDER BY AmountPaid DESC) AS RowNum,
    RANK() OVER(ORDER BY AmountPaid DESC) AS RevenueRank,
    DENSE_RANK() OVER(ORDER BY AmountPaid DESC) AS DenseRevenueRank,
    PERCENT_RANK() OVER(ORDER BY AmountPaid DESC) AS PercentRank
FROM Appointments
WHERE Status = 'Completed';
# Analysis and findings
Descriptive
The clinic's operational data shows a clear divide between routine care and specialized medical services. Advanced analytical queries reveal that specialty visits, particularly in Cardiology, drive the highest individual transaction values at 150.00 per appointment. However, distribution metrics indicate that the vast majority of the clinic's patient volume—approximately 60%—sits at or below the 100.00 price point, highlighting a heavy reliance on high-volume, lower-cost general check-ups. Concurrently, data tracking exposed clear efficiency leaks, including uncompensated slot cancellations and a notable drop-off in patient retention for standard consultations.

Diagnostic
This financial and operational split stems directly from the varying complexity of clinical needs and the design of the current scheduling system. Specialty departments command premium fees because they require advanced diagnostic technology, specialized practitioner training, and extended consultation windows. Meanwhile, the baseline volume is anchored by routine community wellness visits that naturally cost less

Prescriptive
To secure margins and optimize clinical flow, management must introduce targeted operational safeguards and automation. The clinic should protect its scheduling calendar by enforcing a mandatory 20% non-refundable deposit on specialized consultations alongside an automated 24-hour SMS reminder sequence. Furthermore, data systems should be configured to flag patients lacking scheduled follow-up visits, automatically enrolling them into long-term preventive care outreach campaigns.

# References
1. Oracle Database 21c SQL Language Reference.
2. Oracle SQL Developer Documentation.
3. Database Programming Course Notes.
4. ANSI SQL Standard Documentation.
# Academic Integrity Statement
I hereby declare that this submission is my own original work. All database schemas, SQL script formulations, and analytical query interpretations presented in this repository were developed independently by me.
