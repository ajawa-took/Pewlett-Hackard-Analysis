
select e.emp_no, e.first_name, e.last_name,
	t.title, t.from_date, t.to_date
into retirement_titles
from employees e left join titles t
on e.emp_no = t.emp_no
where birth_date BETWEEN '1952-01-01' AND '1955-12-31'
order by e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
--SELECT DISTINCT ON (emp_no) emp_no,
--    first_name, last_name, title
--INTO nameyourtable
--FROM retirement_titles
--WHERE to_date = '9999-01-01'
--ORDER BY emp_no, to_date DESC;
-- In the above query, the "where" clause makes
-- the "distinct" clause and the "order by to_date" clause do nothing.
-- Much simpler query used below produces same output.

-- next query output 1 verifies no emp_no duplicates for current titles
SELECT max(ct) from
    (SELECT emp_no, count(*) as ct from
        (SELECT * from retirement_titles where to_date = '9999-01-01'
         ) as subsubq
     GROUP BY emp_no
     ) as subq;


SELECT emp_no, first_name, last_name, title 
into unique_titles
from retirement_titles
where to_date = '9999-01-01';


select title, count(*) as ct
into retiring_titles
from unique_titles
group by title
order by ct desc;

-- checking output
select * from retiring_titles;

-- Deliv 2

-- first try;
-- from above, know that all duplicates from "join dept_emp" get removed by "current"
-- may be new duplicates from "join titles"
select
 e.emp_no, e.first_name, e.last_name, e.birth_date,
 d.from_date, d.to_date, t.title
from employees e
left join dept_emp d on e.emp_no = d.emp_no
left join titles t on e.emp_no = t.emp_no
where (d.to_date = '9999-01-01' )
 and (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
order by e.emp_no;

-- explore selection of titles in the provided output for 10291, 10476

select * from titles
where (emp_no = 10291) or (emp_no = 10476);

select * from dept_emp
where (emp_no = 10291) or (emp_no = 10476);

-- each has only one record in dept_emp
-- each has 2 records in titles: both joined in 1987 as 'Staff'
-- and were promoted to 'Senior Staff' in 1994
-- provided output gives different totles for them; but should give 'senior' to both

-- let's see, do all employees with current dept also have a current title?

select max(ct), count(*) from         -- returns (1, 240,124) no dupes, and 240,124 emp_no
    ( select emp_no, count(*) as ct
        from dept_emp 
        where to_date = '9999-01-01'
        group by emp_no
    ) as stuff;

select max(ct), count(*) from         -- returns (1, 240,124): no dupes, same count
    ( select emp_no, count(*) as ct
        from titles 
        where to_date = '9999-01-01'
        group by emp_no
    ) as stuff;

-- So, the right thing to do is use to_date from titles,
-- and then I don't need dept_emp at all - no, they want from_date
-- and we know that's gonna be different from two emp_no's we looked at above:
-- their title.from_date (for current title) is in 1994, but for current dept is in 1987

-- second try: just chnage the table from which to_date is taken
-- AND need to restrict dept_emp's to_date as well, or else dupes return
select
 e.emp_no, e.first_name, e.last_name, e.birth_date,
 d.from_date, t.to_date, t.title
into mentorship_eligibilty
from employees e
left join dept_emp d on e.emp_no = d.emp_no
left join titles t on e.emp_no = t.emp_no
where (t.to_date = '9999-01-01' )
 and (d.to_date = '9999-01-01')
 and (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
order by e.emp_no;
