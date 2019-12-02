create database moneytransfer_db;
use moneytransfer_db;

CREATE TABLE transactions (id int primary key auto_increment,
date_of_transaction datetime not null default CURRENT_TIMESTAMP,
sender_accno int not null,
receiver_accno int not null,
amount double not null,
status varchar(20) not null default 'Pending',
CONSTRAINT FK_users_id FOREIGN KEY (sender_accno) REFERENCES user_details(user_id),
CONSTRAINT FK_userr_id FOREIGN KEY (receiver_accno) REFERENCES user_details(user_id));

drop table transactions; 
desc transactions;

CREATE TABLE balance_info(id int primary key auto_increment,
userdetails_id int not null,
amount double not null,
updated_date datetime not null default CURRENT_TIMESTAMP,
CONSTRAINT FK_user_id FOREIGN KEY (userdetails_id)
REFERENCES user_details(user_id));

drop table balance_info;
desc balance_info;

CREATE TABLE user_details(user_id int primary key auto_increment,
user_name varchar(30) not null,
account_no varchar(12) not null unique,
email varchar(50) not null,
address varchar(50) not null,

phone bigint not null,
password varchar(5) not null);

select * from transactions;
select * from balance_info;
select * from user_details;                                                

insert into user_details values(101,'Amal','SBI1200123','amal@gmail.com','kerala',9785463254,'amal');
insert into user_details (user_name,account_no,email,address,phone,password) values('Basith','SBI1200456','basi@gmail.com','kerala',9782463254,'basi');
insert into user_details (user_name,account_no,email,address,phone,password) values('Rafsal','SBI1200789','rafsal@gmail.com','kerala',9782466254,'rafsa');
insert into balance_info (userdetails_id,amount) values(103,10000);
truncate table transactions;

/* Procedures */
DELIMITER $$
create procedure moneyTransfer()
Begin
DECLARE `_rollback` BOOL DEFAULT 0;
    DECLARE continue HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
    START TRANSACTION;
insert into transactions(sender,receiver,amount) values('Amal','Basith',1000);
update balance_info set amount=3000 where userdetails_id=105;
insert into user_details (user_name,account_no,email,address,phone,password) values('Akshay','SBI1200752','akv@gmail.com','kerala',97824632124,'akv');

if `rollback` then
rollback;
else
commit;
end if;
END$$
DELIMITER ;

call moneyTransfer()

