-- ======================================
-- ENTREGA WEEK 4 — TECHMASTER UNIVERSITY
-- Nombre: [Rafael Zerpa]  |  Fecha: [17/07/2026]
-- ======================================

-- PARTE 1: DDL — Crear las 5 tablas 
DROP DATABASE IF EXISTS techmaster_university;
CREATE DATABASE techmaster_university;
USE techmaster_university;

SELECT DATABASE();  
-- 1. Departamentos
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    budget DECIMAL(12, 2),
    founding_date DATE
);
-- 2. Profesores (con jefe — relación recursiva: SELF FK)
CREATE TABLE professors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    department_id INT,
    manager_id INT,
    salary DECIMAL(10, 2),
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (manager_id) REFERENCES professors(id)
);
-- 3. Estudiantes
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    birth_date DATE,
    enrollment_date DATE,
    gpa DECIMAL(4, 2),
    status ENUM('active', 'graduated', 'withdrawn') DEFAULT 'active'
);
-- 4. Cursos (cada curso impartido por un profesor, en un departamento)
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    professor_id INT,
    department_id INT NOT NULL,
    max_capacity INT DEFAULT 30,
    semester VARCHAR(10),
    FOREIGN KEY (professor_id) REFERENCES professors(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
-- 5. Inscripciones (N:M entre estudiantes y cursos — PK compuesta, como en Week 3)
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    grade DECIMAL(4, 2) CHECK (grade >= 0 AND grade <= 10),
    status ENUM('enrolled', 'passed', 'failed', 'withdrawn') DEFAULT 'enrolled',
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

# PARTE 2: DML — datos (Fase 1.3)
-- Departamentos (5)
INSERT INTO departments (name, budget, founding_date) VALUES
    ('Computer Science', 5000000.00, '1998-08-15'),
    ('Mathematics',      3500000.00, '1995-01-10'),
    ('Physics',          4200000.00, '1995-01-10'),
    ('Humanities',       2000000.00, '2005-03-22'),
    ('Biology',          3800000.00, '2000-09-01');

-- Profesores (11) — id 1, 2, 6, 8, 9 son jefes de depto (manager_id NULL)
INSERT INTO professors (name, email, department_id, manager_id, salary, hire_date) VALUES
    ('Dr. Robert Mendez',   'rmendez@uni.edu',   1, NULL, 95000, '2010-08-01'),  -- 1  Jefe Computer Science
    ('Dr. Sara Lopez',      'slopez@uni.edu',    2, NULL, 92000, '2008-01-15'),  -- 2  Jefa Mathematics
    ('Dr. Michael Vega',    'mvega@uni.edu',     1,    1, 78000, '2015-03-10'),  -- 3
    ('Dr. Anna Torres',     'atorres@uni.edu',   1,    1, 76000, '2017-09-05'),  -- 4
    ('Dr. Charles Ruiz',    'cruiz@uni.edu',     2,    2, 72000, '2018-02-12'),  -- 5
    ('Dr. Elena Martinez',  'emartinez@uni.edu', 3, NULL, 88000, '2012-08-20'),  -- 6  Jefa Physics
    ('Dr. Felix Castro',    'fcastro@uni.edu',   3,    6, 70000, '2019-01-15'),  -- 7
    ('Dr. Gabrielle Perez', 'gperez@uni.edu',    4, NULL, 75000, '2014-09-01'),  -- 8  Jefa Humanities
    ('Dr. Hector Silva',    'hsilva@uni.edu',    5, NULL, 80000, '2013-08-15'),  -- 9  Jefe Biology
    ('Dr. Isabel Ramos',    'iramos@uni.edu',    5,    9, 68000, '2020-03-01'),  -- 10
    ('Dr. James Nunez',     'jnunez@uni.edu',    4,    8, 65000, '2021-09-10');  -- 11

-- Estudiantes (12)
INSERT INTO students (name, email, birth_date, enrollment_date, gpa, status) VALUES
    ('Alice Garcia',    'agarcia@uni.edu',    '2002-05-15', '2020-08-20', 8.5,  'active'),
    ('Brian Hernandez', 'bhernandez@uni.edu', '2001-11-22', '2020-08-20', 7.2,  'active'),
    ('Carol Ruiz',      'cruiz.stu@uni.edu',  '2003-03-10', '2021-08-20', 9.1,  'active'),
    ('Daniel Torres',   'dtorres@uni.edu',    '2002-07-08', '2020-08-20', 8.8,  'active'),
    ('Emma Lopez',      'elopez.stu@uni.edu', '2001-12-30', '2019-08-20', 9.5,  'graduated'),
    ('Frank Salinas',   'fsalinas@uni.edu',   '2003-04-25', '2021-08-20', 6.8,  'active'),
    ('Grace Mendez',    'gmendez@uni.edu',    '2002-09-12', '2020-08-20', 8.2,  'active'),
    ('Hugo Vega',       'hvega@uni.edu',      '2003-06-18', '2022-08-20', 7.9,  'active'),
    ('Irene Castro',    'icastro@uni.edu',    '2001-10-05', '2019-08-20', 5.5,  'withdrawn'),
    ('Jacob Nunez',     'jnunez.stu@uni.edu', '2002-08-29', '2020-08-20', 8.0,  'active'),
    ('Karla Romero',    'kromero@uni.edu',    '2003-01-17', '2022-08-20', NULL, 'active'),  -- sin GPA
    ('Lucas Aguilar',   'laguilar@uni.edu',   '2004-02-22', '2023-08-20', NULL, 'active');  -- nuevo, sin notas

-- Cursos (12) — COMP401 sin profesor asignado (professor_id NULL)
INSERT INTO courses (code, name, credits, professor_id, department_id, max_capacity, semester) VALUES
    ('COMP101', 'Introduction to Programming', 4, 1,    1, 30, '2026-1'),
    ('COMP201', 'Data Structures',             4, 3,    1, 25, '2026-1'),
    ('COMP301', 'Databases',                   4, 4,    1, 25, '2026-1'),
    ('MATH101', 'Differential Calculus',       5, 2,    2, 35, '2026-1'),
    ('MATH201', 'Linear Algebra',              4, 5,    2, 30, '2026-1'),
    ('PHYS101', 'General Physics',             4, 6,    3, 30, '2026-1'),
    ('PHYS202', 'Quantum Mechanics',           5, 7,    3, 20, '2026-1'),
    ('HUMA101', 'Contemporary Philosophy',     3, 8,    4, 40, '2026-1'),
    ('HUMA201', 'Latin American Literature',   3, 11,   4, 40, '2026-1'),
    ('BIOL101', 'Cell Biology',                4, 9,    5, 28, '2026-1'),
    ('BIOL202', 'Molecular Genetics',          5, 10,   5, 22, '2026-1'),
    ('COMP401', 'Distributed Systems',         4, NULL, 1, 20, '2026-1');  -- sin profesor asignado

-- Inscripciones (27) — N:M estudiante ↔ curso
INSERT INTO enrollments (student_id, course_id, grade, status) VALUES
    (1, 1, 9.0,  'passed'),   (1, 4, 8.5,  'passed'),   (1, 6, NULL, 'enrolled'),  -- Alice
    (2, 1, 7.0,  'passed'),   (2, 4, 6.5,  'failed'),   (2, 8, NULL, 'enrolled'),  -- Brian
    (3, 1, 9.5,  'passed'),   (3, 2, 9.0,  'passed'),   (3, 3, NULL, 'enrolled'),
    (3, 4, 9.8,  'passed'),                                                         -- Carol
    (4, 1, 8.5,  'passed'),   (4, 2, 9.0,  'passed'),   (4, 3, NULL, 'enrolled'),  -- Daniel
    (5, 1, 9.5,  'passed'),   (5, 2, 9.8,  'passed'),   (5, 3, 9.5,  'passed'),
    (5, 4, 10.0, 'passed'),                                                         -- Emma (graduada)
    (6, 4, 5.5,  'failed'),   (6, 8, 7.0,  'passed'),                               -- Frank
    (7, 6, 8.5,  'passed'),   (7, 7, NULL, 'enrolled'),                             -- Grace
    (8, 1, NULL, 'enrolled'), (8, 4, NULL, 'enrolled'),                             -- Hugo
    -- Irene (withdrawn): sin inscripciones, a propósito
    (10, 8, 7.5, 'passed'),   (10, 9, NULL, 'enrolled'),                            -- Jacob
    (11, 1, NULL, 'enrolled'), (11, 4, NULL, 'enrolled');                           -- Karla
    -- Lucas: sin inscripciones todavía (recién ingresó)
    
INSERT INTO enrollments (student_id, course_id, grade, status)
VALUES (2, 1, NULL, 'enrolled'); #error

-- PARTE 3: Queries 1-3   (INNER JOIN)
#query 1— Empieza por el sujeto de la pregunta. "Cada profesor" → arranca en professors:
SELECT p.id, p.name
FROM professors p;
SELECT p.id, p.name, d.name as department
FROM professors p
INNER JOIN departments d ON p.department_id = d.id;

#pulido de formato
SELECT p.name AS professor, d.name AS department
FROM professors p
INNER JOIN departments d ON p.department_id = d.id
ORDER BY d.name, p.name;

#query 2 cursos con su profesor y departamento. (2 inner joins)
SELECT
    c.code,
    c.name AS course,
    p.name AS professor,
    d.name AS department
FROM courses c
INNER JOIN professors p  ON c.professor_id = p.id
INNER JOIN departments d ON c.department_id = d.id
ORDER BY d.name, c.code;

#query 3 estudiantes en calculus math01 con su clasificación
SELECT s.name AS student, e.grade, e.status
FROM students s
INNER JOIN enrollments e ON s.id = e.student_id
INNER JOIN courses c     ON e.course_id = c.id
WHERE c.code = 'MATH101'
  AND e.grade IS NOT NULL
ORDER BY e.grade DESC;

-- PARTE 4: Queries 4-6   (LEFT JOIN + huérfanos)
#query 4 todos los cursos, incluso sin profesor
#step 1
SELECT c.code, c.name, p.name AS professor
FROM courses c
INNER JOIN professors p ON c.professor_id = p.id
ORDER BY c.code;
#step 2
SELECT c.code, c.name, p.name AS professor
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.id
ORDER BY c.code;

#step 3 traducir null
SELECT
    c.code,
    c.name,
    COALESCE(p.name, '(unassigned)') AS professor
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.id
ORDER BY c.code;

#query 5 todos estudiantes con su número de cursos
SELECT
    s.name AS student,
    COUNT(e.course_id) AS num_courses
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
GROUP BY s.id, s.name
ORDER BY num_courses DESC, s.name;

SELECT s.name, e.course_id, e.status
FROM students s
LEFT JOIN enrollments e
    ON s.id = e.student_id AND e.status = 'passed'
ORDER BY s.name, e.course_id;

SELECT s.name, e.course_id, e.status
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
WHERE e.status = 'passed'
ORDER BY s.name, e.course_id;

#query 6 profesores que NO tienen cursos asignados
SELECT p.name, d.name AS department
FROM professors p
LEFT JOIN courses c      ON p.id = c.professor_id
INNER JOIN departments d ON p.department_id = d.id
WHERE c.id IS NULL
ORDER BY p.name;

-- PARTE 5: Queries 7-9   (multi-tabla)
#encadenar 
#1
SELECT d.name FROM departments d;
#2
SELECT d.name, p.name
FROM departments d
LEFT JOIN professors p ON d.id = p.department_id;
#3
SELECT d.name, p.name, c.code
FROM departments d
LEFT JOIN professors p ON d.id = p.department_id
LEFT JOIN courses c    ON d.id = c.department_id;
#4
SELECT
    d.name AS department,
    COUNT(DISTINCT p.id) AS num_professors,
    COUNT(DISTINCT c.id) AS num_courses
FROM departments d
LEFT JOIN professors p ON d.id = p.department_id
LEFT JOIN courses c    ON d.id = c.department_id
GROUP BY d.id, d.name
ORDER BY d.name;

#Query 8 que cursos tiene c/estudiante
SELECT
    s.name AS student,
    c.code,
    c.name AS course,
    e.grade,
    e.status
FROM students s
INNER JOIN enrollments e ON s.id = e.student_id
INNER JOIN courses c     ON e.course_id = c.id
ORDER BY s.name, c.code;

#query 9
SELECT
    s.name AS student,
    c.name AS course,
    p.name AS professor
FROM students s
INNER JOIN enrollments e ON s.id = e.student_id
INNER JOIN courses c     ON e.course_id = c.id
INNER JOIN departments d ON c.department_id = d.id
LEFT JOIN professors p   ON c.professor_id = p.id
WHERE d.name = 'Computer Science'
ORDER BY s.name, c.code;

-- PARTE 6: Queries 10-12 (SELF JOIN)
#query 10
SELECT p.name, p.manager_id
FROM professors p;

SELECT p.name AS professor, m.name AS manager
FROM professors p
INNER JOIN professors m ON p.manager_id = m.id;

SELECT
    p.name AS professor,
    COALESCE(m.name, 'No manager') AS manager
FROM professors p
LEFT JOIN professors m ON p.manager_id = m.id
ORDER BY p.name;

#query 11 profesores que ganan mas $
SELECT
    p.name AS professor,
    p.salary AS professor_salary,
    m.name AS manager,
    m.salary AS manager_salary
FROM professors p
INNER JOIN professors m ON p.manager_id = m.id
WHERE p.salary > m.salary;

#query 12 pares de profesores
SELECT
    p1.name AS professor_a,
    p2.name AS professor_b,
    d.name AS department
FROM professors p1
INNER JOIN professors p2
    ON p1.department_id = p2.department_id
   AND p1.id < p2.id
INNER JOIN departments d ON p1.department_id = d.id
ORDER BY d.name, p1.name, p2.name;

SELECT s.name AS student, c.code
FROM students s
CROSS JOIN courses c
ORDER BY s.name, c.code;

-- PARTE 7: Queries 13-15 (negocio)
#query 13
SELECT
    c.code,
    c.name AS course,
    COUNT(e.student_id) AS total_enrolled
FROM courses c
INNER JOIN enrollments e ON c.id = e.course_id
WHERE e.status <> 'withdrawn'
GROUP BY c.id, c.code, c.name
ORDER BY total_enrolled DESC
LIMIT 3;

#query 14
SELECT
    s.name AS student,
    COUNT(DISTINCT c.department_id) AS num_departments
FROM students s
INNER JOIN enrollments e ON s.id = e.student_id
INNER JOIN courses c     ON e.course_id = c.id
GROUP BY s.id, s.name
HAVING COUNT(DISTINCT c.department_id) >= 2
ORDER BY num_departments DESC;

#query 15
SELECT
    d.name AS department,
    COUNT(DISTINCT p.id) AS num_professors,
    COUNT(DISTINCT c.id) AS num_courses,
    COUNT(DISTINCT e.student_id) AS unique_students
FROM departments d
LEFT JOIN professors p  ON d.id = p.department_id
LEFT JOIN courses c     ON d.id = c.department_id
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY d.id, d.name
ORDER BY num_professors DESC;

#Fin