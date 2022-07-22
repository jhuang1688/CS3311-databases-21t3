-- COMP3311 20T3 Final Exam
-- Q4: function that takes two team names and
--     returns #matches they've played against each other

-- ... helper views and/or functions (if any) go here ...

create or replace function
	CountryInvolves(text) returns setof integer
as $$
select m.id
from   Matches m
       join Involves i on (m.id = i.match)
       join Teams t on (i.team = t.id)
where  t.country = $1
$$ language sql
;

create or replace function
    Q4(_team1 text, _team2 text) returns integer
as $$
declare
    nmatches integer;
begin
    perform * from Teams where country = _team1;
    if (not found) then return NULL; end if;
    perform * from Teams where country = _team2;
    if (not found) then return NULL; end if;
    select count(*) into nmatches
    from   ((select * from CountryInvolves(_team1))
            intersect
            (select * from CountryInvolves(_team2))
           ) as X;
     return nmatches;
end;
$$ language plpgsql;
