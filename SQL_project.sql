-- 1. Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.
create database employee;
use employee;

-- 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
from emp_record_table;

/* 4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
 less than two
 greater than four 
 between two and four */
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING < 2;

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING > 4;

select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
from emp_record_table
where EMP_RATING >= 2 and EMP_RATING <=4;

-- 5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
select concat(FIRST_NAME, " ", LAST_NAME) AS NAME, DEPT
from emp_record_table
where DEPT = 'FINANCE';

-- 6. Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
select MANAGER_ID, count(distinct EMP_ID) as emp_count
from emp_record_table
group by 1
order by 2 desc;

-- 7. Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
select EMP_ID, FIRST_NAME, LAST_NAME, DEPT
from emp_record_table
where DEPT = 'healthcare'
union all
select EMP_ID, FIRST_NAME, LAST_NAME, DEPT
from emp_record_table
where DEPT = 'finance';

-- 8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, max(EMP_RATING) AS max_rating
from emp_record_table
group by 5
order by 6 desc;

-- 9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
select distinct ROLE, min(SALARY) as min_salary, max(SALARY) as max_salary
from emp_record_table
group by 1;

-- 10. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
select EMP_ID, EXP, dense_rank() over(order by EXP desc) as rankings
from emp_record_table;

-- 11. Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
create view employee_6000 as
	select EMP_ID, COUNTRY, SALARY
    from emp_record_table
    where SALARY > 6000;
    
-- 12. Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
select EMP_ID, FIRST_NAME, LAST_NAME, EXP
from emp_record_table
where EXP in (select EXP from emp_record_table where EXP > 10);

-- 13. Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
DELIMiTER $$
create procedure morethan_3exp ()
begin
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP
from emp_record_table
where EXP > 3;
end$$

call morethan_3exp();

/* 14. Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.

 The standard being:

For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'. */
DELIMITER $$
create function match_profile (EXP int)
returns varchar(50)
deterministic
begin
	declare ROLE varchar(50);
    if EXP <= 2 then
		set ROLE = 'JUNIOR DATA SCIENTIST';
	elseif EXP between 2 and 5 then
		set ROLE = 'ASSOCIATE DATA SCIENTIST';
	elseif EXP between 5 and 10 then
		set ROLE = 'SENIOR DATA SCIENTIST';
	elseif EXP between 10 and 12 then
		set ROLE = 'LEAD DATA SCIENTIST';
	elseif EXP between 12 and 16 then
		set ROLE = 'MANAGER';
	end if;
    return(ROLE);
end $$
delimiter ;

select EMP_ID, FIRST_NAME, LAST_NAME, EXP, match_profile(EXP)
from emp_record_table;

-- 15. Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
CREATE UNIQUE INDEX name_perf ON emp_record_table(FIRST_NAME(100));
SHOW INDEX from emp_record_table;
SELECT * FROM emp_record_table
WHERE FIRST_NAME LIKE 'Eric%';

-- 16. Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
		(0.05*SALARY*EMP_RATING) AS BONUS
FROM emp_record_table;

-- 17. Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS AVERAGE_SALARY
FROM emp_record_table
GROUP BY 1,2;