create database one;
use  one;




CREATE TABLE branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50) NOT NULL,
    assets_amt DECIMAL(15, 2) CHECK (assets_amt >= 0)
);

CREATE TABLE customer (
    cust_name VARCHAR(50) PRIMARY KEY,
    cust_street VARCHAR(50),
    cust_city VARCHAR(50)
);

CREATE TABLE Account (
    Acc_no INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    balance DECIMAL(10, 2) CHECK (balance >= 0),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE Depositor (
    cust_name VARCHAR(50),
    acc_no INT,
    PRIMARY KEY (cust_name, acc_no),
    FOREIGN KEY (cust_name) REFERENCES customer(cust_name),
    FOREIGN KEY (acc_no) REFERENCES Account(Acc_no)
);

CREATE TABLE Loan (
    Acc_no INT,
    loan_no INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) CHECK (amount > 0),
    FOREIGN KEY (Acc_no) REFERENCES Account(Acc_no),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE Borrower (
    cust_name VARCHAR(50),
    loan_no INT,
    PRIMARY KEY (cust_name, loan_no),
    FOREIGN KEY (cust_name) REFERENCES customer(cust_name),
    FOREIGN KEY (loan_no) REFERENCES Loan(loan_no)
);

INSERT INTO branch (branch_name, branch_city, assets_amt) VALUES
('Pimpri', 'Pune', 5000000),
('Akurdi', 'Pune', 3000000),
('Hinjewadi', 'Pune', 7000000),
('Baner', 'Pune', 4500000),
('Kothrud', 'Pune', 3500000);

INSERT INTO customer (cust_name, cust_street, cust_city) VALUES
('Alice', 'MG Road', 'Pune'),
('Bob', 'JM Road', 'Pune'),
('Charlie', 'FC Road', 'Pune'),
('David', 'East Street', 'Pune'),
('Eva', 'Baner Road', 'Pune'),
('Frank', 'Aundh Road', 'Pune'),
('Grace', 'Shivaji Nagar', 'Pune'),
('Hannah', 'Kothrud', 'Pune'),
('Isaac', 'Hinjewadi', 'Pune'),
('Jack', 'Pimpri', 'Pune');


INSERT INTO Account (Acc_no, branch_name, balance) VALUES
(1001, 'Pimpri', 15000),
(1002, 'Akurdi', 8000),
(1003, 'Hinjewadi', 20000),
(1004, 'Baner', 5000),
(1005, 'Kothrud', 12000),
(1006, 'Pimpri', 25000),
(1007, 'Akurdi', 18000),
(1008, 'Baner', 6000),
(1009, 'Kothrud', 14000),
(1010, 'Hinjewadi', 22000);


INSERT INTO Depositor (cust_name, acc_no) VALUES
('Alice', 1001),
('Bob', 1002),
('Charlie', 1003),
('David', 1004),
('Eva', 1005),
('Frank', 1006),
('Grace', 1007),
('Hannah', 1008),
('Isaac', 1009),
('Jack', 1010);


INSERT INTO Loan (Acc_no, loan_no, branch_name, amount) VALUES
(1001, 2001, 'Pimpri', 15000),
(1002, 2002, 'Akurdi', 5000),
(1003, 2003, 'Hinjewadi', 22000),
(1004, 2004, 'Baner', 7000),
(1005, 2005, 'Kothrud', 8000),
(1006, 2006, 'Pimpri', 30000),
(1007, 2007, 'Akurdi', 10000),
(1008, 2008, 'Baner', 6000),
(1009, 2009, 'Kothrud', 15000),
(1010, 2010, 'Hinjewadi', 25000);


INSERT INTO Borrower (cust_name, loan_no) VALUES
('Alice', 2001),
('Bob', 2002),
('Charlie', 2003),
('David', 2004),
('Eva', 2005),
('Frank', 2006),
('Grace', 2007),
('Hannah', 2008),
('Isaac', 2009),
('Jack', 2010);




SELECT distinct   branch_name FROM Loan;

SELECT loan_no 
FROM Loan 
WHERE branch_name = 'Pimpri' AND amount > 12000;

SELECT Borrower.cust_name, Loan.loan_no, Loan.amount
FROM Borrower
JOIN Loan ON Borrower.loan_no = Loan.loan_no;

SELECT cust_name FROM Depositor
UNION
SELECT cust_name FROM Borrower;

SELECT Depositor.cust_name 
FROM Depositor
JOIN Borrower ON Depositor.cust_name = Borrower.cust_name;


SELECT AVG(balance) AS avg_balance
FROM Account
WHERE branch_name = 'Pimpri';


SELECT branch_name, AVG(balance) AS avg_balance
FROM Account
GROUP BY branch_name;

SELECT branch_name 
FROM Account
GROUP BY branch_name
HAVING AVG(balance) > 12000;

SELECT SUM(amount) AS total_loan_amount FROM Loan;






