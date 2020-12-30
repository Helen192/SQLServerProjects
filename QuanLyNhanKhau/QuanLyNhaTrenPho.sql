-- Tao CSDL : QuanLyNhaTrenPho
create database QuanLyNhaTrenPho
go

-- Active CSDL : QuanLyNhaTrenPho => Su dung thao tac data
use QuanLyNhaTrenPho
go

-- Tao bang QuanHuyen
create table QuanHuyen (
	MaQH nvarchar(20) primary key,
	TenQH nvarchar(50) not null
)
go

-- Tao bang DuongPho
create table DuongPho (
	MaDP nvarchar(20) primary key,
	TenDuong nvarchar(100) not null,
	MaQH nvarchar(20),
	constraint fk_ma_qh foreign key (MaQH) references QuanHuyen (MaQH)
)
go

-- Tao bang NhaTrenPho
create table NhaTrenPho (
	id int primary key identity(1,1),  -- tuc la cai id nay se tu dong tang moi lan 1 don vi, va no bat dau bang 1
	OwnerName nvarchar(50) not null,
	SoNhanKhau int, 
	NgayDen date,
	MaDP nvarchar(20) references DuongPho (MaDP)
)
go

alter table NhaTrenPho            -- lenh alter table la de add them du lieu vao mot bang nao do, ma luc dau chua cos tao no
add SoNha int

alter table NhaTrenPho
alter column SoNha nvarchar(50)       -- sua lai kieu du lieu cua SoNha tu int -> nvarchar(50)

----- Nhap Du Lieu Mau
insert into QuanHuyen (MaQH, TenQH)
values
('CG', 'Cau Giay'),
('HM', 'Hoang Mai'),
('BD', 'Ba Dinh')
go

insert into QuanHuyen (MaQH, TenQH)
values
('BT', 'Ba Trung')
go

insert into DuongPho (MaQH, MaDP, TenDuong)
values
('CG', 'DP01', 'Duy Tan'),
('HM', 'DP02', 'Minh Khai'),
('HM', 'DP03', 'Linh Dam')
go

insert into DuongPho (MaQH, MaDP, TenDuong)
values
('BT', 'GP01', 'Giai Toa')
go


insert into NhaTrenPho (OwnerName, SoNhanKhau, NgayDen, SoNha, MaDP)
values
('Phuong Huong Nguyen', 3, '2020-02-06', 'So Nha 18', 'DP02'),
('Hoang Van Nam', 5, '2019-07-08', 'P1001', 'DP01'),
('Pham Hong Ngoc', 2, '2018-06-09', '16', 'DP03')
go

insert into NhaTrenPho (OwnerName, SoNhanKhau, NgayDen, SoNha, MaDP)
values
('Pham Hoang Anh', 1, '2020-02-05', 'So nha 19', 'GP01'),
('Hoang Mai Phuong', 2, '2019-07-08', 'P1001', 'DP03'),
('Nguyen Hoai Anh', 5, '2018-08-08', '16', 'GP01')
go

-- Update
select * from DuongPho

update DuongPho set TenDuong = N'Giai Phong'    -- update lai ten duong thanh Giai Phong. Neu chi co moi cau lenh nay thi no se sua lai toan bo cac ten duong, nen phai co menh de dieu kien
where TenDuong = N'Giai Toa'                    -- tuc chi co duong nao ten Giai Toa thi doi thanh Giai Phong       
go

-- Select
select * from QuanHuyen
select * from DuongPho


----- Hien thi thong tin duong pho: Ma DP, Ten duong pho, ma Quan, ten Quan
----- Du lieu lay o trong 2 table: DuongPho va QuanHuyen
select DuongPho.MaDP, DuongPho.TenDuong, QuanHuyen.MaQH, QuanHuyen.TenQH 
from DuongPho, QuanHuyen
where DuongPho.MaQH = QuanHuyen.MaQH        --- tuc MaQH trong table DuongPho duoc lien ket voi MaQH trong table QuanHuyen
go

---- sua ten trong caac cot: co 4 cach nhu sau
select DuongPho.MaDP N'Ma Duong Pho', DuongPho.TenDuong 'Ten Duong', QuanHuyen.MaQH as 'Ma Quan Huyen', QuanHuyen.TenQH as N'Ten Quan Huyen'
from DuongPho, QuanHuyen
Where DuongPho.MaQH = QuanHuyen.MaQH
go

---- Hien thi du lieu theo dinh dang sau: Ten Chu Nha, So Nha, Ten Duong, Ten Quan, So Nhan Khau, Ngay Den
---- > du lieu xuat phat tu 3 bang: DuongPho, QuanHuyen, NhaTrenPho
select NhaTrenPho.OwnerName, NhaTrenPho.SoNha, DuongPho.TenDuong, QuanHuyen.TenQH, NhaTrenPho.SoNhanKhau, NhaTrenPho.NgayDen
from DuongPho, QuanHuyen, NhaTrenPho
where
	DuongPho.MaQH = QuanHuyen.MaQH
	and NhaTrenPho.MaDP = DuongPho.MaDP
go

---- Hien thi thong tin nhan khau : Ten Chu Nha, So Nha, Ten Duong, Ten Quan, So Nhan Khau, Ngay Den >> voi dieu kien la den tu ngay 20-01-01 cho toi nay
Select NhaTrenPho.OwnerName, NhaTrenPho.SoNha, DuongPho.TenDuong, QuanHuyen.TenQH, NhaTrenPho.SoNhanKhau, NhaTrenPho.NgayDen
from DuongPho, QuanHuyen, NhaTrenPho
where
	DuongPho.MaQH = QuanHuyen.MaQH
	and NhaTrenPho.MaDP = DuongPho.MaDP
	and NhaTrenPho.NgayDen >= '2020-01-01'
go

---- Hien thi thong tin nhan khau : Ten Chu Nha, So Nha, Ten Duong, Ten Quan, So Nhan Khau, Ngay Den >> voi dieu kien la den tu ngay 20-01-01 cho toi nay va So Nhan Khau >2
Select NhaTrenPho.OwnerName, NhaTrenPho.SoNha, DuongPho.TenDuong, QuanHuyen.TenQH, NhaTrenPho.SoNhanKhau, NhaTrenPho.NgayDen
from DuongPho, QuanHuyen, NhaTrenPho
where
	DuongPho.MaQH = QuanHuyen.MaQH
	and NhaTrenPho.MaDP = DuongPho.MaDP
	and NhaTrenPho.NgayDen >= '2020-01-01'
	and NhaTrenPho.SoNhanKhau >= 2
go