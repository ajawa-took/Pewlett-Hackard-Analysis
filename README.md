# Pewlett-Hackard-Analysis


## Overview of the analysis
### the purpose of the new analysis

 For each employee title, we count the number of employees who currently hold that title and are eligible to retire.

 We build a table of employees eligible for mentorship, including their titles and the dates when they started working for their current department. This immediately gives a count of such employees, and allows for further analysis.


## Results
### four major points

 - Pew_hack is about to lose a ton of senior employees: 26 thousand senior engineers and 25 thousand senior staff.
 - Much fewer un-senior staff are eligible for retirement: nine thousand enginers, seven and a half thousand staff.
 - Only two managers are close to retirement.
 - 1549 employees are eligible for mentorship.


## Summary

### Two further questions.
1. What titles to the employees eligible for mentorship hold? This would help Pew-Hack provide appropriate mentorship.
2. What salaries do the employees eligible for retirement currently have? This would help Pew-Hack estimate its pension obligations: this data is from 1990s when most retirement plans are defined-benefit.

### Two additional queries.

1. The suggested approach for building the mentorship table selects one of an employee's titles at random. We already improved the query to select the most recent title instead:
```
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
```
2. To answer Question 1, run
```
select title, count(*) as ct
from mentorship_eligibilty
group by title
order by ct desc;
```

