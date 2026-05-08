create table Appointments(
appointment_id int auto_increment primary key,
doctor_id int,
patient_name varchar(100),
appointment_time datetime,
status varchar(20)
);

insert into Appointments(doctor_id, patient_name, appointment_time, status)
values
(1, 'Nguyen Van A', '2026-06-01 09:00:00', 'Pending'),
(1, 'Tran Van B', '2026-06-01 10:00:00', 'Cancelled');

delimiter //

create trigger trg_check_double_booking_insert
before insert
on Appointments
for each row
begin

if exists(
select 1
from Appointments
where doctor_id = NEW.doctor_id
and appointment_time = NEW.appointment_time
and status != 'Cancelled'
)
then
signal sqlstate '45000'
set message_text = 'Loi: Bac si da co lich hen vao khung gio nay';
end if;

end//

create trigger trg_check_double_booking_update
before update
on Appointments
for each row
begin

if exists(
select 1
from Appointments
where doctor_id = NEW.doctor_id
and appointment_time = NEW.appointment_time
and status != 'Cancelled'
and appointment_id != NEW.appointment_id
)
then
signal sqlstate '45000'
set message_text = 'Loi: Bac si da co lich hen vao khung gio nay';
end if;

end//

delimiter ;

insert into Appointments(doctor_id, patient_name, appointment_time, status)
values (1, 'Le Van C', '2026-06-01 11:00:00', 'Pending');

insert into Appointments(doctor_id, patient_name, appointment_time, status)
values (1, 'Pham Van D', '2026-06-01 09:00:00', 'Pending');

insert into Appointments(doctor_id, patient_name, appointment_time, status)
values (1, 'Hoang Van E', '2026-06-01 10:00:00', 'Pending');

update Appointments
set status = 'Completed'
where appointment_id = 1;