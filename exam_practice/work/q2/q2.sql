-- COMP3311 20T3 Final Exam
-- Q2: view of amazing goal scorers

-- ... helpers go here ...

create or replace view Q2(player,ngoals)
as
SELECT p.name, count(g.scoredby) as ngoals
FROM goals g
    JOIN players p on p.id = g.scoredby
WHERE g.rating = 'amazing' 
GROUP BY p.name
HAVING  count(g.scoredby) > 1
ORDER BY ngoals ASC, p.name
;

