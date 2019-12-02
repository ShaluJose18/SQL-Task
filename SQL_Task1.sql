create database moneytransfer_db;
use moneytransfer_db;

CREATE TABLE transactions (id int primary key auto_increment,
date_of_transaction datetime not null default CURRENT_TIMESTAMP,
sender_accno int not null,
receiver_accno int not null,
amount double not null,
status varchar(20) not null default 'Pending',
CONSTRAINT FK_users_id FOREIGN KEY (sender_accno)
REFERENCES user_details(user_id),
CONSTRAINT FK_userr_id FOREIGN KEY (receiver_accno)
REFERENCES user_details(user_id));


CREATE TABLE balance_info(id int primary key auto_increment,
userdetails_id int not null,
amount double not null,
updated_date datetime not null default CURRENT_TIMESTAMP,
CONSTRAINT FK_user_id FOREIGN KEY (userdetails_id)
REFERENCES user_details(user_id));


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

 drop procedure st_transaction_Rollback;

 /* Procedure */
 Delimiter //
 Create Procedure st_transaction_Rollback(
 
 
 IN _with_amount double,
 IN _sender_accno varchar(30),
 IN _receiver_accno varchar(30)
 
 
 )
     BEGIN
     DECLARE _samount double;
     DECLARE _ramount double;
     DECLARE exit handler for sqlexception
     BEGIN
     ROLLBACK;
     END;
     DECLARE exit handler for sqlwarning
     BEGIN
     ROLLBACK;
     END;
     
     
     START TRANSACTION;
     
     insert into transactions(sender_accno,receiver_accno,amount) values((select user_id from user_details where account_no =  _sender_accno),(select user_id from user_details where account_no =_receiver_accno),_with_amount);
     select b.amount into _samount from user_details as u inner join balance_info as b on u.user_id = b.userdetails_id where u.account_no=_sender_accno;
     select _samount;
     IF(_samount!='') THEN
	 update balance_info set amount=amount - _with_amount where userdetails_id=(select user_id from user_details where account_no =  _sender_accno) and amount >= _with_amount;
     else
     rollback;
     END IF;
     select 'reciever';
     select b.amount into _ramount from user_details as u inner join balance_info as b on u.user_id = b.userdetails_id where u.account_no=_receiver_accno;
     select _ramount;
     IF(_ramount!='') THEN
	 update balance_info set amount=amount + _with_amount where userdetails_id=(select user_id from user_details where account_no =_receiver_accno); 
     update transactions set status='Success' where sender_accno=(select user_id from user_details where account_no =  _sender_accno);
     else
     rollback;
     END IF;
		COMMIT;
	
     END //
     
     CALL st_transaction_Rollback (200,'SBI1200456','SBI1200aa789')
     