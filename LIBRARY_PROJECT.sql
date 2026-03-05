-- library management system project

create database if not exists library_db;

use library_db;

-- create table
drop table if exists branch;
create table branch
               (
               branch_id varchar(15) primary key,
               manager_id varchar(15),
               branch_address varchar(55),
               contact_no varchar(15)
               );

drop table if exists employees;
create table employees
                (
                 emp_id	varchar(15) primary key,
                 emp_name varchar(55),
                 position varchar(15),
                 salary	int,
                 branch_id varchar(15) -- fk
                );

drop table if exists books;
create table books
               (
                isbn varchar(25) primary key,
                book_title varchar(75),
                category varchar(10),
                rental_price float,
                status varchar(15),
                author varchar(55),
                publisher varchar(55)
                );
alter table books
MODIFY column category varchar(30);                
                
drop table if exists members;
create table members 
			  (
                member_id varchar(15) primary key,
                member_name varchar(55),
                member_address varchar(55),
                reg_date date
                );

drop table if exists issued_status;
create table issued_status
               (
                issued_id varchar(15) primary key,
                issued_member_id varchar(15), -- fk
                issued_book_name varchar(55),
                issued_date	date,
                issued_book_isbn varchar(15), -- fk
                issued_emp_id varchar(15) -- fk
                );
ALTER TABLE issued_status
modify column issued_book_isbn varchar(30);

drop table if exists return_status;
create table return_status
                       (
                        return_id varchar(15) primary key,
                        issued_id varchar(15), -- fk
                        return_book_name varchar(55),
                        return_date date,
                        return_book_isbn varchar(55)
                        );
                        
-- foreign key
alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);   

alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn); 

alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);              

alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);  

alter table return_status
add constraint fk_issued_status
foreign key (issued_id)
references issued_status(issued_id);  

-- project start

-- ### 2. CRUD Operations

-- **Create**: Inserted sample records into the `books` table.
-- **Read**: Retrieved and displayed data from various tables.
-- **Update**: Updated records in the `employees` table.
-- **Delete**: Removed records from the `members` table as needed.

-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,	book_title,	category, rental_price,	status,	author,	publisher)
values 
     ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
 
select*from books; 

-- Task 2: Update an Existing Member's Address
select * from members;
update members
set member_address='125 Main st'
where member_id='c101';

-- **Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select * from issued_status;
DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID='IS121';


-- **Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM ISSUED_STATUS
WHERE ISSUED_EMP_ID ='E101';

-- **Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT ISSUED_EMP_ID,COUNT(ISSUED_ID) AS TOTAL_COUNT
FROM ISSUED_STATUS
GROUP BY ISSUED_EMP_ID
HAVING TOTAL_COUNT>1;
 
-- ### 3. CTAS (Create Table As Select)
SELECT * FROM ISSUED_STATUS;
-- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE BOOK_CNTS AS
SELECT B.BOOK_TITLE,B.ISBN,COUNT(I_S.ISSUED_ID) AS NO_OF_COUNT
FROM BOOKS AS B
JOIN
ISSUED_STATUS AS I_S
ON
B.ISBN=I_S.ISSUED_BOOK_ISBN
GROUP BY 1,2;
-- ### 4. Data Analysis & Findings

-- The following SQL queries were used to address specific questions:

-- Task 7. **Retrieve All Books in a Specific Category**:

SELECT*FROM BOOKS;
SELECT * FROM BOOKS
ORDER BY CATEGORY;

--  **Task 8: Find Total Rental Income by Category**:

SELECT CATEGORY , SUM(RENTAL_PRICE) AS TOTAL_PRICE
FROM BOOKS
GROUP BY CATEGORY
ORDER BY TOTAL_PRICE DESC;

-- 9.**List Members Who Registered in the Last 100 Days**:

SELECT*FROM MEMBERS
WHERE REG_DATE>= DATE_SUB(CURRENT_DATE(), INTERVAL 100 DAY);
SELECT*FROM MEMBERS;
INSERT INTO MEMBERS(MEMBER_ID,MEMBER_NAME,MEMBER_ADDRESS,REG_DATE)
VALUES
('C120','NIKS','14-C DHA','2026-02-12'),
('C121',"INDU'S",'44-B PAT','2025-12-12');

-- 10. **List Employees with Their Branch Manager's Name and their branch details**:
SELECT*FROM EMPLOYEES;
SELECT E1.*,
	   B.BRANCH_ADDRESS,B.BRANCH_ID,
       E2.EMP_NAME AS MANAGER
