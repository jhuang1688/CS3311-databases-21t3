-- COMP3311 21T3 Exam Q4
-- Return address for a property, given its ID
-- Format: [UnitNum/]StreetNum StreetName StreetType, Suburb Postode
-- If property ID is not in the database, return 'No such property'

create or replace view q4street_no(id, unit_no, prop_no)
as 
select p.id, p.unit_no,
		case
			when p.unit_no is null then ''
			when p.unit_no is not null then p.unit_no || '/'
		end apartment_no
from properties p
;

create or replace view q4helper(id, addr_text)
as 
select p.id, so.prop_no || p.street_no || ' ' || s.name || ' ' || s.stype || ', ' || sb.name || ' ' || sb.postcode
from properties p
	join streets s on s.id = p.street
	join suburbs sb on sb.id = s.suburb
	join q4street_no so on so.id = p.id
;

create or replace function 
address(propID integer) returns text
as
$$
declare
	-- ... your PLpgSQL variable declarations go here
begin
	-- ... your PLpgSQL function code goes here ...
	return 
		select addr_text from q4helper where id = propID;
end;
$$ language plpgsql;
