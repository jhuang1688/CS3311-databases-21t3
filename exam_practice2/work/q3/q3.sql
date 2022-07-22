-- COMP3311 20T3 Final Exam
-- Q3:  performer(s) who play many instruments

-- ... helper views (if any) go here ...

create or replace view q3(performer,ninstruments)
as
select p.name, count(distinct po.instrument) as ninstruments
from performers p
    join playson po on po.performer = p.id
group by p.name
having count(case po.instrument when 'vocal' then 0 else 1 end) > 6 
order by ninstruments desc
;


-- having count(distinct po.instrument) > 6 
-- case Position when 'Manager' then 1 else null end