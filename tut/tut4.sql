-- Week 4 tutorial SQL

-- SQL querues

-- 12 Find the names of suppliers who supply some red part.
drop view if exists Q12 cascade;
create or replace view Q12(name) as
select distinct s.sname
from suppliers as s, parts as p, catalog as c
where s.sid = c.sid and p.pid = c.pid and p.colour = 'red'
;

-- 13 Find the sids of suppliers who supply some red or green part.
drop view if exists Q13 cascade; 
create of replace view Q13(sid) as
select distinct s.sname
from suppliers as s, parts as p, catalog as c
where s.sid = c.sid and p.pid = c.pid and (p.colour = 'red' or p.colour = 'green')
;

-- 14 Find the sids of suppliers who supply some red part or whose addressis 221 Packer Street.
drop view if exists Q14 cascade;
create of replace view Q14(sid) as
(
select s.sid
from suppliers as s
where s.address = '221 Packer Street'
)
union
(
select distinct c.sid
from parts as p join catalog as c on p.pid = c.pid
where p.colour = 'red'
)
;

-- 15 Find the sids of suppliers who supply some red part and some green part.
drop view if exists Q15 cascade;
(
create or replace view Q15(sid) as
select distinct c.sid 
from parts as p, catalog as c
where p.pid = c.pid and p.colour = 'red'
)
intersect
(
select distinct c.sid
from parts as p, catalog as c
where p.pid = c.pid and p.colour = 'green'
)
;

-- 16 Find the sids of suppliers who supply every part.
drop view if exists Q16 cascade;
create or replace view Q16(sid) as

;

-- 17 Find the sids of suppliers who supply every red part.
drop view if exists Q17 cascade;
create or replace view Q17(sid) as

;

-- 18 Find the sids of suppliers who supply every red or green part.
drop view if exists Q18 cascade;
create or replace view Q18(sid) as

;

-- 19 Find the sids of suppliers who supply every red part or supply every green part.
drop view if exists Q19 cascade;
create or replace view Q19(sid) as

;

-- 20 Find pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.
drop view if exists Q20 cascade;
create or replace view Q20(sid) as

;

-- 21 Find the pids of parts that are supplied by at least two different suppliers.
drop view if exists Q21 cascade;
create or replace view Q21(sid) as

;

-- 22 Find the pids of the most expensive part(s) supplied by suppliers named "Yosemite Sham".
drop view if exists Q22 cascade;
create or replace view Q22(sid) as

;

-- 23 Find the pids of parts supplied by every supplier at a price less than 200 dollars (if any supplier either does not supply the part or charges more than 200 dollars for it, the part should not be selected).
drop view if exists Q23 cascade;
create or replace view Q23(sid) as

;
