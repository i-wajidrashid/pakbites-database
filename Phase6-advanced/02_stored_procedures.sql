delimiter //

create trigger trg_orderitems_before_insert
before insert on orderitems
for each row
begin
    set new.unit_price = (select price from menuitems where item_id = new.item_id);
    set new.line_total = new.quantity * new.unit_price;
end //

create trigger trg_orderitems_after_insert
after insert on orderitems
for each row
begin
    update orders 
    set total_amount = total_amount + new.line_total 
    where order_id = new.order_id;
end //

create trigger trg_orderitems_after_delete
after delete on orderitems
for each row
begin
    update orders 
    set total_amount = total_amount - old.line_total 
    where order_id = old.order_id;
end //

create trigger trg_orders_after_update_status
after update on orders
for each row
begin
    if old.order_status <> new.order_status then
        insert into orderstatushistory (order_id, old_status, new_status, changed_at)
        values (new.order_id, old.order_status, new.order_status, current_timestamp);
    end if;
end //

create trigger trg_reviews_before_insert
before insert on reviews
for each row
begin
    if not exists (select 1 from orders where customer_id = new.customer_id and restaurant_id = new.restaurant_id) then
        signal sqlstate '45000' set message_text = 'customer must order from restaurant before reviewing';
    end if;
end //

create trigger trg_reviews_after_insert
after insert on reviews
for each row
begin
    update restaurants 
    set rating = (select avg(rating) from reviews where restaurant_id = new.restaurant_id)
    where restaurant_id = new.restaurant_id;
end //

delimiter ;