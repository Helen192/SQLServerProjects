==================== Managing students' attendances in classes
1. table Student includes:
	- rollno
	- fullname ( of student)
	- gender, birthday, address, email
2. table Teacher includes:
	- rollno (of teacher)
	- fullname, gender, birthday
3. table Subject includes:
	- subjectId
	- subjectName
	- number of session
4. table Class includes:
	- classId
	- className
	- note
5. ClassMember
	- rollno
	- classno
	- joinedDate
	-outedDate
6. table Schedule
	- id : increasing automatically
	- rollno (of teacher)
	- subjectId
	- classId
	- start date
	- end date
7. table Attendances 
	- id :increasing automatically
	- scheduleId : foreign key references Schedule(id)
	- rollno (of student)
	- attendance 1
	- attendance 2
	- checkin 1
	- checkin 2
	- note

8. Requirements:
	- Design the above database
	- insert data into all tables
	- create a procedure to view students' data in a class - input is className
	- create a procedure to view attendance list of a class and a subject - input is classId and subjectName
	- create trigger to delete student's data
