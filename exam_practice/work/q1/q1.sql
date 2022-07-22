-- COMP3311 20T3 Final Exam
-- Q1: view of teams and #matches

-- ... helper views (if any) go here ...

create or replace view Q1(team,nmatches)
as
SELECT t.country as team, count(i.team) as nmatches
FROM teams as t, involves as i
WHERE t.id = i.team
GROUP BY t.country
ORDER BY team
;

