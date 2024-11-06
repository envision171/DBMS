

-- Step 0: Create and use the database
CREATE DATABASE IF NOT EXISTS two;
USE two;

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

-- Step 2: Create the stored procedure `proc_Grade`
DELIMITER //

CREATE PROCEDURE proc_Grade()
BEGIN
    DECLARE student_name VARCHAR(50);
    DECLARE marks INT;
    DECLARE finished INT DEFAULT 0;

    -- Loop through all records in Stud_Marks
    DECLARE result_cursor CURSOR FOR SELECT name, total_marks FROM Stud_Marks;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Open the cursor
    OPEN result_cursor;

    read_loop: LOOP
        -- Fetch the student details
        FETCH result_cursor INTO student_name, marks;
        IF finished THEN
            LEAVE read_loop;
        END IF;

        -- Determine the class based on marks and insert into Result
        IF marks >= 990 AND marks <= 1500 THEN
            INSERT INTO Result (Name, Class) VALUES (student_name, 'Distinction');
        ELSEIF marks >= 900 AND marks <= 989 THEN
            INSERT INTO Result (Name, Class) VALUES (student_name, 'First Class');
        ELSEIF marks >= 825 AND marks <= 899 THEN
            INSERT INTO Result (Name, Class) VALUES (student_name, 'Higher Second Class');
        ELSE
            INSERT INTO Result (Name, Class) VALUES (student_name, 'No Category');
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE result_cursor;
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

