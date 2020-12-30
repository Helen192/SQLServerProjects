-- Create Database => HotelManagement
create database HotelManagement
go

-- Active Database => HotelManagement
use HotelManagement
go

-- Create table hotel 
create table hotel (
	id int primary key identity(1,1),
	name nvarchar(50) not null,
	address nvarchar(200),
	type nvarchar(20)
)
go

-- Create table room
create table room (
	room_no nvarchar(20) primary key,
	floor int,
	price float,
	capacity int
)
go

-- Create table device
create table device (
	device_id nvarchar(20) primary key,
	name nvarchar(50),
	price float,
	manufacturer_name nvarchar(50),
	buy_date date,
	shop_infor nvarchar(200),
	room_no nvarchar(20) references room (room_no),
	note nvarchar(300)
)
go

-- Create table menu
create table menu (
	id int primary key identity(1,1),
	name nvarchar(50),
	price float,
	buy_date date,
	expired_date date,
	number int
)
go

-- Adding data : INSERT
insert into hotel (name, address, type)
values
('Hoa Mai', '285 Doi Can, Ba Dinh, Ha Noi', '5*'),
('Sao Mai', '1 Le Thanh Nghi, Hai Ba Trung, Ha Noi', '4*')
go

insert into room (room_no, floor, capacity, price)
values
('HM1001', 1, 2, 150000),
('HM1002', 1, 2, 100000),
('HM2001', 2, 1, 50000),
('HM2002', 2, 2, 150000)
go

insert into device (device_id, name, price, manufacturer_name, buy_date, shop_infor, room_no, note)
values
('R001', 'Dieu Hoa Daikin 9000KWH', 10000000, 'Daikin', '2020-01-02', 'Media Mart', 'HM1001', ''),
('R002', 'Tivi', 3000000, 'Samsung', '2020-01-05', 'Media Mart', 'HM1001', ''),
('R003', 'Dieu Hoa Daikin 9000KWH', 10000000, 'Daikin', '2020-01-01', 'Media Mart', 'HM1001', ''),
('R004', 'Tivi', 5000000, 'LG', '2020-09-02', 'Media Mart', 'HM1001', ''),
('R005', 'Dieu Hoa Daikin 9000KWH', 10000000, 'Daikin', '2020-01-02', 'Media Mart', 'HM1001', ''),
('R006', 'Shower', 10000000, 'Sunhouse', '2020-01-02', 'Media Mart', 'HM1001', '')
go

insert into menu (name, price, buy_date, expired_date, number)
values
('Bo Huc', 20000, '20-06-02', '2020-06-07', 50),
('Lavi', 15000, '2020-06-02', '2021-06-02', 100),
('Tra Xanh O Long', 15000, '2020-06-02', '2020-06-05', 50)
go

--- Tim hieu them ve primary key va foreign key
select * from room

-- Cau lenh sau bi error vi ma HM1001 la primary key va no da ton tai trong bang room roi
insert into room(room_no, floor, price, capacity)
values
('HM1001', 3, 200000, 2)
go

select * from room
select * from device

-- Vi room_no trong table device la foreign key  cua room_no trong table room, nen bat buoc du lieu room_no trong device phai la mot trong nhung cai da ton tai trong room_no cua table room
insert into device(device_id, name, price, manufacturer_name, buy_date, shop_infor, room_no, note)
values
('R007', 'Dieu Hoa Daikin 9000KWH', 10000000, 'Daikin', '2020-01-02', 'Media Mart', 'HM1009','')
go

-- Fix loi thieu cot Hotel_id trong table room
alter table room
add hotel_id int references hotel(id)

select * from hotel
select * from room

-- Update du lieu vao hotel_id
update room set hotel_id = 1

--------------------------------------- SELECT -----------------------------------------
-- Liet ke tat ca
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity 
from hotel, room
where room.hotel_id = hotel.id

-- Khach san loai 5*, phong 2 nguoi
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity
from hotel, room
where room.hotel_id = hotel.id
	and hotel.type = '5*'
	and room.capacity = 2

