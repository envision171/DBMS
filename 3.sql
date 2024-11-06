
CREATE DATABASE IF NOT EXISTS three;
USE three;

-- Step 2: Create the tables
CREATE TABLE IF NOT EXISTS N_Roll_Call (
    Roll_No INT PRIMARY KEY,
    Student_Name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS O_Roll_Call (
    Roll_No INT PRIMARY KEY,
    Student_Name VARCHAR(50)
);

-- Step 3: Insert data into N_Roll_Call
INSERT INTO N_Roll_Call (Roll_No, Student_Name) VALUES
(101, 'Alice'),
(102, 'Bob'),
(103, 'Charlie'),
(104, 'David'),
(105, 'Eve'),
(106, 'Frank'),
(107, 'Grace'),
(108, 'Hannah'),
(109, 'Ian'),
(110, 'Jack');

-- Step 4: Insert data into O_Roll_Call
INSERT INTO O_Roll_Call (Roll_No, Student_Name) VALUES
(101, 'Alice'),
(102, 'Bob'),
(111, 'Karen'),
(112, 'Leo'),
(113, 'Mike'),
(114, 'Nancy'),
(115, 'Oliver'),
(116, 'Peter'),
(117, 'Quinn'),
(118, 'Rachel');

-- Step 5: Create the stored procedure to merge roll calls using a cursor
DELIMITER $$

CREATE PROCEDURE merge_roll_call(IN min_roll_no INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_roll_no INT;
    DECLARE v_student_name VARCHAR(50);

    -- Declare the cursor to select records from N_Roll_Call based on the minimum roll number
    DECLARE n_roll_cursor CURSOR FOR 
        SELECT Roll_No, Student_Name FROM N_Roll_Call WHERE Roll_No >= min_roll_no;

    -- Handler for when the cursor completes
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN n_roll_cursor;

    -- Loop through the records
    read_loop: LOOP
        -- Fetch each row from the cursor
        FETCH n_roll_cursor INTO v_roll_no, v_student_name;

        -- Exit the loop if no more rows
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert into O_Roll_Call if the Roll_No does not exist
        IF NOT EXISTS (SELECT 1 FROM O_Roll_Call WHERE Roll_No = v_roll_no) THEN
            INSERT INTO O_Roll_Call (Roll_No, Student_Name) VALUES (v_roll_no, v_student_name);
        END IF;
    END LOOP;

    -- Close the cursor
    CLOSE n_roll_cursor;
END $$

DELIMITER ;

-- Step 6: Call the procedure with a minimum roll number
CALL merge_roll_call(100);

-- Step 7: View the updated records in O_Roll_Call
SELECT * FROM O_Roll_Call;
