create view activeorders as
select 
    o.order_id, 
    concat(c.first_name, ' ', c.last_name) as customer_name, 
    r.name as restaurant_name, 
    concat(dr.first_name, ' ', dr.last_name) as rider_name, 
    o.order_status, 
    timediff(now(), o.ordered_at) as time_since_placed 
from orders o 
join customers c on o.customer_id = c.customer_id 
join restaurants r on o.restaurant_id = r.restaurant_id 
left join deliveryriders dr on o.rider_id = dr.rider_id 
where o.order_status not in ('delivered', 'cancelled');

create view restaurantdashboard as
select 
    r.name, 
    ci.city_name, 
    r.rating, 
    count(distinct o.order_id) as total_orders, 
    sum(o.total_amount) as total_revenue, 
    avg(rv.rating) as avg_review_score, 
    count(distinct m.item_id) as menu_item_count 
from restaurants r 
join cities ci on r.city_id = ci.city_id 
left join orders o on r.restaurant_id = o.restaurant_id 
left join reviews rv on r.restaurant_id = rv.restaurant_id 
left join menuitems m on r.restaurant_id = m.restaurant_id 
group by r.restaurant_id, r.name, ci.city_name, r.rating;

create view customerorderhistory as
select 
    c.customer_id, 
    concat(c.first_name, ' ', c.last_name) as customer_name, 
    o.order_id, 
    group_concat(mi.item_name separator ', ') as items_ordered, 
    o.total_amount, 
    o.ordered_at 
from customers c 
join orders o on c.customer_id = o.customer_id 
join orderitems oi on o.order_id = oi.order_id 
join menuitems mi on oi.item_id = mi.item_id 
group by c.customer_id, o.order_id;

create view topratedrestaurants as
select 
    name, 
    rating 
from restaurants 
where rating >= 4.0 
order by rating desc;

create view riderperformance as
select 
    concat(dr.first_name, ' ', dr.last_name) as rider_name, 
    count(o.order_id) as total_deliveries, 
    dr.status as current_status, 
    ci.city_name 
from deliveryriders dr 
join cities ci on dr.city_id = ci.city_id 
left join orders o on dr.rider_id = o.rider_id and o.order_status = 'delivered' 
group by dr.rider_id, dr.first_name, dr.last_name, dr.status, ci.city_name;

set global event_scheduler = on;

create table dailysummary (
    summary_id int auto_increment primary key,
    summary_date date unique,
    total_orders int,
    total_revenue decimal(10, 2),
    created_at timestamp default current_timestamp
);

delimiter //

create event event_autocancel_pending_orders
on schedule every 15 minute
do
begin
    update orders
    set order_status = 'cancelled'
    where order_status = 'pending'
    and ordered_at < now() - interval 2 hour;
end //

create event event_daily_revenue_summary
on schedule every 1 day
starts (curdate() + interval 1 day)
do
begin
    insert into dailysummary (summary_date, total_orders, total_revenue)
    select 
        curdate() - interval 1 day, 
        count(order_id), 
        coalesce(sum(total_amount), 0)
    from orders
    where date(ordered_at) = curdate() - interval 1 day;
end //

delimiter ;