-- Khach san loai 5*, phong 2 nguoi, gia >= 200000
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity
from hotel, room
where room.hotel_id = hotel.id
	and hotel.type = '5*'
	and room.capacity = 2
	and room.price >= 200000

-- Khach san co dia chi o Quan Ba Dinh (tuc la trong phan address chi can co chua chu "Ba Dinh" thif se dua ra)
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity 
from hotel, room
where room.hotel_id = hotel.id
	and hotel.address like '%Ba Dinh%'    --(dung structur: like '%cai can tim%'   => % the hien cho bat ke ky tu nao dung truoc/ sau cai can tim

-- Khach san khong co dia chi o Quan Ba Dinh
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity 
from hotel, room
where room.hotel_id = hotel.id
	and hotel.address not like '%Ba Dinh%' 

-- phong chua 1,2,3,5 nguoi
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity 
from hotel, room
where room.hotel_id = hotel.id
	and (
		room.capacity = 1
		or room.capacity = 2
		or room.capacity = 3
		or room.capacity =5
		)
-->> Cach viet khach nhu sau: (dung menh de in)
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity 
from hotel, room
where room.hotel_id = hotel.id
	and room.capacity in (1,2,3,5)

-- Phong khong chua 2,3,5 nguoi (dung menh de not in)
select hotel.name, hotel.address, hotel.type, room.room_no, room.floor, room.price, room.capacity 
from hotel, room
where room.hotel_id = hotel.id
	and room.capacity not in (2,3,5)


--- Liet ke thong tin: ten khach san, loai khach san, dia chi, so luong phong
select hotel.name, hotel.address, hotel.type, count(room.room_no) 'So Phong'              -- count(room.room_no) tu la diem so luong cua room_no trong bang room. Ket qua tra ve cot 'So Phong'
from hotel, room       -- from tu room de lay thong tin so luong phong
where hotel.id = room.hotel_id
	group by hotel.name, hotel.address, hotel.type    -- group by la de nhom cac thong tin con lai ma khong count thanh 1 nhoms

--- Liet ke thong tin: ten khach san, loai khach san, dia chi, so luong phong, so luong phong >2
-- them du lieu vao database de phan tich cho de
insert into room(room_no, floor, price, capacity, hotel_id)
values
('SM1001', 3, 200000, 2, 2)
go

select hotel.name, hotel.address, hotel.type, count(room.room_no) 'So Phong'              -- count(room.room_no) tu la diem so luong cua room_no trong bang room. Ket qua tra ve cot 'So Phong'
from hotel, room       -- from tu room de lay thong tin so luong phong
where hotel.id = room.hotel_id
	group by hotel.name, hotel.address, hotel.type  
	having count(room.room_no) > 2          -- tuc la cai ket qua cua count(room.room_no) > 2 => dung cau lenh having

--- Liet ke thong tin: ten khach san, loai khach san, dia chi, so luong phong sap theo thu tu tang dan
-->> dung lenh: ORDER BY cot can sap xep ASC / DESC : troong do thi ASC co the bo vi default cua order by la sap the thu tu tang dan(in ascending) con DESC thu la sap theo thu tu giam dan (in descending)
select hotel.name, hotel.address, hotel.type, count(room.room_no) 'So Phong'              -- count(room.room_no) tu la diem so luong cua room_no trong bang room. Ket qua tra ve cot 'So Phong'
from hotel, room       -- from tu room de lay thong tin so luong phong
where hotel.id = room.hotel_id
	group by hotel.name, hotel.address, hotel.type    -- group by la de nhom cac thong tin con lai ma khong count thanh 1 nhoms
	order by count(room.room_no)

--- Liet ke thong tin: ten khach san, loai khach san, dia chi, so luong phong sap theo thu tu tang dan
select hotel.name, hotel.address, hotel.type, count(room.room_no) 'So Phong'              -- count(room.room_no) tu la diem so luong cua room_no trong bang room. Ket qua tra ve cot 'So Phong'
from hotel, room       -- from tu room de lay thong tin so luong phong
where hotel.id = room.hotel_id
	group by hotel.name, hotel.address, hotel.type    -- group by la de nhom cac thong tin con lai ma khong count thanh 1 nhoms
	order by count(room.room_no) DESC