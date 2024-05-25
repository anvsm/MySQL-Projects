use company_analysis;

select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employee_titles;
select * from employees;
select * from salaries;

create procedure departments()
select * from departments;

call departments;

create procedure dept_emp()
select * from dept_emp;

call dept_emp;

create procedure dept_manager()
select * from dept_manager;

call dept_manager;

create procedure emp_titles()
select * from employee_titles;

call emp_titles;

create procedure emp()
select * from employees;

call emp;

create procedure salaries()
select * from salaries;

call salaries;

call departments;
call dept_emp;
call dept_manager;
call emp;
call salaries;

-- Retrieve the first name and last name of all employees

select first_name, last_name from employees;

-- Find the department numbers and names

select * from departments;

-- Get the total number of employees

select count(emp_no) as total_no_of_emp from employees;

-- Find the average salary of all employees

select avg(salary) as avg_salary from salaries;

-- Retrieve the birth date and hire date of employee with emp_no 10003

select birth_date, hire_date from employees
where emp_no = 10003;

--  Find the titles of all employees.

select emp_no,departments.dep_no, dep_name from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no;

-- Get the total number of departments.

select count(dep_no) as total_depts from departments;

-- Retrieve the department number and name where employee with emp_no 10004 works

call departments;
call dept_emp;
call emp;

select dept_emp.emp_no, departments.dep_no, dep_name from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
join employees on 
employees.emp_no = dept_emp.emp_no
where employees.emp_no = 10004;

-- Find the gender of employee with emp_no 10007

call emp;

select gender from employees 
where emp_no = 10007;

-- Get the highest salary among all employees

call salaries;

select max(salary) as highest_Sal from salaries;

-- Retrieve the names of all managers along with their department names

call emp_titles;
call emp;
call dept_emp;
call departments;


select first_name, last_name, title, departments.dep_name from employee_titles
join employees on 
employee_titles.emp_no = employees.emp_no
join dept_emp on dept_emp.emp_no = employees.emp_no
join departments on dept_emp.dept_no = departments.dep_no
where employee_titles.title = 'Manager';

-- Find the department with the highest number of employees.

call departments;
call dept_emp;

select departments.dep_no, dep_name, count(emp_no) from departments
join dept_emp on
departments.dep_no = dept_emp.dept_no
group by departments.dep_no, dep_name 
order by count(emp_no) desc;

-- Retrieve the employee number, first name, last name, and salary of employees earning more 
-- than $60,000

call emp;
call salaries;

select employees.emp_no , first_name, last_name, salary from employees
join salaries on 
employees.emp_no = salaries.emp_no
where salary > 60000;

-- Get the average salary for each department

call departments;
call dept_emp;
call salaries;

select avg(salary) as avg_salary, dep_name from departments 
left join dept_emp on 
departments.dep_no = dept_emp.dept_no
left join salaries on 
salaries.emp_no = dept_emp.emp_no
group by departments.dep_name
union
select avg(salary) as avg_salary, dep_name from departments 
right join dept_emp on 
departments.dep_no = dept_emp.dept_no
right join salaries on 
salaries.emp_no = dept_emp.emp_no
group by departments.dep_name;

-- Retrieve the employee number, first name, last name, and title of all employees who are 
-- currently managers

call emp;
call emp_titles;

select employees.emp_no, first_name, last_name, title from employees
join employee_titles
on 
employees.emp_no = employee_titles.emp_no
where title = 'Manager';

-- Find the total number of employees in each department

call departments;
call dept_emp;

select dep_name, dept_emp.dept_no, count(emp_no) as toal_employees from departments
join dept_emp on 
dept_emp.dept_no = departments.dep_no
group by dep_name, dept_emp.dept_no;

-- Retrieve the department number and name where the most recently hired employee works

call departments;
call dept_emp;

select departments.dep_no, dep_name, max(from_date)
from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
group by departments.dep_no, dep_name;


-- Get the department number, name, and average salary for departments with more than 3 
-- employees
-- Ans. there is no department which has more than 3 employees based on previous queries analysis.


-- Retrieve the employee number, first name, last name, and title of all employees hired in 2005

call emp;
call emp_titles;

select employees.emp_no, first_name, last_name, title from employees
join employee_titles on 
employees.emp_no = employee_titles.emp_no 
where year(str_to_date(hire_date, '%m/%d/%Y')) = 2005;

-- Find the department with the highest average salary

call departments;
call dept_emp;
call salaries;

