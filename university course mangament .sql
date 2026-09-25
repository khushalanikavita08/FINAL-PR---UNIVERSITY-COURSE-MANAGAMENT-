CREATE DATABASE UniversityCourseManagement;
--create departments table 

CREATE TABLE Departmentss_details (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departmentss_details
(DepartmentID, DepartmentName)
VALUES
(1, 'Computer Science'),
(2, 'Mathematics');


--create students table

CREATE TABLE Studentss_details (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Studentss_details
(StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

--create courses table

CREATE TABLE Courses_details (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES  Departmentss_details
	(DepartmentID)
);

INSERT INTO Courses_details
(CourseID, CourseName, DepartmentID, Credits)
VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);


--create instructors table

CREATE TABLE Instructorss_details (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES  Departmentss_details(DepartmentID)
);

INSERT INTO Instructorss_details
(InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2);
ALTER TABLE Instructorss_details
ADD Salary NUMERIC;

UPDATE Instructorss_details
SET Salary = 70000
WHERE InstructorID = 1;

UPDATE Instructorss_details
SET Salary = 60000
WHERE InstructorID = 2;

--create enrollemts table
CREATE TABLE Enrollmentss_details (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,

    FOREIGN KEY (StudentID)
    REFERENCES  Studentss_details(StudentID),

    FOREIGN KEY (CourseID)
    REFERENCES  Courses_details(CourseID)
);

INSERT INTO Enrollmentss_details
(EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');


-- 1. PERFORM CRUD OPERATIONS ON ALL TABLES

-- STUDENTS TABLE

--create
INSERT INTO Studentss_details
VALUES
(3, 'Rahul', 'Patel', 'rahul@email.com', '2001-06-10', '2023-08-01');

--READ
SELECT * FROM Studentss_details;

--update
UPDATE  Studentss_details
SET Email = 'rahul.patel@email.com'
WHERE StudentID = 3;

--delete
DELETE FROM  Studentss_details
WHERE StudentID = 3;

-- COURSES TABLE

--create
INSERT INTO  Courses_details
VALUES
(103, 'Operating Systems', 1, 4);

--read
SELECT * FROM  Courses_details;

--update
UPDATE  Courses_details
SET Credits = 4
WHERE CourseID = 102;

--delete
DELETE FROM  Courses_details
WHERE CourseID = 103;

-- INSTRUCTORS TABLE
--create
INSERT INTO  Instructorss_details
VALUES
(3, 'David', 'Shah', 'david@univ.com', 1);

--read
SELECT * FROM  Instructorss_details;

--update
UPDATE  Instructorss_details
SET Email = 'david.shah@univ.com'
WHERE InstructorID = 3;

--delete
DELETE FROM  Instructorss_details
WHERE InstructorID = 3;

-- ENROLLMENTS TABLE

--create
INSERT INTO  Enrollmentss_details
VALUES
(3, 1, 102, '2023-08-01');

--read
SELECT * FROM  Enrollmentss_details;

--update
UPDATE  Enrollmentss_details
SET EnrollmentDate = '2023-08-15'
WHERE EnrollmentID = 3;

--delete
DELETE FROM  Enrollmentss_details
WHERE EnrollmentID = 3;


-- DEPARTMENTS TABLE

--create
INSERT INTO  Departmentss_details
VALUES
(3, 'Physics');

--read
SELECT * FROM  Departmentss_details;

--update
UPDATE  Departmentss_details
SET DepartmentName = 'Physics and Science'
WHERE DepartmentID = 3;

--delete
DELETE FROM  Departmentss_details
WHERE DepartmentID = 3;

-- 2. RETRIEVE STUDENTS WHO ENROLLED AFTER 2022

SELECT *
FROM  Studentss_details
WHERE EnrollmentDate > '2022-12-31';

-- 3. RETRIEVE COURSES OFFERED BY THE MATHEMATICS DEPARTMENT WITH A LIMIT OF 5 COURSE

SELECT
    c.CourseID,
    c.CourseName,
    c.DepartmentID,
    c.Credits
FROM  Courses_details c
INNER JOIN  Departmentss_details d
ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;


-- 4. GET NUMBER OF STUDENTS ENROLLED IN EACH COURSE FILTERING FOR COURSES WITH MORE THAN 5 STUDENTS

SELECT
    c.CourseID,
    c.CourseName,
    COUNT(e.StudentID) AS StudentCount
FROM  Courses_details c
INNER JOIN  Enrollmentss_details e
ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(e.StudentID) > 5;

-- 5. FIND STUDENTS ENROLLED IN BOTH INTRODUCTION TO SQL AND DATA STRUCTURES

SELECT
    s.StudentID,
    s.FirstName,
    s.LastName
FROM  Studentss_details s
INNER JOIN  Enrollmentss_details e
ON s.StudentID = e.StudentID
INNER JOIN  Courses_details c
ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures')
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT c.CourseName) = 2;

-- 6. FIND STUDENTS WHO ARE EITHER ENROLLED IN  INTRODUCTION TO SQL OR DATA STRUCTURES

SELECT DISTINCT
    s.StudentID,
    s.FirstName,
    s.LastName
FROM  Studentss_details s
INNER JOIN  Enrollmentss_details e
ON s.StudentID = e.StudentID
INNER JOIN  Courses_details c
ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

-- 7. CALCULATE THE AVERAGE NUMBER OF CREDITS FOR ALL COURSES

SELECT
    AVG(Credits) AS AverageCredits
FROM  Courses_details;

-- 8. FIND THE MAXIMUM SALARY OF INSTRUCTORS IN THE COMPUTER SCIENCE DEPARTMENT
SELECT MAX(i.Salary) AS MaxSalary
FROM Instructorss_details i
JOIN  Departmentss_details d
ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

-- 9. COUNT THE NUMBER OF STUDENTS ENROLLED IN EACH DEPARTMENT

SELECT
    d.DepartmentID,
    d.DepartmentName,
    COUNT(DISTINCT e.StudentID) AS StudentCount
FROM  Departmentss_details d
LEFT JOIN  Courses_details c
ON d.DepartmentID = c.DepartmentID
LEFT JOIN  Enrollmentss_details e
ON c.CourseID = e.CourseID
GROUP BY d.DepartmentID, d.DepartmentName;

-- 10. INNER JOINS RETRIEVE STUDENTS AND THEIR CORRESPONDING COURSES

SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    c.CourseID,
    c.CourseName
FROM  Studentss_details s
INNER JOIN  Enrollmentss_details e
ON s.StudentID = e.StudentID
INNER JOIN  Courses_details c
ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN:RETRIEVE ALL STUDENTS AND THEIR CORRESPONDING COURSES, IF ANY

SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    c.CourseID,
    c.CourseName
FROM  Studentss_details s
LEFT JOIN  Enrollmentss_details e
ON s.StudentID = e.StudentID
LEFT JOIN  Courses_details c
ON e.CourseID = c.CourseID;

-- 12. SUBQUERY: FIND STUDENTS ENROLLED IN COURSES THAT HAVE MORE THAN 10 STUDENTS

SELECT
    s.StudentID,
    s.FirstName,
    s.LastName
FROM  Studentss_details s
INNER JOIN  Enrollmentss_details e
ON s.StudentID = e.StudentID
WHERE e.CourseID IN
(
    SELECT CourseID
    FROM  Enrollmentss_details
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);


-- 13. EXTRACT THE YEAR FROM THE ENROLLMENTDATE  OF STUDENTS

SELECT
    StudentID,
    FirstName,
    LastName,
    EXTRACT(YEAR FROM EnrollmentDate) AS EnrollmentYear
FROM  Studentss_details;

-- 14. CONCATENATE THE INSTRUCTOR'S FIRST AND LAST NAME

SELECT
    InstructorID,
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM  Instructorss_details;


-- 15. CALCULATE THE RUNNING TOTAL OF STUDENTS ENROLLED IN COURSES

SELECT
    EnrollmentID,
    StudentID,
    CourseID,
    EnrollmentDate,
    COUNT(*) OVER
    (
        ORDER BY EnrollmentDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM  Enrollmentss_details;


-- 16. LABEL STUDENTS AS SENIOR OR JUNIOR BASED ON THEIR YEAR OF ENROLLMENT

SELECT
    StudentID,
    FirstName,
    LastName,
    EnrollmentDate,
    CASE
        WHEN EnrollmentDate < CURRENT_DATE - INTERVAL '4 years'
        THEN 'Senior'
        ELSE 'Junior'
    END AS StudentLevel
FROM  Studentss_details;