FROM 
EMPLOYEES AS E1
JOIN
BRANCH AS B
ON
E1.BRANCH_ID=B.BRANCH_ID
JOIN
EMPLOYEES AS E2
ON
E2.EMP_ID=B.MANAGER_ID;

-- Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
SELECT *,
CASE 
   WHEN RENTAL_PRICE < 6.3055 THEN 'BELOW_THRESHOLD'
   WHEN RENTAL_PRICE = 6.3055 THEN 'THRESHOLD'
   ELSE 'ABOVE_THRESHOLD'
   END AS PRICE_CATEGORY
FROM 
BOOKS;

-- METHOD 2
CREATE TABLE EXPENSIVE_BOOKS
(
SELECT *,
CASE 
   WHEN RENTAL_PRICE < (SELECT AVG(RENTAL_PRICE) FROM BOOKS)
   THEN 'BELOW_THRESHOLD'
   WHEN RENTAL_PRICE = (SELECT AVG(RENTAL_PRICE) FROM BOOKS)
   THEN 'THRESHOLD'
   ELSE 'ABOVE_THRESHOLD'
   END AS PRICE_CATEGORY
FROM 
BOOKS
WHERE RENTAL_PRICE>=(SELECT AVG(RENTAL_PRICE) FROM BOOKS)
);
SELECT*FROM EXPENSIVE_BOOKS;

-- Task 12: **Retrieve the List of Books Not Yet Returned**

SELECT IST.ISSUED_ID,
       IST.ISSUED_BOOK_NAME,
       IST.ISSUED_DATE,
       RS.RETURN_ID,
       RS.RETURN_DATE
FROM 
ISSUED_STATUS AS IST
LEFT JOIN
RETURN_STATUS AS RS
ON
IST.ISSUED_ID=RS.ISSUED_ID
WHERE RETURN_ID IS NULL;

-- ## Advanced SQL Operations

