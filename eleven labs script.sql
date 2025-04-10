CREATE DATABASE USME;
USE USME;
CREATE TABLE EMP(
 emp_id CHAR(5),
    emp_name VARCHAR(30),
    emp_address VARCHAR(50),
    emp_phone VARCHAR(10),
    emp_dep_id VARCHAR(20),
    emp_designation VARCHAR(30),
    emp_monthly_salary VARCHAR(10)
);
insert into emp value( 'Emp1', 'Maya', 'Chandighar', '9876543210' , 'Det01', 'Analyst', '500000');
insert into emp value('Emp2', 'Ana', 'London', '8765432109', 'Dept02', 'Clark', '5000'), ('Emp3', 'Adil', 'Bangalore', '7654321098','Dept01', 'Director', '750000'),
('Emp4', 'Marina', 'Bangalore', '6543210987', 'Dept02', 'Junior Analyst', '100000'), ('Emp5', 'Jessica', 'New York', '5432109876', 'Dept03', 'Manager', '75000' );
SELECT * FROM EMP;
CREATE TABLE DEPT (
    dept_id CHAR(10),
    dept_name VARCHAR(30),
    dept_location VARCHAR(30)
);
SELECT 
    *
FROM
    depT; 
insert into depT value('Fin_01', 'Finance', 'New Delhi'), ('Mgmt_02', 'Management', 'Bangalore'), ('Sales_03', 'Sales', 'Chandigarh'),
('Mkt_04', 'Marketing', 'Chandigarh'), ('Acc_05', 'Accounts', 'New Delhi');
SELECT * FROM DEPT;

select * from emp where emp_name like'a%';
select * from emp where emp_name like'%a';

# SELECT ALL EMPLOYESS THAT ARE FROM THE SAME COUNTRIES AS DEPARTMENT LOCATION.
SELECT * FROM EMP WHERE EMP_ADDRESS IN (SELECT DEPT_LOCATION FROM DEPT);
SELECT * FROM EMP;
SELECT * FROM DEPT;

use usme;
create view view_1 as 
select emp_name,emp_id 
from emp
where emp_designation= "manager";

drop view view_name;
-- once created you can use it like normal table
select * from sales_1;

Create database Gartner;
use Gartner;

create table emp (emp_id char(20),emp_name char(20), salary int, 
d_id char(20), manager_id char(20));
select*from emp;
insert into emp values ('E1','Rahul', 15000,'D1', 'M1');
insert into emp values ('E2','Manoj',15000, 'D1', 'M1');
insert into emp values ('E3', 'James', 55000, 'D2', 'M2');
insert into emp values ('E4', 'Michael',25000, 'D2', 'M2');
insert into emp values ('E5', 'Ali',20000, 'D10', 'M3');
insert into emp values ('E6', 'Robin',35000, 'D10', 'M3');
select*from emp;

create table dpt (dept_id char(20), dept_name char(50));
insert into dpt values ('D1','IT');
insert into dpt values ('D2','HR');
insert into dpt values ('D3', 'Finance');
insert into dpt values ('D4', 'Admin');
select*from dpt;

create table manager (manager_id char(20),
manager_name char(20), dept_id char(20));
insert into manager values ('M1', 'Priyam', 'D3');
insert into manager values ('M2', 'Shreya', 'D4');
insert into manager values ('M3', 'Nick', 'D1');
insert into manager values ('M4', 'Cory', 'D1');
select*from manager;

create table projects (project_id char(20), project_name char(100),
team_member_id char(20));
insert into projects values ('P1', 'Data Migration', 'E1');
insert into projects values ('P1', 'Data Migration', 'E2');
insert into projects values ('P1', 'Data Migration', 'M3');
insert into projects values ('P2', 'ETL Tool', 'E1');
insert into projects values ('P2', 'ETL Tool', 'M4');
select*from projects;
## INNER JOIN OR JOIN 
ALTER TABLE EMP CHANGE COLUMN DEPT_ID D_ID VARCHAR(5);
SELECT EMP_NAME,DEPT_NAME,D_ID
FROM EMP, DPT
WHERE D_ID = DEPT_ID;
SELECT EMP_NAME ,DEPT_NAME FROM EMP
 INNER JOIN DPT ON D_ID = DEPT_ID;
select emp.emp_id, dpt.dept_id,manager.manager_id from emp 
right join dpt on emp.d_id = dpt.dept_id 
right join manager on emp.manager_id = manager.manager_id;
create table employee like emp;
describe employee;
insert into employee select * from emp where salary < 20000;
select * from employee;
SELECT EMP_NAME,EMP_ID, DEPT_ID FROM EMP CROSS JOIN DPT;
select emp.emp_id, dpt.dept_id from emp 
right join dpt on emp.d_id = dpt.dept_id 
UNION
select emp.emp_id, dpt.dept_id from emp 
LEFT join dpt on emp.d_id = dpt.dept_id ;

CREATE database DSP;
use DSP;
-- table employee being created

create table emp(emp_id char(5), emp_name varchar(30), 
emp_phone varchar(10), emp_dept_id varchar(20), emp_designation varchar(30), 
emp_monthlysalary varchar(10)); 
describe emp;

create table dept(dept_id char(10), dept_name varchar(30), dept_location varchar(30)); 
describe dept;

insert into emp (emp_id, emp_name, emp_phone, emp_dept_id, emp_designation, emp_monthlysalary) 
values ('Emp1','Maya','9876543210','D1','Analyst',50000),
('Emp2','Ana','8765432109','D2','Clerk',10000),
('Emp3','Rhea','9765432109','D3','Managaer',80000),
('Emp4','Parth','9865432109','D4','Director',900000),
('Emp5','Aairah','7895432109','D1','Analyst',60000),
('Emp6','Sanskriti','7865432109','D2','Analyst',70000),
('Emp7','Bob','5865432109','D3','Analyst',900000);

select * from emp;

insert into dept (dept_id, dept_name, dept_location) values ('D1','Finance','New Delhi'), 
('D2','Management','Bangalore'),
('D3','Analytics','Bangalore'), ('D4','Sales','Chennai');

select * from dept;
## DEPATMNENT IN DEPT NAME
## DEPARTMENT NUMBER IN EMP
# SECLECT EMPLOYEES FROM SALES DEPARTMENT EITHER USE JOINS OR SUBQUERY

SELECT * FROM DEPT WHERE DEPT_NAME= 'SALES';
SELECT DEPT_ID FROM DEPT WHERE DEPT_NAME = 'SALES';
SELECT * FROM EMP WHERE EMP_DEPT_ID = 'D4';
#REPLACE 'D4' WITH THIS ENTIRE QUERY
SELECT * FROM EMP WHERE EMP_DEPT_ID = (SELECT DEPT_ID FROM DEPT WHERE DEPT_NAME = 'SALES');
# INNER QUERY GETS EXECUTE FIRST, ITS RESLUT GETS EXECUTED WITH OUTER QUERY