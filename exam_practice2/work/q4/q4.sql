-- COMP3311 20T3 Final Exam
-- Q4: list of long and short songs by each group

-- ... helper views and/or functions (if any) go here ...

create or replace view q4_helper("group", songTitle, songLength)
as
select g.name, s.title, s.length,
	CASE 
		WHEN s.length < 180 then 'short'
		WHEN s.length > 360 then 'long'
	END DURATION

from groups g
	join albums a on a.made_by = g.id
	join songs s on s.on_album = a.id
group by g.name, s.title, s.length
order by g.name
;

drop function if exists q4();
drop type if exists SongCounts;
create type SongCounts as ( "group" text, nshort integer, nlong integer );

create or replace function
	q4() returns setof SongCounts
as $$
declare
	short integer;
	long integer;
	result SongCounts;
begin
	for r in select * from q4_helper
	loop
		if (r.duration = 'short') then
			short := short + 1
		elsif (r.duration = 'long') then
			long := long + 1
		end if;
	end loop;
	return out;
end;
$$ language plpgsql
;
