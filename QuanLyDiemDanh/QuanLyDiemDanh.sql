-- Create a Database named QuanLyDiemDanh
create database QuanLyDiemDanh
go

-- Active database
use QuanLyDiemDanh
go

------Part I: Designing tables
-- create table Student
create table Student (
	rollno nvarchar(20) primary key,
	fullname nvarchar(50) not null,
	gender nvarchar(15),
	address nvarchar(150),
	birthday date
)
go

create table Teacher (
	id int primary key identity(1,1),
	email nvarchar(150) unique,
	fullname nvarchar(150) not null,
	birthday date,
	gender nvarchar(15)
)
go

create table Subject (
	id int primary key identity(1,1),
	name nvarchar(50) not null,
	session int default 0
)
go

create table Class (
	id int primary key identity(1,1),
	name nvarchar(50) not null,
	note nvarchar(200)
)
go

create table ClassMember (
	rollno nvarchar(20) not null,
	classno int not null,
	joined_date date,
	outed_date date, 
	constraint pk_class_member primary key (rollno, classno)
)
go

alter table ClassMember
add constraint fk_class_member_rollno foreign key (rollno) references Student (rollno)

create table Schedule (
	id int primary key identity(1,1),
	teacherId int references Teacher(id),
	subjectNo int references Subject(id),
	classno int references Class (id),
	startDate date,
	endDate date
)
go

--- attendence1 va attendence2 nhan cac gia tri: A, PA, P: voi y nghia la : vang mat, nghi co phep, di hoc
create table Attendences (
	id int primary key identity(1,1),
	scheduleId int references Schedule(id),
	checkin datetime,
	attendence1 nvarchar(5) default 'P',
	attendence2 nvarchar(5) default 'P',
	note nvarchar(100)
)
go


----------------TEST
select * from Student
select * from Class
select * from ClassMember
select * from Teacher
select * from Schedule
select * from Attendences

------------Part 2: adding data
insert into Student (rollno, fullname, gender, birthday, address)
values
('R001', 'Phuong Huong Nguyen', 'Female', '1992-01-01', 'Hanoi'),
('R002', 'Hoang Anh Nguyen', 'Female', '1992-01-01', 'Nam Dinh'),
('R003', 'Minh Quan Tran', 'Male', '1992-01-01', 'Ha Nam'),
('R004', 'Minh Anh Nguyen', 'Female', '1992-01-01', 'Thai Binh'),
('R005', 'Trong Hoang Nguyen', 'Male', '1992-01-01', 'Hung Yen')
go

insert into Class(name)
values
('C1803L'),
('C1610I'),
('C1805G'),
('C1803E'),
('C1701A')
go

select * from Class

insert into ClassMember (rollno, classno, joined_date, outed_date)
values
('R001', 4, '2018-02-15', '2020-06-06'),
('R002', 4, '2018-01-15', '2020-04-04'),
('R003', 4, '2018-09-15', null),
('R004', 5, '2018-10-15', null),
('R005', 5, '2019-12-15', null)
go

insert into Teacher (fullname, birthday, email, gender)
values
('Diep Van Tran', '1986-02-02', 'diepvantran.it@gmail.com', 'Male'),
('Thanh Huong Nguyen', '1985-01-10', 'thanhhuongnguyen.ed@gmail.com', 'Female')
go

insert into Subject(name, session)
values
('DAP1', 12),
('GTI', 9),
('DAP2', 12),
('Bootstrap/JQuery', 6),
('HTML/CSS/JavaScript', 10)
go

insert into Schedule (teacherId, subjectNo, classno, startDate, endDate)
values
(1, 4, 4, '2020-07-18', '2020-09-18'),
(1, 5, 5, '2020-08-15', '2020-10-15')
go

select * from Schedule

---- fix: checkin => checkin1 and checkin2, adding rollno
alter table Attendences
drop column checkin

alter table Attendences
add checkin1 datetime

alter table Attendences
add checkin2 datetime

alter table Attendences
add rollno nvarchar(20) references Student (rollno)

select * from Attendences

insert into Attendences (scheduleId, rollno, checkin1, attendence1, checkin2, attendence2, note)
values
(1,'R001', '2020-08-20 19:05:00', 'A', '2020-08-20 20:50:00', 'P', ''),
(1,'R002', '2020-08-20 19:05:00', 'P', '2020-08-20 20:50:00', 'P', ''),
(1,'R003', '2020-08-20 19:05:00', 'P', '2020-08-20 20:50:00', 'PA', '')
go

insert into Attendences (scheduleId, rollno, checkin1, attendence1, checkin2, attendence2, note)
values
(2,'R004', '2020-08-20 19:05:00', 'P', '2020-08-20 20:50:00', 'P', ''),
(2,'R005', '2020-08-20 19:05:00', 'P', '2020-08-20 20:50:00', 'P', '')
go

--- create a procedure to see information of student in a class - input is className
create proc proc_view_students_in_class
	@ClassName nvarchar (50)
as
begin
	select Class.name ClassName, Student.rollno, Student.fullname, Student.gender, Student.birthday, Student.address
	from Class left join ClassMember on Class.id = ClassMember.classno
		left join Student on ClassMember.rollno = Student.rollno
	where Class.name = @ClassName
end

exec proc_view_students_in_class N'C1803L'

-- create a procedure to see attendence list of a class for a subject - input is classid and subject
select Class.name ClassName, Subject.name SubjectName, Student.fullname, Student.rollno, Attendences.checkin1, Attendences.attendence1, Attendences.checkin2, Attendences.attendence2
from Class, Subject, Student, Attendences, Schedule
where Class.id = Schedule.classno
	and Subject.id = Schedule.subjectNo
	and Student.rollno = Attendences.rollno
	and Schedule.id = Attendences.scheduleId
	and Class.name = 'C1803E'
	and Subject.name = 'Bootstrap/JQuery'

create proc proc_view_attendence
	@ClassName nvarchar(50),
	@SubjectName nvarchar (50)
as
begin
	select Class.name ClassName, Subject.name SubjectName, Student.fullname, Student.rollno, Attendences.checkin1, Attendences.attendence1, Attendences.checkin2, Attendences.attendence2
	from Class, Subject, Student, Attendences, Schedule
	where Class.id = Schedule.classno
		and Subject.id = Schedule.subjectNo
		and Student.rollno = Attendences.rollno
		and Schedule.id = Attendences.scheduleId
		and Class.name = @ClassName
		and Subject.name = @SubjectName
end

exec proc_view_attendence 'C1803E', 'Bootstrap/JQuery'

create proc proc_view_attendence_of_a_student
	@ClassName nvarchar(50),
	@SubjectName nvarchar (50),
	@Rollno nvarchar(20)
as
begin
	select Class.name ClassName, Subject.name SubjectName, Student.fullname, Student.rollno, Attendences.checkin1, Attendences.attendence1, Attendences.checkin2, Attendences.attendence2
	from Class, Subject, Student, Attendences, Schedule
	where Class.id = Schedule.classno
		and Subject.id = Schedule.subjectNo
		and Student.rollno = Attendences.rollno
		and Schedule.id = Attendences.scheduleId
		and Class.name = @ClassName
		and Subject.name = @SubjectName
		and Student.rollno = @Rollno
end

exec proc_view_attendence_of_a_student 'C1803E', 'Bootstrap/JQuery', 'R001'