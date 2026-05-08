create table Medicines(
medicine_id int auto_increment primary key,
medicine_name varchar(100),
price decimal(10,2),
stock int
);

create table Price_Changes_Log(
log_id int auto_increment primary key,
medicine_id int,
old_price decimal(10,2),
new_price decimal(10,2),
change_type varchar(20),
difference decimal(10,2),
changed_at datetime default current_timestamp
);

insert into Medicines(medicine_name, price, stock)
values
('Paracetamol', 10000, 50),
('Vitamin C', 20000, 30);

delimiter //

create trigger trg_medicine_price_log
before update
on Medicines
for each row
begin

if NEW.price <= 0 then
signal sqlstate '45000'
set message_text = 'Loi: Gia thuoc moi khong hop le';
end if;

if OLD.price != NEW.price then

if NEW.price > OLD.price then

insert into Price_Changes_Log(
medicine_id,
old_price,
new_price,
change_type,
difference
)
values(
OLD.medicine_id,
OLD.price,
NEW.price,
'TANG GIA',
NEW.price - OLD.price
);

elseif NEW.price < OLD.price then

insert into Price_Changes_Log(
medicine_id,
old_price,
new_price,
change_type,
difference
)
values(
OLD.medicine_id,
OLD.price,
NEW.price,
'GIAM GIA',
OLD.price - NEW.price
);

end if;

end if;

end//

delimiter ;

update Medicines
set price = 15000
where medicine_id = 1;

update Medicines
set price = 12000
where medicine_id = 1;

update Medicines
set stock = 100
where medicine_id = 1;

update Medicines
set price = -5000
where medicine_id = 1;

select * from Price_Changes_Log;