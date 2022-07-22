-- COMP3311 20T3 Final Exam
-- Q3: team(s) with most players who have never scored a goal

-- ... helpers go here ...

-- create or replace view Q3(team,nplayers)
-- as
-- SELECT t.country, count(p.id)
-- FROM teams t
--     JOIN players p on p.memberof = t.id
--     JOIN goals g on g.scoredby = p.id
-- GROUP BY t.country
-- ;

create or replace view PlayersAndGoals
as
select p.name as player, t.country as team, count(g.id) as goals
from   Teams t
        join Players p on (p.memberof = t.id)
        left outer join Goals g on (p.id = g.scoredby)
group  by p.name, t.country ;

create or replace view CountryAndGoalless
as
select team, count(*) as players
from   PlayersAndGoals
where  goals = 0
group  by team ;

create or replace view Q3
as
select team, players as nplayers
from   CountryAndGoalless
where  players = (select max(players) from CountryAndGoalless) ;
