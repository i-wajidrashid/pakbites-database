create table city(<br>
city_name varchar(30) primary key,<br>
city_province varchar(20)<br>
);<br>
create table rest(<br>
rest_id int,<br>
rest_name varchar(20),<br>
rest_address varchar(20),<br>
rest_phone int,<br>
rest_email varchar(20),<br>
city_name varchar(30) primary key,<br>
rest_cuisinetype varchar(20),<br>
rating decimal(2,1),<br>
FOREIGN KEY (city_name)<br>
    REFERENCES city (city_name)<br>
);<br>
create table menu_item(<br>
item_id int,<br>
item_name varchar(20) primary key,<br>
item_description varchar(100),<br>
item_price decimal(6,2),<br>
item_category varchar(20),<br>
item_status varchar(30)<br>
);<br>
create table orders(<br>
order_id int,<br>
order_dateandtime datetime primary key,<br>
delivery_address varchar(100),<br>
total_amount decimal(7,2),<br>
delivery_fee decimal(3,2),<br>
delivery_status varchar(50),<br>
payement_method varchar(30)<br>
);<br>
create table customers(<br>
customer_id int,<br>
customer_full_name varchar(50),<br>
customer_email varchar(20),<br> 
customer_phone int,<br>
customer_address varchar(100),<br>
city_name varchar(30) primary key,<br>
customer_registration_date date,<br>
FOREIGN KEY (city_name)<br>
    REFERENCES city (city_name)<br>
);<br>
create table reviews(<br>
review_id int,<br>
rating decimal(2,1),<br>
comment_text varchar(100),<br> 
review_date date primary key<br>
);<br>
create table delivery_rider(<br> 
delivery_rider_id int,<br>
delivery_rider_name varchar(30),<br>
delivery_rider_phone int,<br>
delivery_rider_vehicle_type varchar(30),<br>
city_name varchar(30) primary key,<br>
delivery_rider_availability_status varchar(30),<br>
FOREIGN KEY (city_name)<br>
    REFERENCES city (city_name)<br>
);<br>
create table status_history(<br>
status_history_id int,<br>
order_status varchar(50) primary key,<br>
order_history varchar(50)<br>
);<br>
<br>
Relations<br>                                                    Cardinality<br>
1. A restaurant belongs to exactly one city.                Many to One<br>
2. Each restaurant has a menu with multiple items.           One to One<br>
3. A customer can place multiple orders.                     One to Many<br>
4. Each order belongs to one customer.                       Many to One<br>
5. Each order belongs to one restaurant.                     Many to Many<br>
6. Each order is assigned to one delivery rider.             Many to One<br>
7. Each order contains one or more order items.              One to Many <br>
8. A customer can only review a restaurant once.             One to One<br>
<br>
<br>This design satisfies 1NF because not every attribute is dependant on a primary key.
