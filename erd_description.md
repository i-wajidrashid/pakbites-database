create table city(
city_name varchar(30) primary key,
city_province varchar(20)
);
create table rest(
rest_id int,
rest_name varchar(20),
rest_address varchar(20),
rest_phone int,
rest_email varchar(20),
city_name varchar(30) primary key,
rest_cuisinetype varchar(20),
rating decimal(2,1),
FOREIGN KEY (city_name)
    REFERENCES city (city_name)
);
create table menu_item(
item_id int,
item_name varchar(20) primary key,
item_description varchar(100),
item_price decimal(6,2),
item_category varchar(20),
item_status varchar(30)
);
create table orders(
order_id int,
order_dateandtime datetime primary key,
delivery_address varchar(100),
total_amount decimal(7,2),
delivery_fee decimal(3,2),
delivery_status varchar(50),
payement_method varchar(30)
);
create table customers(
customer_id int,
customer_full_name varchar(50),
customer_email varchar(20), 
customer_phone int,
customer_address varchar(100),
city_name varchar(30) primary key,
customer_registration_date date,
FOREIGN KEY (city_name)
    REFERENCES city (city_name)
);
create table reviews(
review_id int,
rating decimal(2,1),
comment_text varchar(100), 
review_date date primary key
);
create table delivery_rider( 
delivery_rider_id int,
delivery_rider_name varchar(30),
delivery_rider_phone int,
delivery_rider_vehicle_type varchar(30),
city_name varchar(30) primary key,
delivery_rider_availability_status varchar(30),
FOREIGN KEY (city_name)
    REFERENCES city (city_name)
);
create table status_history(
status_history_id int,
order_status varchar(50) primary key,
order_history varchar(50)
);

Relations                                                    Cardinality
1. A restaurant belongs to exactly one city.                 Many to One
2. Each restaurant has a menu with multiple items.           One to One
3. A customer can place multiple orders.                     One to Many
4. Each order belongs to one customer.                       Many to One
5. Each order belongs to one restaurant.                     Many to Many
6. Each order is assigned to one delivery rider.             Many to One
7. Each order contains one or more order items.              One to Many 
8. A customer can only review a restaurant once.             One to One

This design satisfies 1NF because not every attribute is dependant on a primary key.
