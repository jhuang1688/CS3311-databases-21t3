-- COMP3311 21T3 Exam Q2
-- Number of unsold properties of each type in each suburb
-- Ordered by type, then suburb

create or replace view q2(suburb, ptype, nprops)
as
select sb.name, p.ptype, count(p.id)
from properties p
    join streets s on s.id = p.street
    join suburbs sb on sb.id = s.suburb
where p.sold_price is null
group by sb.name, p.ptype
order by p.ptype
;
