show databases;
use classicmodels;

## Day 1 and Day 2 - No questions

## Day 3
/*  Show customer number, customer name, state and credit limit from customers table for below conditions. 
	1. State should not contain null values
	2. credit limit should be between 50000 and 100000
	3. Sort the results by highest to lowest values of creditLimit  */
 
select * from customers;

select CustomerNumber, CustomerName, State, CreditLimit 
from customers 
where state is not null;

select CustomerNumber, CustomerName, State, CreditLimit 
from customers 
where state is not null 
and creditLimit between 50000 and 100000 
order by creditLimit desc;

-- 4. Show the unique productline values containing the word cars at the end from products table.

select * from products;

select distinct ProductLine
from Products 
where ProductLine like '%cars';

## Day 4
/*  1. Show the orderNumber, status and comments from orders table for shipped status only. 
	   If some comments are having null values then show them as “-“.  */

select * from orders;

update orders 
set comments = "-" 
where comments is null;

select OrderNumber, Status, Comments 
from orders
where Status = 'Shipped';

/*  2. Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
	If job title is one among the below conditions, then job title abbreviation column should show below forms.
	●	President then “P”
	●	Sales Manager / Sale Manager then “SM”
	●	Sales Rep then “SR”
	●	Containing VP word then “VP”  */

select * from employees;

select EmployeeNumber, FirstName, JobTitle,
	case
	when JobTitle = "President" then "P"
	when JobTitle like "Sales Manager%" or JobTitle like "Sale Manager%"  then "SM"
    when JobTitle = "Sales Rep" then "SR"
	when JobTitle like "%VP%" then "VP"
    else
    "Employee"
    end as JobTitle_abbr 
from employees;

## Day 5
-- 1. For every year, find the minimum amount value from payments table.

select * from payments;

select year(PaymentDate) as Year, min(Amount) as "Min Amount" 
from payments 
group by year
order by year; -- order by year(PaymentDate)
	
/*  2. For every year and every quarter, find the unique customers and total orders from orders table. 
	   Make sure to show the quarter as Q1,Q2 etc 
       Table: Customers, Orders  */ 
       
select * from orders;
select * from customers;

select  year(OrderDate) as Year, 
		concat('Q', quarter(OrderDate)) as Quarter, 
        count(distinct(CustomerNumber)) as "Unique Customers", 
        count(OrderNumber) as "Total Orders" 
from orders 
group by year, Quarter;

/*  3. Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
	   with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]  */

select * from payments;

select date_format(paymentdate,'%b') as Month, 
	   concat(round(sum(amount)/1000), 'K') as "Formatted_Amount" 
from payments 
group by month having sum(amount) between 500000 and 1000000 
order by sum(amount) desc;

## Day 6 
/*  1. Create a journey table with following fields and constraints.
	●	Bus_ID (No null values)
	●	Bus_Name (No null values)
	●	Source_Station (No null values)
	●	Destination (No null values)
	●	Email (must not contain any duplicates)  */

create table Journey( Bus_ID int not null,
					  Bus_Name varchar(30) not null,
                      Source_Station varchar(30) not null,
                      Destination varchar(30) not null,
                      Email varchar(30) unique );
desc journey;

insert into journey (Bus_ID, Bus_Name, Source_Station, Destination, Email)
values (1, 'Sample Bus', 'Sample Source Station', 'Sample Destination', 'email@example.com');

insert into journey values (101, 'BMTC', 'BTM Layout', 'Silk Board', 'KavyaShree@gmail.com');

select * from journey;

/*  2. Create vendor table with following fields and constraints.
	●	Vendor_ID (Should not contain any duplicates and should not be null)
	●	Name (No null values)
	●	Email (must not contain any duplicates)
	●	Country (If no data is available then it should be shown as “N/A”)  */
 
create table Vendor( Vendor_ID int unique not null,
					 Name varchar(30) not null,
                     Email varchar(30) unique,
                     Country varchar(20) not null default 'N/A' );
desc vendor;

