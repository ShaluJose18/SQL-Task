drop procedure st_transaction_rollback;

/* Procedure */
 Delimiter //
 Create Procedure st_transaction_rollback(
 in _with_amount double,
 in _sender_accno varchar(30),
 in _receiver_accno varchar(30)
 )
     begin
     declare _samount double;
     declare _ramount double;
     declare exit handler for sqlexception
     begin
     rollback;
     end;
     declare exit handler for sqlwarning
     begin
     rollback;
     end;
     
     
    start transaction;
     
     insert into transactions(sender_accno,receiver_accno,amount) values((select user_id from user_details where account_no =  _sender_accno),(select user_id from user_details where account_no =_receiver_accno),_with_amount);

     select b.amount into _samount from user_details as u inner join balance_info as b on u.user_id = b.userdetails_id where u.account_no=_sender_accno;
     select _samount;
     if(_samount is not null) then
	 update balance_info set amount=amount - _with_amount where userdetails_id=(select user_id from user_details where account_no =  _sender_accno) and amount >= _with_amount;
     else
     rollback;
     end if;
     select 'reciever';
     select b.amount into _ramount from user_details as u inner join balance_info as b on u.user_id = b.userdetails_id where u.account_no=_receiver_accno;
     select _ramount;
     if(_ramount is not null) then
	 update balance_info set amount=amount + _with_amount where userdetails_id=(select user_id from user_details where account_no =_receiver_accno); 
     update transactions set status='Success' where sender_accno=(select user_id from user_details where account_no =  _sender_accno);
     else
		 rollback;
     end if;
		commit;
	
     end //
     
DELIMITER ;
call st_transaction_rollback (100,'SBI1200456','SBI1200789')