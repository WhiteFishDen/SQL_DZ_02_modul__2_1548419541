
--TASK 1.1
create or replace function check_exist_product() returns trigger as
$$
begin
	if empty_(new._name)
	then
		update product set amount = amount + new.amount
	 	where _name = new._name;
	 	return null;
	elsif(TG_OP = 'INSERT' AND NOT EXISTS(SELECT 1 FROM pg_trigger WHERE tgrelid = TG_RELID AND tgname = TG_NAME))
	then 
		insert into product (price, amount, _name)
		values (new.price, new.amount, new._name);
		end if;
		return new;
end;
$$ language plpgsql;

 create or replace function empty_(prod varchar) returns bool as
 $$
 declare result bool;
begin
	if (select _name from product 
	where _name = prod
	limit 1) is null
	then result = false;
	else result = true;
	end if;
	return result;
end;
$$ language plpgsql;



create or replace trigger product_insert_trigger
	before insert 
	on product 	
	for each row 
	execute procedure check_exist_product();


insert into product (price, amount, _name)
values (10, 4, 'hoop');

--TASK 1.2

create or replace function dismissal_employee() returns trigger as 
$$
begin 
	delete from employees 
	where firstname = old.firstname and secondname = old.secondname;
	insert into archive (firstname, secondname, _age)
	values (old.firstname, old.secondname, old._age);
return new;
end;
$$ language plpgsql;

create or replace trigger delete_emp
after delete 
on employees
for each row 
execute procedure dismissal_employee();

insert into employees (firstname, secondname, _age)
values ('Rob', 'Stark', 35);

delete from employees  
where firstname = 'Rob' and secondname = 'Stark';

--TASK 1.3

select count(*) 
from employees
where job_title = 'продавец'
limit 1;

create or replace function check_job_title() returns trigger as 
$$
	begin
		if (select count(*) 
			from employees
			where job_title = 'продавец'
			limit 1) >= 6 and new.job_title = 'продавец'
		then 
		return null;
		elsif(TG_OP = 'INSERT' AND NOT EXISTS(SELECT 1 FROM pg_trigger WHERE tgrelid = TG_RELID AND tgname = TG_NAME))
		then 
			insert into employees (firstname, secondname, _age, job_title)
			values (new.lastname, new.secondname, new._age, new.job_title);
		end if;
		return new;
	end; 
$$ language plpgsql;

create or replace trigger new_emp
before insert  
on employees
for each row 
execute procedure check_job_title();

insert into employees (firstname, secondname, _age) --добавляем шестого продавца
values ('Rob', 'Stark', 35);

insert into employees (firstname, secondname, _age, job_title) --пытаемся добавить седьмого продавца
values ('Lana', 'Green', 42, 'продавец');

insert into employees (firstname, secondname, _age, job_title) --добавляем седьмого сотрудника,
values ('Amanda', 'Black', 45, 'менеджер');				       -- но с другой другой должностью 






