update restaurants 
set rating = 4.5 where restaurant_id = 1;

UPDATE MenuItems
SET price = price * 1.10
WHERE restaurant_id = 1;

UPDATE deliveryriders
SET status = "Busy"
WHERE rider_id = 1;

START TRANSACTION;
UPDATE Orders 
SET order_status = 'Preparing' 
WHERE order_id = 4 AND order_status = 'Pending';
INSERT INTO OrderStatusHistory (order_id, old_status, new_status, changed_at)
VALUES (4, 'Pending', 'Preparing', CURRENT_TIMESTAMP);
COMMIT;

delete from reviews where review_id = 4;
delete from menuitems
where is_available = 0 AND restaurant_id=2;

UPDATE Customers c
JOIN (
    SELECT customer_id, COUNT(*) as delivery_count 
    FROM Orders 
    WHERE order_status = 'Delivered' 
    GROUP BY customer_id
) o ON c.customer_id = o.customer_id
SET c.loyalty_points = o.delivery_count * 10;

UPDATE Orders
SET order_status = 'Cancelled'
WHERE order_status = 'Pending'
AND ordered_at < NOW() - INTERVAL 24 HOUR;
INSERT INTO OrderStatusHistory (order_id, old_status, new_status, changed_at)
SELECT order_id, 'Pending', 'Cancelled', NOW()
FROM Orders
WHERE order_status = 'Cancelled' 
AND ordered_at < NOW() - INTERVAL 24 HOUR;