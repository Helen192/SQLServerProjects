-- I-Create Database
create database StudentManagementSystem
go


-- Active Database
use StudentManagementSystem
go

-- II-Create tables
-- 1. create table Class
create table Class (
	ClassId int not null,
	ClassCode nvarchar(50)
)

-- 2. create table Student
create table Student(
	StudentId int not null,
	StudentName nvarchar(50),
	BirthDate datetime,
	ClassId int
)

--3. create table Subject
create table Subject (
	SubjectId int not null,
	subjectName nvarchar(100),
	SessionCount int
)

--4. create table result of exams
create table Result (
	SubjectId int not null,
	StudentId int not null,
	Mark float
)
go

-- cau lenh de sua kieu du lieu c ua mot column: vi du doi Mark tu type float -> int nhu 2 cau lenh sau:
-- alter table Result
-- alter column Mark int

--III- create constraint ->primary key and foreign key
alter table Class
add constraint PK_Class primary key (ClassId)
go

alter table Student
add constraint PK_Student primary key (StudentId)

alter table Subject
add constraint PK_Subject primary key (SubjectId)

alter table Result
add constraint PK_Result primary key (SubjectId, StudentId)

alter table Student    --- cai nay dang bi sai
add constraint FK_Student_Class foreign key (ClassId) references Class (ClassId)

alter table Result
add constraint FK_Result_Student foreign key (StudentId) references Student (StudentId)

alter table Result
add constraint FK_Result_Subject foreign key (SubjectId) references Subject (SubjectId)


-- CHECK
alter table Subject
add constraint CH_Subject_SessionCount check (SessionCount > 0)

-- IV - Insert data
insert into Class(ClassId, ClassCode)
values
(1, 'C1106KV'),
(2, 'C1107KV'),
(3, 'C1108KV'),
(4, 'C1109KV'),
(5, 'C1110KV')
go

insert into Student(StudentId, StudentName, BirthDate, ClassId)
values
(1, 'Pham Tuan Anh', '1993-08-05', 1),
(2, 'Phan Van Huy', '1992-06-10', 1),
(3, 'Nguyen Hoang Minh', '1993-05-05', 2),
(4, 'Tran Tuan Tu', '1993-01-05', 2),
(5, 'Do Van Tai', '1992-04-05', 3)
go

insert into Subject (SubjectId, SubjectName, SessionCount)
values
(1, 'C Programming', 22),
(2, 'Web Design', 18),
(3, 'Database Management', 23)
go

insert into Result (StudentId, SubjectId, Mark)
values
(1, 1, 8),
(1, 2, 7),
(2, 3, 5),
(3, 2, 6),
(4, 3, 9),
(5, 2, 8)
go

select * from Class
select * from Student
select * from Subject
select * from Result

-- V- Query
-- 1: Search students whose BirthDate is between from 1992-10-10 to 1993-10-10. Display Info of StudentId, StudentName, Birthday
select StudentId 'Ma Sinh Vien', StudentName 'Ten Sinh Vien', BirthDate 'Ngay Sinh'
from Student
where BirthDate between '1992-10-10' and '1993-10-10'

-- 2: Count students in each class with information of ClassId, ClassCode, TotalStudent
select Class.ClassId, Class.ClassCode, count(Student.StudentId) TotalStudent
from Class, Student
where Class.ClassId = Student.ClassId
group by Class.ClassId, Class.ClassCode

-- similar code with the above: using "inner join"
select Class.ClassId, Class.ClassCode, count(Student.StudentId) TotalStudent
from Class inner join Student on Class.ClassId = Student.ClassId
group by Class.ClassId, Class.ClassCode

-- Su dung "left join" de hien thi toan bo thong tin cua bang ben trai, sau do moi map thong tin cua bang ben phai vao bang ben trai
select Class.ClassId, Class.ClassCode, count(Student.StudentId) TotalStudent
from Class left join Student on Class.ClassId = Student.ClassId
group by Class.ClassId, Class.ClassCode

-- 3: counting total mark of all subjects for each student, then display only students whose total mark is more than 10. Display info : StudentId, StudentName, TotalMark
-- showing total mark of students
select Student.StudentId 'Ma Sinh Vien', Student.StudentName 'Ten Sinh Vien', sum(Result.Mark) TotalMark
from Student left join Result on Student.StudentId = Result.StudentId
group by Student.StudentId, Student.StudentName
order by TotalMark desc   -- ordering TotalMark in a descend sequence

-- Showing students who has the TotalMark more than 10
select Student.StudentId 'Ma Sinh Vien', Student.StudentName 'Ten Sinh Vien', sum(Result.Mark) TotalMark
from Student left join Result on Student.StudentId = Result.StudentId
group by Student.StudentId, Student.StudentName
having sum(Result.Mark) > 10
order by TotalMark desc   -- ordering TotalMark in a descend sequence
