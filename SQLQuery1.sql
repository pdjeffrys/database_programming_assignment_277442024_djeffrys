-- TABLE CREATION 

CREATE TABLE Patients (
	PatientId INT PRIMARY KEY,
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
)

-- INSERTING SAMPLE DATA

INSERT INTO Patients VALUES
(101, 'John', 'Doe', 'M', '1985-05-12'),
(102, 'Jane', 'Smith', 'F', '1990-08-22'),
(103, 'Robert', 'Johnson', 'M', '1975-11-30'),
(104, 'Emily', 'Davis', 'F', '2000-01-15'),
(105, 'Michael', 'Brown', 'M', '1962-04-05');

SELECT * FROM Patients

INSERT INTO Doctors VALUES
(1, 'Alice', 'Green', 'Cardiology', 150.00),
(2, 'Bob', 'White', 'Pediatrics', 100.00),
(3, 'Charlie', 'Black', 'General Medicine', 80.00);

SELECT * FROM Doctors

INSERT INTO Appointments VALUES
(1001, 101, 1, '2026-01-10', 'Completed', 150.00),
(1002, 102, 2, '2026-01-11', 'Completed', 100.00),
(1003, 103, 3, '2026-01-12', 'Completed', 80.00),
(1004, 101, 3, '2026-01-15', 'Completed', 80.00),
(1005, 104, 1, '2026-01-16', 'Completed', 150.00),
(1006, 102, 2, '2026-02-01', 'Completed', 100.00),
(1007, 105, 3, '2026-02-03', 'Cancelled', 0.00),
(1008, 103, 1, '2026-02-05', 'Completed', 150.00),
(1009, 101, 1, '2026-02-10', 'Completed', 150.00);

SELECT * FROM Appointments

-- SIMPLE CTE

WITH HighValueAppointments AS (
    SELECT AppointmentID, PatientID, AmountPaid 
    FROM Appointments
    WHERE AmountPaid >= 150.00
)
SELECT * FROM HighValueAppointments;

-- MULTIPLE CTE

WITH CompletedVisits AS (
    SELECT * FROM Appointments WHERE Status = 'Completed'
),
CancelledVisits AS (
    SELECT * FROM Appointments WHERE Status = 'Cancelled'
)
SELECT 'Completed' AS StatusType, COUNT(*) AS Total FROM CompletedVisits
UNION ALL
SELECT 'Cancelled', COUNT(*) FROM CancelledVisits;

-- CTE With Aggregation

WITH PatientRevenue AS (
    SELECT PatientID, SUM(AmountPaid) AS TotalSpent
    FROM Appointments
    WHERE Status = 'Completed'
    GROUP BY PatientID
)
SELECT * FROM PatientRevenue WHERE TotalSpent > 100;

-- CTE Combined with JOIN

WITH DetailedAppointments AS (
    SELECT a.AppointmentID, p.FirstName, p.LastName, d.Specialty, a.AmountPaid
    FROM Appointments a
    JOIN Patients p ON a.PatientID = p.PatientID
    JOIN Doctors d ON a.DoctorID = d.DoctorID
)
SELECT Specialty, SUM(AmountPaid) AS TotalRevenue
FROM DetailedAppointments
GROUP BY Specialty;

-- Ranking Functions

SELECT 
    AppointmentID, 
    AmountPaid,
    ROW_NUMBER() OVER(ORDER BY AmountPaid DESC) AS RowNum,
    RANK() OVER(ORDER BY AmountPaid DESC) AS RevenueRank,
    DENSE_RANK() OVER(ORDER BY AmountPaid DESC) AS DenseRevenueRank,
    PERCENT_RANK() OVER(ORDER BY AmountPaid DESC) AS PercentRank
FROM Appointments
WHERE Status = 'Completed';

-- Aggregate Window Functions 
SELECT 
    AppointmentID, 
    AmountPaid,
    SUM(AmountPaid) OVER() AS RunningTotalRevenue,
    AVG(AmountPaid) OVER() AS AverageFee,
    MIN(AmountPaid) OVER() AS MinimumFee,
    MAX(AmountPaid) OVER() AS MaximumFee
FROM Appointments;

--Navigation Functions
SELECT 
    PatientID, 
    AppointmentDate,
    LAG(AppointmentDate) OVER(PARTITION BY PatientID ORDER BY AppointmentDate) AS PreviousVisitDate,
    LEAD(AppointmentDate) OVER(PARTITION BY PatientID ORDER BY AppointmentDate) AS NextScheduledVisit
FROM Appointments;