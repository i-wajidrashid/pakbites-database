show index from orders;

create index idx_orders_customer_id on orders(customer_id);

create index idx_orders_status on orders(order_status);

create index idx_menuitems_name on menuitems(item_name);

create index idx_restaurants_city_cuisine on restaurants(city_id, cuisine_type);

create index idx_history_order_time on orderstatushistory(order_id, changed_at);