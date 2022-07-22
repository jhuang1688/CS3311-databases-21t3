-- COMP3311 20T3 Final Exam
-- Q5: show "cards" awarded against a given team

-- ... helper views and/or functions go here ...

-- drop view if exists YellowCardsFor;
create or replace view YellowCardsFor(team,ncards)
as
select t.country, count(c.givento) as nyellow
from   cards c
       join players p on (c.givento = p.id)
	   join teams t on (t.id = p.memberof)
where  c.cardtype = 'yellow'
group by t.country
;

create or replace view YellowCards(team,ncards)
as
select t.country, coalesce(c.ncards,0)
from   Teams t left outer join YellowCardsFor c on (t.country=c.team) ;

-- drop view if exists RedCardsFor;
create or replace view RedCardsFor(team,ncards)
as
select t.country, count(c.givento) as nred
from   cards c
       join players p on (c.givento = p.id)
	   join teams t on (t.id = p.memberof)
where  c.cardtype = 'red'
group by t.country
;

create or replace view RedCards(team,ncards)
as
select t.country, coalesce(c.ncards,0)
from   Teams t left outer join RedCardsFor c on (t.country=c.team) ;

drop function if exists q5(text);
drop type if exists RedYellow;

create type RedYellow as (nreds integer, nyellows integer);

create or replace function
	Q5(_team text) returns RedYellow
as $$
declare
	reds integer;
	yellows integer;
	result RedYellow;
begin
	select r.ncards, y.ncards into reds, yellows
	from   RedCards r
	       join YellowCards y on (r.team = y.team)
	where  r.team = _team;
	if (not found) then
		result.nreds := NULL;
		result.nyellows := NULL;
	else
		result.nreds := reds;
		result.nyellows := yellows;
	end if;
	return result;
end;
$$ language plpgsql
;
