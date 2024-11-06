-- Step 0: Create and use the database
CREATE DATABASE IF NOT EXISTS two1;
USE two1;

-- Step 1: Create the tables
CREATE TABLE IF NOT EXISTS Stud_Marks (
    name VARCHAR(50),
    total_marks INT
);

CREATE TABLE IF NOT EXISTS Result (
    Roll INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    Class VARCHAR(20)
);

-- Step 2: Create the stored procedure `proc_Grade` without a cursor
DELIMITER //

CREATE PROCEDURE proc_Grade()
BEGIN
    -- Insert students with 'Distinction' class
    INSERT INTO Result (Name, Class)
    SELECT name, 'Distinction' FROM Stud_Marks WHERE total_marks BETWEEN 990 AND 1500;

    -- Insert students with 'First Class'
    INSERT INTO Result (Name, Class)
    SELECT name, 'First Class' FROM Stud_Marks WHERE total_marks BETWEEN 900 AND 989;

    -- Insert students with 'Higher Second Class'
    INSERT INTO Result (Name, Class)
    SELECT name, 'Higher Second Class' FROM Stud_Marks WHERE total_marks BETWEEN 825 AND 899;

    -- Insert students with 'No Category'
    INSERT INTO Result (Name, Class)
    SELECT name, 'No Category' FROM Stud_Marks WHERE total_marks < 825;
END //

DELIMITER ;

-- Step 3: Insert sample data into `Stud_Marks`
INSERT INTO Stud_Marks (name, total_marks) VALUES
('Alice', 1200),
('Bob', 950),
('Charlie', 880),
('David', 840),
('Eva', 700);

-- Step 4: Call the procedure to categorize students
CALL proc_Grade();

-- Step 5: View the results
SELECT * FROM Result;
