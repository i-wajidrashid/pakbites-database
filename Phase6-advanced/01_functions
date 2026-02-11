delimiter //
Create Function CalculateDeliveryFee (distance_km DECIMAL(5,2)) 
returns decimal deterministic 
begin 
declare fee decimal (5,2);
set fee = case
        when distance_km < 3 then 50.00
        when distance_km >= 3 and distance_km <= 7 then 100.00
        when distance_km > 7 and distance_km <= 15 then 150.00
        else 250.00
           end;
    return fee;
end //
delimiter ;

delimiter //

create function getrestauranttier(avg_rating decimal(3,1))
returns varchar(10)
deterministic
begin
    declare tier varchar(10);
    
    if avg_rating >= 5.0 then
        set tier = 'platinum';
    elseif avg_rating >= 4.0 then
        set tier = 'gold';
    elseif avg_rating >= 3.0 then
        set tier = 'silver';
    else
        set tier = 'bronze';
    end if;
    
    return tier;
end //

delimiter ;

delimiter //
create function formatpkr(amount decimal(15,2))
returns varchar(25)
deterministic
begin
    return concat('Rs. ', format(amount, 2));
end //
delimiter ;