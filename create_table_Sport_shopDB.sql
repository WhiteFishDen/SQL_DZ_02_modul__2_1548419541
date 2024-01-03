create table if not exists employees
(
	employe_id int generated always as identity primary key,
	firstname varchar,
	secondname varchar,
	_age int,
	job_title varchar(20) default 'продавец'
);
drop table employees;
drop table archive;
create table if not exists archive
(
	archive_id int generated always as identity primary key,
	firstname varchar,
	secondname varchar,
	_age int,
	job_title varchar(20) default 'продавец'
);

create table if not exists product
(
    product_id int generated always as identity primary key,
	price int not null,
	amount int not null,
	_name varchar(20) not null
);

insert into product (price, amount, _name)
values (121, 2, 'rope'), (59, 15,'fitball');

insert into employees (firstname, secondname, _age)
values  ('Mark', 'Hemill', 57),
		('Ron', 'Uizli', 25),
		('Karl', 'Urban', 29),
		('Liza', 'Brown', 27),
		('Ron', 'Srtark', 35);

insert into archive (firstname, secondname, _age)
values ('Lui', 'Armstrong', 47);

