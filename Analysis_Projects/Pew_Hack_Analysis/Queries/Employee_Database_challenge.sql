
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

select * from retiring_titles;
  