-- COMP3311 21T3 Exam Q3
-- Unsold house(s) with the lowest listed price
-- Ordered by property ID

create or replace view q3helper(id,price,street,suburb)
as
select p.id, 
        p.list_price, 
        p.street_no || ' ' || s.name || ' ' || s.stype, 
        sb.name
from properties p
    join streets s on s.id = p.street
    join suburbs sb on sb.id = s.suburb
where p.sold_price is null and p.ptype = 'House'
order by p.list_price, p.id
;

create or replace view q3(id,price,street,suburb)
as
select * 
from q3helper
where price = (
    select min(price)
    from q3helper
)
;
