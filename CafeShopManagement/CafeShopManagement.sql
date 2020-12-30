-- create database: CafeShopManagement
create database CafeShopManagement
go

-- active database: CafeShopManagement
use CafeShopManagement
go

-- create tables 
create table Category (
	id int primary key identity(1,1),
	name nvarchar(50) not null
)
go

create table Product (
	id int primary key identity(1,1),
	title nvarchar(50) not null,
	description text,
	price float,
	category_id int references Category(id)
)
go

create table Staff (
	id int primary key identity(1,1),
	fullname nvarchar(50) not null,
	address nvarchar(200),
	gender nvarchar(20),
	birthday date,
	phone_number nvarchar(20)
)
go

create table Customer (
	id int primary key identity(1,1),
	fullname nvarchar(50) not null,
	phone_number nvarchar(150),
	email nvarchar(50)
)
go

create table Orders (
	id int primary key identity(1,1),
	customer_id int references Customer(id),
	staff_id int references Staff(id),
	price_total float
)
go

alter table Orders
add created_at datetime

create table OrderDetail (
	id int primary key identity(1,1),
	product_id int references Product(id),
	price float,
	num int,
	price_total float,
	order_id int references Orders(id)
)
go


----- insert some data into database
insert into Category (name)
values
('Cafe'),
('Nuoc ep'),
('sinh to')
go

insert into Product (title, price, category_id)
values
('Cafe sua', 32000, 1),
('Cafe da', 29000, 1),
('Cafe nong', 49000,1),
('Nuoc ep oi', 59000,2),
('Nuoc ep cam', 69000, 2)
go

insert into Staff (fullname, address, gender, birthday, phone_number)
values
('Phuong Anh Nguyen', 'Hanoi','female', '1994-02-02', '1234567890'),
('Hoang Anh Nguyen', 'Hanoi','female', '1994-06-02', '1234567890')
go

insert into Customer (fullname, email, phone_number)
values
('Tran Van A', 'a@gmail.com', '12345'),
('Tran Van B', 'b@gmail.com', '13456'),
('Nguyen Minh Hoang', 'h@gmail.com', '3467'),
('Nguyen Van C', 'c@gmail.com', '45678'),
('Nguyen Van E', 'e@gmail.com', '567890')
go

insert into Orders (customer_id, staff_id, price_total)
values
(1,1,96000)
go

update Orders set created_at = '2020-12-29' where id = 1

insert into OrderDetail (order_id, product_id, price, num, price_total)
values
(1, 1, 32000, 3, 96000)
go

insert into Orders(customer_id, staff_id, price_total, created_at)
values
(1, 1, 133000, '2020-12-29')
go

update Orders set customer_id = 2 where id = 2
update Orders set customer_id = 4 where id = 4

insert into Orders(customer_id, staff_id, price_total, created_at)
values
(3, 2, 58000, '2020-12-29')
go

insert into Orders (customer_id, staff_id, price_total, created_at)
values
(2, 2, 59000, '2020-08-29')
go


insert into OrderDetail (order_id,  product_id, price, num, price_total)
values
(2, 1, 32000, 2, 64000),
(2, 1, 69000, 1, 69000)
go

insert into OrderDetail (order_id,  product_id, price, num, price_total)
values
(6, 2, 29000, 2, 58000)
go

insert into OrderDetail (order_id,  product_id, price, num, price_total)
values
(7, 4, 59000, 1, 59000)
go


--- Show drink list of a category => create query sql, create store
select * from Category
select * from Product

-- show : CategoryName, ProductName, Price
select Category.name CategoryName, Product.title ProductName, Product.price Price
from Category, Product
where Category.id = Product.category_id
	and Category.id = 1

create proc proc_view_menu_following_Category
	@id int
as
begin
	select Category.name CategoryName, Product.title ProductName, Product.price Price
from Category, Product
where Category.id = Product.category_id
	and Category.id = @id
end

exec proc_view_menu_following_Category 1
exec proc_view_menu_following_Category 2


--- show details of one order => create sql and create a store for this function
select Orders.id OrderId, Staff.fullname StaffName, Customer.fullName CustomerName, Product.title ProductName, OrderDetail.price Price, OrderDetail.num Num, Orders.created_at OrderDate
from Orders, OrderDetail, Staff, Customer, Product
where Orders.id = OrderDetail.order_id
	and Orders.customer_id = Customer.id
	and Orders.staff_id = Staff.id
	and OrderDetail.product_id = Product.id
	and Orders.id = 6
	


select * from Orders
select * from Customer

create proc proc_view_order
	@orderId int
as
begin
	select Orders.id OrderId, Staff.fullname StaffName, Customer.fullName CustomerName, Product.title ProductName, OrderDetail.price Price, OrderDetail.num Num, Orders.created_at OrderDate
from Orders, OrderDetail, Staff, Customer, Product
where Orders.id = OrderDetail.order_id
	and Orders.customer_id = Customer.id
	and Orders.staff_id = Staff.id
	and OrderDetail.product_id = Product.id
	and Orders.id = @orderId
end

exec proc_view_order 6
exec proc_view_order 1


create proc proc_view_order_of_one_customer
	@customerId int
as
begin
	select Orders.id OrderId, Staff.fullname StaffName, Customer.fullName CustomerName, Product.title ProductName, OrderDetail.price Price, OrderDetail.num Num, Orders.created_at OrderDate
from Orders, OrderDetail, Staff, Customer, Product
where Orders.id = OrderDetail.order_id
	and Orders.customer_id = Customer.id
	and Orders.staff_id = Staff.id
	and OrderDetail.product_id = Product.id
	and Orders.id = @customerId
end

exec proc_view_order_of_one_customer 6
exec proc_view_order_of_one_customer 2

--- show revenue following start day and end day => create a store
select Orders.id OrderId, Staff.fullname StaffName, Customer.fullName CustomerName, Product.title ProductName, OrderDetail.price Price, OrderDetail.num Num, Orders.created_at OrderDate
from Orders, OrderDetail, Staff, Customer, Product
where Orders.id = OrderDetail.order_id
	and Orders.customer_id = Customer.id
	and Orders.staff_id = Staff.id
	and OrderDetail.product_id = Product.id
	and Orders.created_at >= '2020-08-18'
	and Orders.created_at <= '2020-12-29'


select sum(price_total) 'Total revenue'
from Orders
where Orders.created_at >= '2020-08-18'
	and Orders.created_at <= '2020-12-29'

create proc proc_revenue
	@startDate date,
	@endDate date
as 
begin
	select sum(price_total) 'Total revenue'
	from Orders
	where Orders.created_at >= @startDate
		and Orders.created_at <= @endDate
end

exec proc_revenue '2020-08-18', '2020-12-29'