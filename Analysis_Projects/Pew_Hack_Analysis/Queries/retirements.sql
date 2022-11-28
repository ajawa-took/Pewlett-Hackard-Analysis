
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

-- new table with retirement-eligible people; should have id's as well.
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

select * from retirement_info;