

CREATE DATABASE IF NOT EXISTS eight;

-- Step 2: Use the created database
USE eight;

-- Step 3: Create a table to store student records
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentName VARCHAR(100),
    Class VARCHAR(10),
    Address VARCHAR(255),
    Grades VARCHAR(10),
    EnrolmentDate DATE
);

-- Step 4: Create a table to store subject details and attendance
CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    SubjectName VARCHAR(100),
    Attendance INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Step 5: Insert sample data into the Students table
INSERT INTO Students (StudentName, Class, Address, Grades, EnrolmentDate) VALUES
('Alice Smith', '10th', '123 Elm St', 'A', '2022-08-15'),
('Bob Johnson', '10th', '456 Oak St', 'B+', '2022-08-16'),
('Charlie Brown', '11th', '789 Pine St', 'A-', '2021-08-15'),
('David Wilson', '11th', '321 Maple St', 'B', '2021-08-16'),
('Eva Green', '12th', '654 Birch St', 'A+', '2020-08-15');

-- Step 6: Insert sample data into the Subjects table
INSERT INTO Subjects (StudentID, SubjectName, Attendance) VALUES
(1, 'Mathematics', 90),
(1, 'Science', 85),
(2, 'Mathematics', 95),
(2, 'History', 80),
(3, 'Mathematics', 88),
(3, 'Science', 92),
(4, 'History', 75),
(4, 'Science', 82),
(5, 'Mathematics', 100),
(5, 'English', 95);

-- Step 7: Create a view to summarize student performance
CREATE VIEW StudentPerformance AS
SELECT 
    s.StudentID,
    s.StudentName,
    s.Class,
    s.Grades,
    AVG(sub.Attendance) AS AverageAttendance
FROM 
    Students s
JOIN 
    Subjects sub ON s.StudentID = sub.StudentID
GROUP BY 
    s.StudentID;

-- Step 8: Create a view to summarize attendance
CREATE VIEW AttendanceSummary AS
SELECT 
    s.StudentID,
    COUNT(sub.SubjectName) AS TotalSubjects,
    SUM(sub.Attendance) AS TotalAttendance,
    AVG(sub.Attendance) AS AverageAttendance
FROM 
    Students s
JOIN 
    Subjects sub ON s.StudentID = sub.StudentID
GROUP BY 
    s.StudentID;

-- Step 9: Create an index on the Students table using StudentName
CREATE INDEX idx_student_name ON Students(StudentName);

-- Step 10: Check the data in the views
SELECT * FROM StudentPerformance;
SELECT * FROM AttendanceSummary;
