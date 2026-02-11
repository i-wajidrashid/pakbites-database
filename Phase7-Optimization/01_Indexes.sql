show index from orders;

create index idx_orders_customer_id on orders(customer_id);

create index idx_orders_status on orders(order_status);

create index idx_menuitems_name on menuitems(item_name);

create index idx_restaurants_city_cuisine on restaurants(city_id, cuisine_type);

create index idx_history_order_time on orderstatushistory(order_id, changed_at);

explain select * from orders where customer_id = 5;

explain select r.name, count(o.order_id) from restaurants r join orders o on r.restaurant_id = o.restaurant_id group by r.restaurant_id;

explain select * from menuitems where item_name like 'chicken%';

explain select * from orders where order_status = 'pending';

create index idx_test_pending on orders(order_status);

explain select * from orders where order_status = 'pending';