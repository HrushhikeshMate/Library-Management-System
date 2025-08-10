SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;


-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
select * from issued_status
where issued_id = 'IS121';

delete from issued_status
where issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status
where issued_emp_id = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_member_id  , count(issued_member_id)  as c
from issued_status
group by issued_member_id
HAVING count(issued_member_id) > 1;


-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
select * from books as b
join 
issued_status as ist
on  ist.issued_book_isbn = b.isbn ;


select b.isbn ,b.book_title, count(ist.issued_book_isbn) as cnt_ist
from books as b
join 
issued_status as ist
on  ist.issued_book_isbn = b.isbn 
GROUP by 1,2 ;
-- having count(ist.issued_book_isbn) <> 1;
 
-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:
select distinct category, count(*) 
from books
group by 1;

select * from books
where category = 'History'

-- Task 8: Find Total Rental Income by Category:
select category,count(category) , sum(rental_price)
from books
group by 1 
order by 2 desc;


-- Task 9. **List Members Who Registered in the Last 180 Days**:
select member_id,member_name ,reg_date from members;

select max(reg_date) from members;

select member_id,member_name ,reg_date
from members
where reg_date >= DATE '2024-06-01'  - INTERVAL '180';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:
select * from employees;

select  e.emp_id , b.branch_id , manager_id 
from employees e
join branch b 
on b.branch_id = e.branch_id;

SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
create table books_price_than_7
AS
select * from books
where rental_price > 7;

select * from books_price_than_7;

-- Task 12: Retrieve the List of Books Not Yet Returned
select * from return_status;


SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;

/*
### Advanced SQL Operations

Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.


Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "available" when they are returned (based on entries in the return_status table).



Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.


Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.



Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.


Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    


Task 19: Stored Procedure
Objective: Create a stored procedure to manage the status of books in a library system.
    Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
    If a book is issued, the status should change to 'no'.
    If a book is returned, the status should change to 'yes'.

Task 20: Create Table As Select (CTAS)
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines