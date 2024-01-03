--TASK 2.1
create or replace function check_exists_album() returns trigger as 
$$
begin 
	if exist (new.album)
    then  return null;
	elsif(TG_OP = 'INSERT' AND NOT EXISTS(SELECT 1 FROM pg_trigger WHERE tgrelid = TG_RELID AND tgname = TG_NAME))
	then 
	insert into music_collection (performer, album, music_style)
	values	(new.performer, new.album, new.music_style);
    end if;
	return new;
end;
$$ language plpgsql;

create or replace function exist (item varchar) returns bool as
 $$
 declare result bool;
begin
	if (select album from music_collection 
	where album = item
	limit 1) is null
	then result = false;
	else result = true;
	end if;
	return result;
end;
$$ language plpgsql;

create or replace trigger insert_item_collection_album_check
	before insert 
	on music_collection
	for each row 
	execute procedure check_exists_album();

insert into music_collection (performer, album, music_style)
values	('The Beatles', 'Revolver', 'rock');
--TASK 2.2

create or replace function dont_delete_beatles() returns trigger as 
$$
begin
	if old.performer = 'The Beatles'
	then
	return null;
else
	return old;
	end if;
end;
$$ language plpgsql;


create or replace trigger del
	before delete 
	on music_collection
	for each row 
	execute procedure dont_delete_beatles();


delete from music_collection 
where music_style = 'rock'; --пытаемся удалить записи Битлов

delete from music_collection 
where music_style = 'hard-rock'; --удаляем записи другой группы

delete from music_collection
where performer = 'The Beatles'; -- снова пытаемся удалить Битлов

delete from music_collection
where performer = 'Muse'; --удаляем другую группу 

delete from music_collection; -- и даже так Битлы никуда не денутся, потому что они вечны!!!

--Task 2.3

create or replace function to_archive() returns trigger as 
$$
begin 
	insert into music_collection_archive (performer, album, music_style)
	values (old.performer, old.album, old.music_style);
return old;
end;
$$ language plpgsql;

create or replace trigger after_delete
	after delete 
	on music_collection
	for each row 
	execute procedure to_archive();


delete from music_collection 
where performer = 'Linkin Park'; -- удаляем и переносим в архив

--Task 2.4

create or replace function dont_create_Dark_Power_Pop() returns trigger as 
$$
begin 
	if new.music_style = 'Dark Power Pop'
	then 
	return null;
else 
	return new;
	end if;
end;
$$ language plpgsql;

create or replace trigger before_insert
	before insert 
	on music_collection
	for each row 
	execute procedure dont_create_Dark_Power_Pop();

insert into music_collection (performer, album, music_style)
values ('group', '1', 'Dark Power Pop'); -- пытаемся добавить запретный стиль

insert into music_collection (performer, album, music_style)
values ('group2', '2', 'rap'); --добавляем отличный от запретного 

--Task 3.1

create or replace function same_buyer() returns trigger as 
$$
begin 
	if exist_buyer(new.lastname)
	then 
	insert into special_customer (firstname, lastname, phone_number)
	values (new.firstname, new.lastname, new.phone_number);
	return null;
	elsif (TG_OP = 'INSERT' AND NOT EXISTS(SELECT 1 FROM pg_trigger WHERE tgrelid = TG_RELID AND tgname = TG_NAME))
	then
	insert into customer (firstname, lastname, phone_number)
	values (new.firstname, new.lastname, new.phone_number);
	end if;
	return new;
	
end;
$$ language plpgsql;

create or replace function exist_buyer (l_customer varchar) returns bool as
 $$
 declare result bool;
begin
	if (select lastname from customer 
	where lastname = l_customer
	limit 1) is null 
	then result = false;
	else result = true;
	end if;
	return result;
end;
$$ language plpgsql;

create or replace trigger insert_customer_check
	before insert 
	on customer
	for each row 
	execute procedure same_buyer();

insert into customer (firstname, lastname, phone_number)
values  ('loni', 'Rebin', 392183890); 


-- Task 3.2

create or replace function history() returns trigger as 
$$ 
begin 
	
end;
$$ language plpgsql;



--вообще без понятия 

-- Task 3.3

create or replace function is_saller() returns trigger as 
$$ 
begin 
	if (select concat(firstname,lastname) from seller 
	where concat(firstname,lastname)=concat(new.firstname,new.lastname)
	limit 1) is null
	then return new;
	else return null;
	end if; 
end;
$$ language plpgsql;

create or replace trigger insert_before
	before insert 
	on customer
	for each row 
	execute procedure is_saller();

insert into customer (firstname, lastname, phone_number)
values	('Martin', 'Iden', 3840183123); 

insert into customer (firstname, lastname, phone_number)
values	('Mary', 'Brown', 3840183123); 

-- Task 3.4

create or replace function is_customer() returns trigger as 
$$ 
begin 
	if (select concat(firstname,lastname) from customer 
	where concat(firstname,lastname)=concat(new.firstname,new.lastname)
	limit 1) is null
	then return new;
	else return null;
	end if; 
end;
$$ language plpgsql;

create or replace trigger insert_before_2
	before insert 
	on seller
	for each row 
	execute procedure is_customer();

insert into seller (firstname, lastname)
values	('Mary', 'Brown'); 

insert into seller (firstname, lastname)
values	('Mark', 'Black'); 

-- Task 3.5

create or replace function list_product() returns trigger as 
$$ 
begin 
	if new.purchase_name = 'яблоко' or new.purchase_name = 'груша' or
		new.purchase_name = 'слива' or new.purchase_name = 'кинза'
	then return null;
	else 
	return new;
	end if;
end;
$$ language plpgsql;

create or replace trigger insert_before_3
	before insert 
	on purchase
	for each row 
	execute procedure list_product();



insert into purchase (purchase_name, price)
values ('яблоко', 24.60), ('дыня', 49.00);





