-- COMP3311 21T3 Exam Q1
-- Properties most recently sold; date, price and type of each
-- Ordered by price, then property ID if prices are equal

create or replace view q1helper(date, price, type)
as
select p.sold_date, p.sold_price, p.ptype 
from properties p
where p.sold_date is not null
order by p.sold_date desc, p.sold_price asc
;

create or replace view q1(date, price, type)
as
select * from q1helper
where date = (
    select max(date)
    from q1helper
)
;
