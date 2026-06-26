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

# ER Diagram

# CTE Implementations

# Window function implementation

# Analysis and findings

# References

# Academic Integrity Statement
