# Assignment III: SQL Table Manipulation — PostgreSQL

**Project:** Library Management System  
**DBMS:** PostgreSQL using pgAdmin 4

> Before submission, replace the example database name with your own name and student ID. Execute the SQL on your own PostgreSQL database, capture real screenshots, and export the ERD from pgAdmin. This starter pack does not contain fabricated execution screenshots or a fabricated ERD.

## Database and tables
- `members`: library member contact details; generated primary key `member_id`.
- `books`: book information and availability; generated primary key `book_id`.
- `loans`: borrowing records; generated primary key `loan_id`, plus foreign keys to `members` and `books`.

One member may have many loans, and one book may appear in many loan records over time. Foreign keys ensure each loan references an existing member and book.

## Run in pgAdmin
1. Create a PostgreSQL database named according to the assignment convention: `yourname_studentid_library_system`.
2. Open Query Tool for that database.
3. Run `assignment_iii_postgresql.sql` from top to bottom. The SQL file starts with table creation; database creation is done in pgAdmin because PostgreSQL `CREATE DATABASE` cannot run inside a transaction.
4. Capture the actual result grids/messages for all tasks.
5. Generate an ERD in pgAdmin using **ERD For Database** and export the actual diagram as `erd.png`.

## Practical tasks
The SQL file contains:
- Q1.1–Q1.3: SELECT
- Q2.1–Q2.3: JOIN
- Q3.1–Q3.3: UPDATE with verification queries
- Q4.1–Q4.3: ALTER TABLE with structure/data verification
- Q5.1–Q5.3: INSERT with verification queries

**Execution note:** Q1.2 should be run before Q3.2, because Q3.2 changes the category from `Technology` to `Computing`. If rerunning the script, use a fresh empty database or carefully reset the tables first.

## ERD
After exporting the actual diagram from pgAdmin, save it as `erd.png` and include it below:

![ERD](erd.png)

## Submission checklist
- [ ] Replace database name with your own name and student ID.
- [ ] Execute the script successfully in PostgreSQL.
- [ ] Save genuine screenshots of the executed statements and results.
- [ ] Export the real DBMS-generated ERD as `erd.png`.
- [ ] Add `README.md`, `assignment_iii_postgresql.sql`, and `erd.png` to a public GitHub repository.
- [ ] Submit the repository link using the Google Form in the assignment.
- [ ] Handwrite the report and redraw the ERD by hand.
- [ ] Be ready to explain every SQL statement and result.
