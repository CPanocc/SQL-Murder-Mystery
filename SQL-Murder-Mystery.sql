--Searching for information about a murder on 15 January 2018
SELECT *
FROM crime_scene_report
WHERE type = 'murder' AND date = '20180115' AND city = 'SQL City'

--Seeking the witnesses
--The first witness:
SELECT *
FROM person 
WHERE address_street_name = 'Northwestern Dr' 
ORDER BY address_number DESC
LIMIT 1

--The second witness:
SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave' AND name LIKE '%Annabel%'

--Witnesses - interviews:
SELECT *
FROM interview 
WHERE person_id = 14887 OR person_id = 16371

--Identify suspect:
SELECT m.name, membership_id, membership_status, check_in_date, plate_number
FROM get_fit_now_member as m
JOIN get_fit_now_check_in as c ON m.id = c.membership_id
JOIN person as p ON m.person_id = p.id
JOIN drivers_license as d ON p.license_id = d.id
WHERE membership_id like '48Z%'
AND membership_status = 'gold'
AND check_in_date like '%0109'
AND plate_number like '%H42W%'
  
--Check your solution
INSERT INTO solution VALUES (1, 'Jeremy Bowers')
SELECT value
FROM solution

--Murderer - interview:
SELECT *
FROM interview
WHERE person_id = 67318

--Identify suspect:
SELECT distinct name, car_make, car_model, height, hair_color,
  count(event_name='SQL Symphony Concert' and f.date like '201712%') as dec_2017_times_at_concert
FROM person p
JOIN drivers_license as d ON p.license_id = d.id
JOIN facebook_event_checkin as f ON f.person_id = p.id
WHERE gender = 'female' 
AND d.car_make = 'Tesla' 
AND d.car_model = 'Model S'
AND hair_color = 'red'
  
--Check your solution:
INSERT INTO solution VALUES (1, 'Miranda Priestly')
SELECT value FROM solution