insert into vendor values (201, 'KAVYA', 'Kavya@gmail.com', 'INDIA');

insert into vendor (Vendor_ID, Name, Email)
values (202, 'SHREE', 'Shree@gmail.com');

select * from vendor;

/*  3. Create movies table with following fields and constraints.
	●	Movie_ID (Should not contain any duplicates and should not be null)
	●	Name (No null values)
	●	Release_Year (If no data is available then it should be shown as “-”)
	●	Cast (No null values)
	●	Gender (Either Male/Female)
	●	No_of_shows (Must be a positive number)  */

create table Movies( Movie_ID int unique not null,
					 Name varchar(30) not null,
                     Release_Year varchar(30) not null default '-',
                     Cast varchar(30) not null,
                     Gender char(20) check(Gender in('Male', 'Female')), -- Gender char(20) check(Gender = 'Male' or Gender = 'Female');
                     No_of_shows int check(No_of_shows > 0) );
desc Movies;

insert into movies values (1, 'Appu', '26 April 2002', 'Rakshita', 'Male', 100);

insert into movies (Movie_ID, Name, Cast, Gender, No_of_shows)
values (2, 'Abhi', 'Ramya', 'Female', 50);

select * from movies;

/*  4. Create the following tables. Use auto increment wherever applicable
	a. Product
	✔	product_id - primary key
	✔	product_name - cannot be null and only unique values are allowed
	✔	description
	✔	supplier_id - foreign key of supplier table  
    
    b. Suppliers
	✔	supplier_id - primary key
	✔	supplier_name
	✔	location
    
    c. Stock
	✔	id - primary key
	✔	product_id - foreign key of product table
	✔	balance_stock  */
    
create table Suppliers( supplier_id int primary key auto_increment,
						supplier_name varchar(30),
                        location varchar(30) );
desc suppliers;

insert into suppliers values (1, 'KEERTHI', 'Karnataka');
insert into suppliers values (2, 'Raju', 'Gujarat');

select * from suppliers;
                        
create table Product( product_id int primary key auto_increment,
					  product_name varchar(40) unique not null,
                      description varchar(150),
                      supplier_id int unique not null,
					  foreign key(supplier_id) references suppliers(supplier_id) );
desc product;

insert into product values (1, 'Samsung', 'Good', 1);
insert into product values (2, 'Apple', 'Good', 2);

select * from product;

create table Stock( id int primary key,
					product_id int unique not null,
                    foreign key(product_id) references product(product_id),
                    balance_stock int );
desc stock;

insert into stock values (1, 1, 50);
insert into stock values (2, 2, 100);

select * from stock;

## Day 7
/*  1. Show employee number, Sales Person (combination of first and last names of employees), 
	   unique customers for each employee number and sort the data by highest to lowest unique customers.
	   Tables: Employees, Customers  */

select * from employees;
select * from customers;

select emp.employeeNumber, concat(emp.firstname,' ', emp.lastname) as 'Sales Person', count(distinct(cust.customerNumber)) as Unique_Customers
from employees as emp
inner join customers as cust
on emp.employeeNumber = cust.salesRepEmployeeNumber
group by emp.employeenumber
order by Unique_Customers desc; -- order by count(distinct(cust.customerNumber)) desc;

/*  2. Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
	   Sort the data by customer number.
	   Tables: Customers, Orders, Orderdetails, Products  */

select * from customers;
select * from orders;
select * from orderdetails;
select * from products;

select cust.customerNumber, cust.customerName, prod.productCode, prod.productName, ordd.quantityOrdered as "Ordered Qty", 
prod.quantityInStock as "Total Inventory", (prod.quantityInStock - ordd.quantityOrdered) as Left_Qty
from customers as cust inner join orders as ord on cust.customernumber = ord.customernumber
inner join orderdetails as ordd on ordd.orderNumber = ord.orderNumber
inner join products as prod on prod.productCode = ordd.productCode
order by cust.customerNumber, Left_Qty;

