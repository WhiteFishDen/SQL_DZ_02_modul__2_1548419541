create table if not exists Music_Collection
(
	id int generated always as identity primary key,
	performer varchar not null,
	album varchar not null,
	music_style varchar not null
);

create table if not exists Music_Collection_Archive
(
	id int generated always as identity primary key,
	performer varchar not null,
	album varchar not null,
	music_style varchar not null
);

insert into music_collection (performer, album, music_style)
values	('The Beatles', 'Let It Be', 'rock'),
		('The Beatles', 'Yellow Submarine', 'rock'),
		('Linkin Park', 'Hibryd Theory', 'new-metall'),
		('Linkin Park', 'Meteora', 'new-metall'),
		('Muse', 'Drones', 'progress-rock'),
		('Muse', 'Absolution', 'progress-rock'),
		('Metallica', 'Master of Puppets', 'hard-rock');
	
	
	
create table if not exists customer
(
	id int generated always as identity primary key,
	firstname varchar(20) not null,
	lastname varchar(20) not null,
	phone_number bigint
);

create table if not exists purchase 
(
	id int generated always as identity primary key,
	purchase_name varchar not null,
	price numeric not null
);

create table if not exists basket
(
	id int generated always as identity primary key,
    customer_id int references customer(id) not null,
	purchase_id int references purchase(id) not null
);

create table if not exists purchase_history
(
	id int generated always as identity primary key,
	purchase_id int references purchase(id) not null
);

create table if not exists seller
(
	id int generated always as identity primary key,
	firstname varchar(20) not null,
	lastname varchar(20) not null
);
create table if not exists special_customer
(
	id int generated always as identity primary key,
	firstname varchar(20) not null,
	lastname varchar(20) not null,
	phone_number bigint
)

insert into customer (firstname, lastname, phone_number)
values	('Ivan', 'Durak', 892346117),
		('Mark', 'Rebekin', 89234121),
		('Inga', 'Remizova', 893243643);
insert into purchase (purchase_name, price)
values	('milk', 54.25),
		('bread', 21.50),
		('tomato', 12.34),
		('chips', 73.39),
		('lemonade', 59.99),
		('sausage', 129.60);
insert into basket(customer_id, purchase_id)
values	(1,2),(1,4),(1,6),
		(2,3),(2,1),(2,5),
		(3,1),(3,1),(3,5);
insert into seller(firstname, lastname)
values	('Martin', 'Iden'),
		('Rob', 'Brown');

