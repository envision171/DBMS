-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS seven;

-- Step 2: Use the created database
USE seven;

-- Step 3: Create the Borrower and Fine tables
CREATE TABLE Borrower (
    Roll_no INT PRIMARY KEY,
    Name VARCHAR(100),
    Date_of_Issue DATE,
    Name_of_Book VARCHAR(100),
    Status CHAR(1) DEFAULT 'I' -- 'I' for Issued, 'R' for Returned
);

CREATE TABLE Fine (
    Roll_no INT,
    Date DATE,
    Amt INT,
    FOREIGN KEY (Roll_no) REFERENCES Borrower(Roll_no)
);

-- Step 4: Insert sample data into Borrower table
INSERT INTO Borrower (Roll_no, Name, Date_of_Issue, Name_of_Book) VALUES
(1, 'Alice', '2024-07-01', 'Introduction to Algorithms'),
(2, 'Bob', '2024-07-05', 'Machine Learning Yearning'),
(3, 'Charlie', '2024-07-10', 'Deep Learning'),
(4, 'David', '2024-07-15', 'Data Science for Business');

-- Step 5: Create a PL/SQL block to calculate and apply fines
DELIMITER //

CREATE PROCEDURE CalculateAndApplyFines(p_Roll_no INT, p_Name_of_Book VARCHAR(100))
BEGIN
    DECLARE v_days_overdue INT;
    DECLARE v_fine_amount INT;
    DECLARE v_date_of_issue DATE;
    DECLARE v_status CHAR(1);
    DECLARE v_current_date DATE;

    SET v_current_date = CURDATE();

    -- Check if the book is issued
    SELECT Date_of_Issue, Status INTO v_date_of_issue, v_status
    FROM Borrower
    WHERE Roll_no = p_Roll_no AND Name_of_Book = p_Name_of_Book;

    -- Handle if no records are found
    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No such book issued to this borrower';
    ELSE
        -- Calculate the number of overdue days
        SET v_days_overdue = DATEDIFF(v_current_date, DATE_ADD(v_date_of_issue, INTERVAL 15 DAY));

        -- Determine fine amount
        IF v_days_overdue > 0 THEN
            IF v_days_overdue <= 30 THEN
                SET v_fine_amount = v_days_overdue * 5; -- Rs 5 per day for days between 15 and 30
            ELSE
                SET v_fine_amount = (30 * 5) + ((v_days_overdue - 30) * 50); -- Rs 50 for days after 30
            END IF;

            -- Update the Borrower status to 'R' for returned
            UPDATE Borrower SET Status = 'R' WHERE Roll_no = p_Roll_no AND Name_of_Book = p_Name_of_Book;

            -- Insert fine details into the Fine table
            INSERT INTO Fine (Roll_no, Date, Amt) VALUES (p_Roll_no, v_current_date, v_fine_amount);
        END IF;
    END IF;
END //

DELIMITER ;

-- Step 6: Call the procedure to calculate and apply fines
CALL CalculateAndApplyFines(1, 'Introduction to Algorithms'); -- Example to check for Roll_no 1 and book

-- Step 7: Select from the Fine table to view applied fines
SELECT * FROM Fine;


-- Explanation of the Code
-- Database Creation: It starts by creating a database named assignment4 if it does not exist.

-- Tables Creation: Two tables, Borrower and Fine, are created to manage borrower information and fine records, respectively.

-- Sample Data Insertion: Sample records are inserted into the Borrower table to simulate book issues.

-- Procedure Creation:

-- A stored procedure CalculateAndApplyFines is created to calculate the fine for a specified Roll_no and Name_of_Book.
-- The procedure checks if the book has been issued and calculates the number of overdue days.
-- Fines are calculated based on the overdue days:
-- Rs 5 per day for days between 15 and 30.
-- Rs 50 per day for days after 30.
-- The status of the book is updated to 'R' (returned) in the Borrower table.
-- If a fine is applicable, it is inserted into the Fine table.
-- Calling the Procedure: An example call is made to apply fines for a specific roll number and book name.

-- Viewing Results: The last SELECT statement retrieves the fine records to see the results.