/*  3. Create below tables and fields. (You can add the data as per your wish)
		●	Laptop: (Laptop_Name)
		●	Colours: (Colour_Name)
		Perform cross join between the two tables and find number of rows.  */
        
create table Laptop (Laptop_Name varchar(100));
insert into Laptop values ('Dell'), ('HP');
select * from Laptop;

create table Colours (Colour_Name varchar(30));
insert into Colours values ('White'), ('Silver'), ('Black');
select * from Colours;

select L.Laptop_Name, C.Colour_Name
from Laptop as L cross join Colours as C
order by Laptop_Name; -- select * from Laptop cross join Colours order by laptop_name;

/*  4. Create table project with below fields.
		●	EmployeeID
		●	FullName
		●	Gender
		●	ManagerID
		Add below data into it.
		INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
		INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
		INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
		INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
		INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
		INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
		INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
		Find out the names of employees and their related managers.  */
        
create table Project (Employee_ID int unique not null, -- primary key
					Full_Name varchar(50) not null,
                    Gender varchar(20) check(Gender = 'Male'or Gender = 'Female'),
                    Manager_ID integer);
desc Project;

insert into Project values (1, 'Pranaya', 'Male', 3);
insert into Project values (2, 'Priyanka', 'Female', 1);
insert into Project values (3, 'Preety', 'Female', null);
insert into Project values (4, 'Anurag', 'Male', 1);
insert into Project values (5, 'Sambit', 'Male', 1);
insert into Project values (6, 'Rajesh', 'Male', 3);
insert into Project values (7, 'Hina', 'Female', 3);

select * from project;

select p1.full_name as Manager_Name, p2.full_name as 'Emp Name'
from Project as p1 join Project as p2 on p1.Employee_ID = p2.Manager_ID 
order by Manager_Name;

## Day 8

/* 1. Create table facility. Add the below fields into it.
		●	Facility_ID
		●	Name
		●	State
		●	Country
		i) Alter the table by adding the primary key and auto increment to Facility_ID column.
	   ii) Add a new column city after name with data type as varchar which should not accept any null values.  */

create table Facility (Facility_ID int,
					   Name varchar(100),
                       State varchar(100),
                       Country varchar(100));

alter table Facility 
modify column Facility_ID int primary key auto_increment;

alter table Facility 
add column City Varchar(100) not null after Name;

desc facility;

alter table Facility auto_increment = 100;

insert into Facility values (101, 'Amazon','Bengaluru', 'KARNATAKA', 'INDIA');
insert into Facility (Name, City, State, Country)
values ('Flipkart','Gujarat', 'KARNATAKA', 'INDIA');

select * from Facility;

## Day 9

/*  1. Create table university with below fields.
		●	ID
		●	Name
	Add the below data into it as it is.	
	INSERT INTO University
	VALUES (1, "       Pune          University     "), 
				   (2, "  Mumbai          University     "),
				  (3, "     Delhi   University     "),
				  (4, "Madras University"),
				  (5, "Nagpur University");
	Remove the spaces from everywhere and update the column like Pune University etc.  */

create table University (ID int, Name varchar(50));

insert into University values (1, "       Pune          University     "), 
							  (2, "  Mumbai          University     "),
							  (3, "     Delhi   University     "),
							  (4, "Madras University"),
							  (5, "Nagpur University");
select * from University;

select ID, replace(Name, ' ','') as Name from University;
						-- OR --
select ID, trim(both ' ' from Regexp_Replace(Name, ' {2,}', ' ')) as Name
from University;

## Day 10

/*  1. Create the view products status. Show year wise total products sold. 
	   Also find the percentage of total value for each year. The output should look as shown in below figure.  */
       
select * from orders;
select * from orderdetails; -- orderNumber

