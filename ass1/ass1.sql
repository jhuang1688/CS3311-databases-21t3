-- COMP3311 21T3 Assignment 1
--
-- Fill in the gaps ("...") below with your code
-- You can add any auxiliary views/function that you like
-- The code in this file MUST load into a database in one pass
-- It will be tested as follows:
-- createdb test; psql test -f ass1.dump; psql test -f ass1.sql
-- Make sure it can load without errorunder these conditions


-- Q1: oldest brewery

create or replace view Q1(brewery)
as
SELECT breweries.name
FROM breweries 
ORDER BY founded
FETCH FIRST 1 ROW only
;

-- Q2 Helper
-- This helper produces the correct beer ids of collab beers
create or replace view Q2_helper(id)
as
SELECT DISTINCT bb.beer as id
FROM brewed_by as bb
GROUP BY bb.beer
HAVING COUNT(bb.brewery) > 1
;

-- Q2: collaboration beers
-- Using helper
create or replace view Q2(beer)
as
SELECT DISTINCT b.name 
FROM beers as b, q2_helper as beerID
WHERE b.id = beerID.id
;

-- Q3: worst beer

create or replace view Q3(worst)
as
select beers.name
from beers
where rating = (select min(beers.rating) from beers)
;

-- Q4: too strong beer

create or replace view Q4(beer,abv,style,max_abv)
as
SELECT b.name as beer, b.ABV, s.name as style, s.max_abv
FROM beers as b, styles as s
where b.style = s.id and b.ABV > s.max_ABV
;

-- Q5 Helper function
create or replace view Q5_helper(style)
as
SELECT DISTINCT b.style as style, count(b.style)
FROM beers as b
GROUP BY b.style
ORDER BY count(b.style) DESC
LIMIT 1
;

-- Q5: most common style

create or replace view Q5(style)
as
SELECT s.name 
from styles as s, q5_helper as styleID
WHERE s.id = styleID.style
;

-- Q6: duplicated style names

create or replace view Q6(style1,style2)
as
SELECT DISTINCT s1.name as style1, s2.name as style2
FROM styles as s1, styles as s2
WHERE (LOWER(s1.name) = LOWER(s2.name)) AND (s1.name < s2.name) -- Lexographically smaller style name in style 1
;

-- Q7 Helper

create or replace view Q7_helper(brewery)
as
SELECT DISTINCT bb.brewery as brewery, COUNT(bb.beer)
FROM brewed_by as bb
GROUP BY bb.brewery  
ORDER BY COUNT(bb.beer)
;

-- Q7: breweries that make no beers

create or replace view Q7(brewery)
as
SELECT b.name
FROM breweries AS b
WHERE b.id NOT IN (SELECT brewery FROM q7_helper)
;

-- Q8 Helper  
create or replace view Q8_helper(city, country, n)
as
SELECT DISTINCT l.metro as city, l.country, COUNT(b.located_in)
FROM locations as l, breweries as b
WHERE l.metro IS NOT NULL
GROUP BY l.metro, l.country
ORDER BY COUNT(b.located_in) DESC
LIMIT 1
;

-- Q8: city with the most breweries

create or replace view Q8(city,country)
as
SELECT city, country
FROM q8_helper
;

-- Q9 Helper

create or replace view Q9_helper(brewery,nstyles)
as
SELECT DISTINCT bb.brewery as breweryID, COUNT(DISTINCT b.style) as nstyles
FROM brewed_by as bb
INNER JOIN beers b ON bb.beer = b.id
GROUP BY breweryID
HAVING COUNT(DISTINCT b.style) > 5
;

-- Q9: breweries that make more than 5 styles

create or replace view Q9(brewery,nstyles)
as
SELECT DISTINCT b.name as brewery, c.nstyles 
FROM breweries as b, q9_helper as c
WHERE b.id IN (SELECT c.brewery from q9_helper)
;

-- Q10 BeerInfo view
-- STRING_AGG used by following 
-- https://stackoverflow.com/questions/43870/how-to-concatenate-strings-of-a-string-field-in-a-postgresql-group-by-query

create or replace view BeerInfo(beer, brewery, style, year, abv)
as
SELECT DISTINCT 
		b.name as beer, 
	    string_agg(br.name, ' + ' ORDER BY br.name) AS brewery,
	    s.name as style, 
		b.brewed as year, 
		b.ABV as abv
FROM beers as b
		JOIN brewed_by bb ON bb.beer = b.id
		JOIN breweries br ON br.id = bb.brewery
		JOIN styles s ON s.id = b.style
GROUP BY b.id, b.name, s.name, b.brewed, b.ABV
ORDER BY beer
;

-- Q10: beers of a certain style

create or replace function
	q10(_style text) returns setof BeerInfo
as $$
begin
	return query 
		SELECT * FROM beerinfo WHERE style = _style;
end;
$$
language plpgsql;

-- Q11: beers with names matching a pattern

create or replace function
	Q11(partial_name text) returns setof text
as $$
begin
	return query
		SELECT '"' || beerinfo.beer || '", ' || beerinfo.brewery 
				|| ', ' || beerinfo.style || ', ' || beerinfo.abv || '% ABV'
		FROM beerinfo
		WHERE LOWER(beer) ~ partial_name;
end;
$$
language plpgsql;

-- Q12 BreweryInfo
create or replace view BreweryInfo(brewery, founded, location, id)
as
SELECT DISTINCT br.name as brewery, 
		br.founded as foundation_year,
		br.located_in as location,
		br.id
FROM breweries as br
GROUP BY br.name, br.founded, br.located_in, br.id
ORDER BY brewery
;

-- BreweryInfo Line
create or replace function
	BreweryText(partial_name text) returns setof text
as $$
begin
return query
	SELECT bi.brewery || ', founded ' || bi.founded::varchar(255)
	FROM breweryinfo as bi
	WHERE LOWER(brewery) ~ partial_name;
end;
$$
language plpgsql;

-- Location Info
create or replace function
	LocationText(location_id integer) returns setof text
as $$
begin
	return query
		SELECT 'located in ' || l.town || ' ' || 
								l.metro || ' ' || 
								l.region || ' ' ||
								l.country 
		FROM locations as l
		WHERE l.id = location_id;
end;
$$
language plpgsql;

create or replace view LocationInfo(country, region, metro, town, id)
as
SELECT DISTINCT l.country, l.region, l.metro, l.town, l.id
FROM Locations as l
ORDER BY country
;

-- Q12 BeerInfo Line
create or replace function
	BeerText(brewer text) returns setof text
as $$
begin
	return query
		SELECT '  "' || beerinfo.beer || '", ' || beerinfo.style 
				|| ', ' || beerinfo.year || ', ' || beerinfo.abv || '% ABV'
		FROM beerinfo
		WHERE brewery = brewer
		ORDER BY beerinfo.year, beerinfo.beer;
end;
$$
language plpgsql;

-- Q12: breweries and the beers they make

create or replace function
	Q12(partial_name text) returns setof text
as $$
declare
	ed record;
	ed2 record;
begin
	for ed in
		SELECT bi.brewery || ', founded ' || bi.founded::varchar(255)
		FROM BreweryInfo as bi
		WHERE LOWER(bi.brewery) ~ partial_name
	loop
		for ed2 in
			SELECT 'located in ' || l.town || ' ' || 
									l.metro || ' ' || 
									l.region || ' ' ||
									l.country 
			FROM locations as l, BreweryInfo as bi
			WHERE l.id = bi.location and LOWER(bi.brewery) ~ partial_name
		loop
			return next ed2;
		end loop;
		return next ed;
	end loop;
end;
$$
language plpgsql;

