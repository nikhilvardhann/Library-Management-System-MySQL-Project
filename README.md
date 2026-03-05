README.md# Library Management System using SQL Project

# 📚 Library Management System – MySQL Project

## 📌 Project Overview

This project is a **Library Management System** built using **MySQL**.
It demonstrates database design, CRUD operations, joins, CTE, CTAS, stored procedures, and analytical queries.

The system manages:

* 📍 Branches
* 👨‍💼 Employees
* 📖 Books
* 👤 Members
* 🔄 Book Issue & Return Tracking
* 💰 Revenue & Fine Calculation

---

## 🗂 Database Schema

### Main Tables

| Table Name      | Description           |
| --------------- | --------------------- |
| `branch`        | Stores branch details |
| `employees`     | Employee information  |
| `books`         | Book inventory        |
| `members`       | Library members       |
| `issued_status` | Tracks issued books   |
| `return_status` | Tracks returned books |

### 🔗 Relationships

* One branch → Many employees
* One member → Many issued books
* One book → Many issue records
* One issue record → One return record

Foreign keys are implemented to maintain referential integrity.

---

## ⚙️ Features Implemented

### 1️⃣ Database Creation

* Created `library_db`
* Defined tables with primary & foreign keys
* Enforced relationships

---

### 2️⃣ CRUD Operations

* ✅ Insert new book records
* ✅ Update member details
* ✅ Delete issued records
* ✅ Retrieve issued books by employee
* ✅ Identify members issuing multiple books

---

### 3️⃣ CTAS (Create Table As Select)

* Created `BOOK_CNTS` summary table
* Created `ACTIVE_MEMBERS` table
* Created overdue/fine calculation table

---

### 4️⃣ Data Analysis Queries

* 📊 Total rental income by category
* 📅 Members registered in last 100 days
* 🏢 Employee–Branch performance mapping
* ⏳ Identify overdue books (45-day logic)
* 💰 Fine calculation ($0.50 per extra day)
* 🏆 Top 3 employees processing most issues

---

### 5️⃣ Advanced SQL Concepts Used

* `JOIN` (INNER, LEFT)
* `GROUP BY` & `HAVING`
* `CASE` statements
* `DATEDIFF`
* `IFNULL`
* `CTE`
* `CTAS`
* Stored Procedure (`issue_book`)
* Error handling using `SIGNAL SQLSTATE`

---

## 🏦 Fine Calculation Logic

* Return period: **30 days**
* Fine per extra day: **$0.50**
* Overdue detection using:

```sql
DATEDIFF(IFNULL(return_date, CURRENT_DATE()), issued_date)
```

---

## 🛠 Stored Procedure

Procedure: `issue_book`

Functionality:

* Checks book availability
* If available → Updates status to 'no'
* If not available → Raises custom error

---

## 📊 Sample Business Insights

* Branch-wise performance reporting
* Revenue tracking by category
* Overdue member identification
* Employee productivity ranking
* Active member tracking

---

## 🧠 Learning Outcomes

Through this project, I gained hands-on experience in:

* Relational Database Design
* Query Optimization
* Analytical SQL
* Writing Clean & Structured Queries
* Building Real-World Database Projects

---

## 🚀 How to Run the Project

1. Open MySQL Workbench
2. Create a new SQL script
3. Copy and execute the provided SQL file
4. Use the database:

   ```sql
   USE library_db;
   ```

---

## 📌 Future Improvements

* Add triggers for automatic status updates
* Add indexing for performance
* Add user roles and permissions
* Build a frontend interface (optional)
* Integrate with Python or Power BI for visualization

---

## 👨‍💻 Author

**Nikhil Vardhan**
Aspiring Data Analyst | SQL | Data Science Enthusiast

---

⭐ If you found this project helpful, consider giving it a star!

