-- COMP3311 20T3 Final Exam
-- Q1: longest album(s)

-- ... helper views (if any) go here ...
create or replace view q1_helper("group",album,year)
as
select g.name, a.title, a.year
from groups g
    join albums a on a.made_by = g.id
    join songs s on s.on_album = a.id
group by g.name, a.title, a.year
order by sum(s.length) desc
;

create or replace view q1("group",album,year)
as
select * from q1_helper
limit 1
;