-- **Task 13: Identify Members with Overdue Books**  
-- Write a query to identify members who have overdue books (assume a 45-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
SELECT * FROM ISSUED_STATUS;
SELECT * FROM RETURN_STATUS;
SELECT * FROM MEMBERS;
 
SELECT  
		IST.ISSUED_MEMBER_ID,
		M.MEMBER_NAME,
		IST.ISSUED_BOOK_NAME,
		IST.ISSUED_DATE,
		RS.RETURN_DATE,
		DATEDIFF(IFNULL(RS.RETURN_DATE,CURRENT_DATE()),IST.ISSUED_DATE) AS DAYS_OVERDUE
FROM ISSUED_STATUS AS IST
LEFT JOIN
RETURN_STATUS AS RS
ON 
IST.ISSUED_ID=RS.ISSUED_ID
JOIN
MEMBERS AS M
ON
IST.ISSUED_MEMBER_ID=M.MEMBER_ID
WHERE DATEDIFF(IFNULL(RS.RETURN_DATE,CURRENT_DATE()),IST.ISSUED_DATE)>45;
-- **Task 14: Update Book Status on Return**  
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

SELECT*FROM BOOKS;
SELECT*FROM return_status;
SELECT*FROM ISSUED_STATUS;
SELECT RS.RETURN_ID,IST.ISSUED_ID,
       IST.ISSUED_DATE,RS.RETURN_DATE,
       IST.ISSUED_BOOK_NAME
FROM ISSUED_STATUS AS IST
LEFT JOIN
RETURN_STATUS AS RS
ON
RS.ISSUED_ID=IST.ISSUED_ID;
-- **Task 15: Branch Performance Report**  
-- Create a query that generates a performance report for each branch, 
-- showing the number of books issued, the number of books returned,
-- and the total revenue generated from book rentals.

 SELECT*FROM BOOKS;
 SELECT*FROM issued_status;
SELECT*FROM return_status;
SELECT B.CATEGORY,
       SUM(B.RENTAL_PRICE) AS TOTAL_REVENUE,
       COUNT(IST.issued_id) AS ISSUED_BOOKS,
       COUNT(RS.return_id) AS RETURN_BOOKS
FROM BOOKS AS B
LEFT JOIN
issued_status AS IST
ON
B.ISBN=IST.issued_book_isbn
LEFT JOIN
return_status AS RS
ON
IST.issued_id=RS.issued_id
group by 1;

-- **Task 16: CTAS: Create a Table of Active Members**  
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book before 29th may 2024.
select*FROM issued_status;
SELECT*FROM MEMBERS;

CREATE TABLE ACTIVE_MEMBERS(
                            SELECT M.MEMBER_NAME,
                                   IST.ISSUED_BOOK_NAME,
                                   IST.ISSUED_DATE,
                                   datediff('2024-05-29',ISSUED_DATE) AS ACTIVE_MEMBERS
                            FROM ISSUED_STATUS AS IST
                            JOIN
                            MEMBERS AS M
                            ON
                            IST.ISSUED_MEMBER_ID=M.MEMBER_ID
                            WHERE datediff('2024-05-29',ISSUED_DATE)<=60
                            );
                          
   SELECT*FROM ACTIVE_MEMBERS;          

-- **Task 17: Find Employees with the Most Book Issues Processed**  
-- Write a query to find the top 3 employees who have processed the most book issues.
-- Display the employee name, number of books processed, and their branch.

SELECT*FROM ISSUED_STATUS;
SELECT*FROM employees;
SELECT*FROM branch;
select emp.emp_name,
       count(ist.issued_id) as number_books_processed,
       b.branch_address
from issued_status as ist
join
employees as emp
on 
ist.issued_emp_id=emp.emp_id
join
branch as b
on
emp.branch_id=b.branch_id
group by 1,3
order by 2 desc
limit 3;


-- **Task 18: Stored Procedure**
-- Objective:
-- Create a stored procedure to manage the status of books in a library system.
-- Description:
-- Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
-- The stored procedure should take the book_id as an input parameter.
-- The procedure should first check if the book is available (status = 'yes').
-- If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
-- If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
-- update books
-- set status ='yes'

select*from issued_status;
select*from books;

DROP PROCEDURE IF EXISTS issue_book;

delimiter $$
create procedure issue_book(IN P_ISBN VARCHAR(55),
IN P_BOOK_TITLE VARCHAR(255),
IN P_CATEGORY VARCHAR(100),
IN P_RENTAL_PRICE DECIMAL(6,2),
IN P_STATUS VARCHAR(10),
IN P_AUTHOR VARCHAR(100),
IN P_PUBLISHER VARCHAR(100)
)
begin
     declare book_status varchar(10);
     
     select status
     into book_status
     from books
     where isbn=p_isbn;
     
     if book_status is null then
     signal sqlstate '45000'
     set MESSAGE_TEXT ="book_isbn doesn't exist";
     
     elseif book_status ='yes' then
     update books
     set book_status='no'
     where isbn=p_isbn;
     
     select 'book issued successfully' as message;
     
     else
     signal sqlstate '45000'
     set MESSAGE_TEXT ='book is currently not availabel';
     end if;
     
end $$  

 
SELECT * 
FROM books 
WHERE isbn = '978-0-06-112008-4';

CALL ISSUE_BOOK('978-0-06-112008-4','To Kill a Mockingbird','Classic',5,'yes','Harper Lee','J.B. Lippincott & Co.');

SELECT * 
FROM books;

-- **Task 19: Create Table As Select (CTAS)**
-- Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
--    The number of overdue books.
--    The total fines, with each day's fine calculated at $0.50.
  --  The number of books issued by each member.
--    The resulting table should show:
 --   Member ID
 --   Number of overdue books
 --   Total fines
 
select*from issued_status;
select * from employees;
select*from return_status;
select*from books;
SELECT  
		IST.ISSUED_MEMBER_ID, 
		M.MEMBER_NAME,ist.issued_book_name,
		DATEDIFF(IFNULL(RS.RETURN_DATE,CURRENT_DATE()),IST.ISSUED_DATE) AS DAYS_OVERDUE,
        case
           when DATEDIFF(IFNULL(RS.RETURN_DATE,CURRENT_DATE()),IST.ISSUED_DATE)>30
           then (DATEDIFF(IFNULL(RS.RETURN_DATE,CURRENT_DATE()),IST.ISSUED_DATE)-30)*0.50
           else 0
        end as total_fines_$   
       
FROM ISSUED_STATUS AS IST
LEFT JOIN
RETURN_STATUS AS RS
ON 
IST.ISSUED_ID=RS.ISSUED_ID
JOIN
MEMBERS AS M
ON
IST.ISSUED_MEMBER_ID=M.MEMBER_ID;
 