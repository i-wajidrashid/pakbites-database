PakBites
PakBites is a company that manages several restaurants across different cities in Pakistan. It manages everything related to each restaurant like Customer Information , Order Information , Menu Information , Orders History Information , Restaurant Information etc.

The technology used in this whole project is MYSQL Workbench 8.0 CE.

Brief Description Of Each Table

customers table Stores user profiles, including names, contact details, and loyalty_points earned through orders.

restaurants table Contains data for food venues, including their name, cuisine_type, average rating, and location linked to a city.

deliveryriders table Tracks the people delivering food, their current status (available, busy, or offline), and their assigned city.

cities table A reference table used to categorize restaurants and riders by their geographic location (e.g., Lahore, Islamabad).

menuitems table Lists all food items available across all restaurants, including item_name, price, and the specific restaurant_id they belong to.

orders table The central table tracking every transaction, including the customer_id, restaurant_id, rider_id, total_amount, order_status, and timestamps.

orderitems table A bridge table that records the specific menu items included in each order, along with the quantity and calculated line_total.

orderstatushistory table Automatically logs every status change for an order (e.g., from 'pending' to 'delivered') to provide a chronological audit trail.

reviews table Stores customer feedback and numeric ratings for specific restaurants they have ordered from.

dailysummary tables A logging table populated by scheduled events to track daily performance metrics like total orders and revenue.

Setup Instructions:

Clone the Repository, Open GitBash and run, git clone pakbites-database Then enter the directory, cd pakbites-repo

Access MySQL, Log into your MySQL Workbench: mysql -u i-wajidrashid -p

Create the Database, Run the command: create database pakbitesdb; use pakbitesdb;

Run SQL Files in Order, Execute the files in sequence

Creates the tables.
Populates the tables with initial data.
Implement Features.
Create the views.
Use Stored Procedures , Triggers , Transactions.

Features Implemented
Functions , Stored Procedures , Triggers , Transactions , Views , Scheduled Events.

3 Interesting Queries 
1. find the top-spending customer to offer a loyalty reward.
select 
    c.first_name, 
    c.last_name, 
    sum(o.total_amount) as total_spent 
from customers c 
join orders o on c.customer_id = o.customer_id 
group by c.customer_id, c.first_name, c.last_name 
order by total_spent desc 
limit 1;

2. identify popular 'chicken' dishes with their prices.
select 
    r.name as restaurant, 
    m.item_name, 
    m.price 
from menuitems m 
join restaurants r on m.restaurant_id = r.restaurant_id 
where m.item_name like '%chicken%' 
order by m.price asc;

3. list restaurants with a high rating (>= 4) and their total order count.
select 
    r.name, 
    r.rating, 
    count(o.order_id) as order_count 
from restaurants r 
left join orders o on r.restaurant_id = o.restaurant_id 
group by r.restaurant_id, r.name, r.rating 
having r.rating >= 4 
order by r.rating desc;

Author Information

Name: Wajid Rashid
Email: i.wajidrashid18@gmail.com
Github Username : i-wajidrashid