select departments.dep_name as d_name, departments.dep_no, max(avg_salary) as max_avg_salary from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
join 
( select emp_no , avg(salary) as avg_salary
	from salaries
    group by emp_no
)
as avg_salaries on 
dept_emp.emp_no = avg_salaries.emp_no
group by departments.dep_name,departments.dep_no,avg_salary
order by avg_salary desc
LIMIT 1;

--  Retrieve the employee number, first name, last name, and salary of employees hired before the 
-- year 2005

call salaries;
call emp;

select distinct(salaries.emp_no), first_name, last_name, salary from employees
join salaries on 
employees.emp_no = salaries.emp_no
where hire_date = year(str_to_date(hire_date, '%m/%d/%y')) < 2005 ;


-- Get the department number, name, and total number of employees for departments with a 
-- female manager

call departments;
call dept_emp;
call emp_titles;
call emp;

select departments.dep_no, dep_name, count(dept_emp.emp_no) as total_emp, title from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
join employee_titles on 
dept_emp.emp_no = employee_titles.emp_no 
join employees on 
employees.emp_no = employee_titles.emp_no
where employee_titles.title = 'Manager' and employees.gender = 'F'
group by departments.dep_no, dep_name, title;

-- Retrieve the employee number, first name, last name, and department name of employees who 
-- are currently working in the Finance department

call emp;
call departments;
call dept_emp;

select employees.emp_no, first_name, last_name, dep_name from employees
join dept_emp on 
employees.emp_no = dept_emp.emp_no 
join departments on 
departments.dep_no = dept_emp.dept_no
where dep_name = 'Finance';

-- Find the employee with the highest salary in each department.

call salaries;
call dept_emp;
call departments;

select departments.dep_no, dep_name, max(highest_salary) as max_highest_Salary_in_each_dept from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
join
(select emp_no, max(salary) as highest_salary from salaries
group by emp_no
) as high_salary on
high_salary.emp_no  = dept_emp.emp_no
group by departments.dep_no, dep_name;

-- Retrieve the employee number, first name, last name, and department name of employees who 
-- have held a managerial position.

call emp;
call emp_titles;
call departments;
call dept_emp;

select employees.emp_no, first_name, last_name, dep_name, title from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
join employee_titles on 
dept_emp.emp_no = employee_titles.emp_no
join employees on 
employees.emp_no = employee_titles.emp_no
where employee_titles.title in ('Manager', 'Senior Manager');

-- Get the total number of employees who have held the title "Senior Manager."

call emp_titles;
call emp;

select title, count(employees.emp_no) as total_employee, employees.emp_no from employees
join employee_titles on 
employees.emp_no = employee_titles.emp_no
where employee_titles.title = 'Senior Manager'
group by title,employees.emp_no;

-- Retrieve the department number, name, and the number of employees who have worked there 
-- for more than 5 years

call departments;
call dept_emp;

select departments.dep_no, dep_name, count(dept_emp.emp_no) as total_employees from departments
join dept_emp on 
departments.dep_no = dept_emp.dept_no
where timestampdiff 
(year, str_to_date(to_date, '%m/%d/%y'), str_to_date(from_date, '%m/%d/%y')) > 5
group by departments.dep_no, dep_name;

-- Find the employee with the longest tenure in the company

call dept_emp;

select emp_no, max(timestampdiff(year, str_to_date(to_date, '%m/%d/%y'), str_to_date(from_date, '%m/%d/%y')))
as longest_tenure from dept_emp
group by emp_no
order by longest_tenure desc
LIMIT 1;

-- Retrieve the employee number, first name, last name, and title of employees whose hire date is 
-- between '2005-01-01' and '2006-01-01'

call emp;
call emp_titles;

select employees.emp_no, first_name, last_name, title from employees
left join employee_titles on 
employees.emp_no = employee_titles.emp_no 
where str_to_date(hire_date, '%m/%d/%y') between '2005-01-01' and '2006-01-01';

-- Get the department number, name, and the oldest employee's birth date for each department.

call departments;
call dept_emp;
call emp;

select departments.dep_no, dep_name, max(birth_date) as oldest_emp from departments
left join dept_emp on 
departments.dep_no = dept_emp.dept_no
left join employees on 
employees.emp_no = dept_emp.emp_no 
group by departments.dep_no, dep_name
union
select departments.dep_no, dep_name, max(birth_date) as oldest_emp from departments
right join dept_emp on 
departments.dep_no = dept_emp.dept_no
right join employees on 
employees.emp_no = dept_emp.emp_no 
group by departments.dep_no, dep_name;

