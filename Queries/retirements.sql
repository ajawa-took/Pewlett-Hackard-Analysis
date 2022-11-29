
-- count employees by birth year: 1952, 53, 54, 55 are the retire-soon pool
SELECT yr, count(*)
FROM (SELECT extract(year from birth_date) as yr FROM employees) AS biryrs 
group by yr
order by yr;

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

drop table retirement_info;

-- new table with retirement-eligible people
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

select * from retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no, ri.first_name, ri.last_name, de.dept_no, de.to_date
into current_emp
FROM retirement_info as ri
    LEFT JOIN dept_emp as de
    ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

select dept_no, count(emp_no)   -- 2048 for d006, correcter
from current_emp
group by dept_no
order by dept_no;

SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
into current_emp_orig
FROM retirement_info as ri
    LEFT JOIN dept_emp as de
    ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- maybe-retiring employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no     -- 2,234 fo d006, overcount, see below
FROM current_emp_orig as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
order by de.dept_no;

select count(*) from current_emp; --33,118
select count(*) from current_emp_orig; --same

SELECT COUNT(*)                 --36,619 double-counting employees with mult dept, etc
FROM current_emp_orig as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no;

select max(ct)                  --1 no multiples
from (select emp_no, count(*) as ct
    from current_emp
    group by emp_no) as bob;

select *                  --3,501 emp_no appear twice!
from (select ce.emp_no, count(*) as ct
    FROM current_emp_orig as ce
        LEFT JOIN dept_emp as de
        ON ce.emp_no = de.emp_no
    group by ce.emp_no) as bob
where ct > 1
order by emp_no;