create view Product_Status as select (year(ord.orderdate)) as year, CONCAT(COUNT(productCode), " 
(", concat(round((count(productCode)  / (select count(productCode) from orderdetails))*100), "%"), ")") as value from
orders as ord join orderdetails as ordd 
on ord.ordernumber=ordd.ordernumber
group by Year
order by count(productCode) desc;

select * from Product_Status;

# Day 11

/* 1. Create a stored procedure GetCustomerLevel which takes input as customer number and 
	  gives the output as either Platinum, Gold or Silver as per below criteria.
	  Table: Customers
		●	Platinum: creditLimit > 100000
		●	Gold: creditLimit is between 25000 to 100000
		●	Silver: creditLimit < 25000  */
        
/* 
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`()
BEGIN
declare lcl_custNo int;
declare lcl_custName, lcl_country varchar(100);
declare lcl_credLimit decimal;
declare finished int default 0; 

declare mycur cursor for select customerNumber, customerName, country, creditLimit from customers;

declare continue handler for NOT FOUND
begin
	set finished = 1;
end;

open mycur;

myloop :loop
fetch mycur into lcl_custNo, lcl_custName, lcl_country, lcl_credLimit;
    if finished = 1 then
		leave myloop;
	end if;
    
    if lcl_credLimit > 100000 then
    
		insert into customerLevel (custNo, custName, country, credLimit, status)
        values (lcl_custNo, lcl_custName, lcl_country, lcl_credLimit, "Platinum");
        
	elseif lcl_credLimit  between 25000 and 100000 then
    
		insert into customerLevel (custNo, custName, country, credLimit, status)
        values (lcl_custNo, lcl_custName, lcl_country, lcl_credLimit, "Gold");
        
	elseif lcl_credLimit < 25000 then
    
		insert into customerLevel (custNo, custName, country, credLimit, status)
        values (lcl_custNo, lcl_custName, lcl_country, lcl_credLimit, "Silver");
        
	end if;
end loop myloop;

close mycur;
END
*/

select * from customers;
set global log_bin_trust_function_creators = 1;

create table CustomerLevel (CustNo int, CustName varchar(50), Country varchar(50), CredLimit decimal, status varchar(20)); 
desc CustomerLevel;

call GetCustomerLevel();
select * from CustomerLevel;

								-- OR --

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`(cn int)
BEGIN
declare lcl_custNo int;
declare lcl_credLimit decimal;

select customerNumber,creditLimit into lcl_custNo,lcl_credLimit 
from customers where customerNumber=cn;

if lcl_credLimit <25000 then 
select "Silver" as msg;
else if lcl_credLimit  between 25000 and 100000 then 
select "Gold" as msg;
else 
select "Platinum" as msg;
end if;
end if;

END
*/

call GetCustomerLevel(114);

/* 2. Create a stored procedure Get_country_payments which takes in year and country as inputs 
	  and gives year wise, country wise total amount as an output. 
	  Format the total amount to nearest thousand unit(K)
	  Tables: Customers, Payments  */

select * from customers;
select * from payments;

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Country_Payments`(yr int, c varchar(50))
BEGIN

select year(paymentDate) as Year, country, sum(amount) as "Total Amount"  
from customers left join payments on customers.customerNumber=payments.customerNumber
where country = c and year(paymentDate) = yr 
group by year, country;
 
END
*/

# Day 12

/*  1. Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
	   Table: Orders  */
	
select * from orders;

with cte as (
			select year(orderDate) as Year, month(orderDate) as Month, count(orderNumber) as Total_Orders, 
			lag(count(orderNumber),1) 
			over (partition by year(orderdate)) as YOY 
			from orders 
			group by year(orderdate), month(orderdate)
			) 
select Year, Month, Total_Orders, concat(format(((Total_Orders-YOY)/YOY*100),0),'%') as "% YOY Change" from cte;

/*  2. Create the table emp_udf with below fields.
		●	Emp_ID
		●	Name
		●	DOB
	Add the data as shown in below query.
	INSERT INTO Emp_UDF(Name, DOB)
	VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), 
	("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

	Create a user defined function calculate_age which returns the age in years and months.
    (e.g. 30 years 5 months) by accepting DOB column as a parameter.  */

create table emp_udf( Emp_ID int primary key auto_increment, 
					  Name varchar(20), 
                      DOB date );
                      
insert into emp_udf( Name, DOB )
values ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

/*
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`(birthdate date) RETURNS varchar(255) CHARSET latin1
BEGIN
	declare age varchar(255);
    declare age_y integer default 0;
    declare age_m integer default 0;
 
set age_y=timestampdiff(year,birthdate,curdate());
set age_m=timestampdiff(month,birthdate, curdate())%12;

	set age = concat(age_y,' years ' ,age_m, ' months');
  
RETURN age;
RETURN 1;
END
*/

select *, calculate_age(dob) as Age from emp_udf;

# Day 13

/*  1. Display the customer numbers and customer names from customers table who have not placed any orders using subquery
	   Table: Customers, Orders  */

select * from customers;
select * from orders;

select customerNumber, customerName 
from customers 
where customerNumber 
not in ( select customerNumber from orders );

/* 2. Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
	  Table: Customers, Orders  */

select * from customers;
select * from orders;

select c.customerNumber, c.customerName, count(o.orderNumber) as Total_Orders 
from customers as c 
left join 
orders as o 
on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName
union
select c.customerNumber, c.customerName, count(o.orderNumber) as Total_Orders 
from customers as c 
right join 
orders as o 
on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName;

/* 3. Show the second highest quantity ordered value for each order number.
	  Table: Orderdetails  */

select * from orderdetails;

with cte as ( select * , dense_rank() 
			  over ( partition by ordernumber order by quantityordered desc) as second_highest 
              from orderdetails )
select orderNumber, quantityOrdered from cte where second_highest = 2;

/*  4. For each order number count the number of products and then find the min and max of the values among count of orders.
	   Table: Orderdetails  */

select * from orderdetails;

with orderCounts as ( select orderNumber, count(productCode) as Count 
					  from orderdetails 
                      group by orderNumber )
select max(Count) as "MAX(Total)", min(Count) as "MIN(Total)" from Ordercounts;

/* 5. Find out how many product lines are there for which the buy price value is greater than 
	  the average of buy price value. Show the output as product line and its count.  */

select * from productlines;

select * from products;

select productLine, count(productLine) as Total 
from products 
where MSRP > ( select avg(MSRP) from products) 
group by productLine 
order by Total desc;

# Day 14

/*  1. Create the table Emp_EH. Below are its fields.
		●	EmpID (Primary Key)
		●	EmpName
		●	EmailAddress
	   Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept.
       Show the message as “Error occurred” in case of anything wrong.  */

create table Emp_EH ( EmpID int primary key auto_increment,
					  EmpName varchar(30),
					  EmailAddress varchar(50));

desc Emp_EH;

/*
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_Error`(ename varchar(30), email varchar(50))
BEGIN
declare exit handler for SQLEXCEPTION
begin
    select 'Error Occurred' as Warning;
end;

insert into Emp_EH (EmpName, EmailAddress) values (ename, email);
 
select 'Procedure Completed' as message;
END
*/

call Proc_Error ('Kavya','shree@gmail.com');

select * from Emp_EH;

# Day 15

/*  1. Create the table Emp_BIT. Add below fields in it.
		●	Name
		●	Occupation
		●	Working_date
		●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.  */

create table Emp_BIT ( Name varchar(30),
					   Occupation varchar(20),
					   Working_date date,
					   Working_hours int);
desc Emp_BIT;

insert into Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11); 

select * from Emp_BIT;

/*
CREATE DEFINER=`root`@`localhost` TRIGGER `Working_hours_TRIGGER` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if
	new.working_hours <0 then
	set new.working_hours= abs(new.working_hours);
end if;
END
*/

insert into Emp_BIT values ('Kavya','R&D','2023-10-13',-7);
insert into Emp_BIT values ('Shree','Data Analyst','2023-10-12',-9);

select * from Emp_BIT;





                      









 







