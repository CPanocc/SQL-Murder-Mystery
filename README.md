# SQL-Murder-Mystery
Challenge website:
[The SQL Murder Mystery](https://mystery.knightlab.com/)

A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.


1. Search for information about a murder on 15 January 2018:

```SQL
SELECT *
FROM crime_scene_report
WHERE type = 'murder'
AND date = '20180115'
AND city = 'SQL City'
```
Result:
| date     |	type   |	description |	city    |
| :------: | :-----: | :----------: | :-----: | 
| 20180115 |	murder |	Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave". |	SQL City |

2. Seek the witnesses:

The first witness:
```SQL
SELECT *
FROM person 
WHERE address_street_name = 'Northwestern Dr' 
ORDER BY address_number DESC
LIMIT 1
```
Result:
| id  	| name          	| license_id	| address_number	| address_street_name	| ssn       | 
| :---: | :------------:  |  :-------:  | :-------------: | :-----------------: | :-------: |
| 14887	| Morty Schapiro	| 118009    	| 4919	          | Northwestern Dr	    | 111564949 | 

The second witness:
```SQL
SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave'
AND name LIKE '%Annabel%'
```
Result:
| id  	| name          	| license_id	| address_number	| address_street_name	| ssn       | 
| :---: | :------------:  |  :-------:  | :-------------: | :-----------------: | :-------: |
| 16371	| Annabel Miller	| 490173    	| 103 	          | Franklin Ave  	    | 318771143 | 


3. Witnesses - interview:
```SQL
SELECT *
FROM interview 
WHERE person_id = 14887 OR person_id = 16371
```
Result:
| name            |	id   	| transcript  |
| :-------------: | :--:  |  :-------:  |
| Morty Schapiro	| 14887	| I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W". |
| Annabel Miller	| 16371 |	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th. |

4. Identify suspect:
```SQL
SELECT m.name, membership_id, membership_status, check_in_date, plate_number
FROM get_fit_now_member as m
JOIN get_fit_now_check_in as c ON m.id = c.membership_id
JOIN person as p ON m.person_id = p.id
JOIN drivers_license as d ON p.license_id = d.id
WHERE membership_id like '48Z%'
AND membership_status = 'gold'
AND check_in_date like '%0109'
AND plate_number like '%H42W%'
```
Result:
| name          |	person_id	|	person_id	  |	membership_status | check_in_date     | plate_number      |
| :-----------: | :-------: | :---------: | :----------------:| :---------------: | :---------------: |  
| Jeremy Bowers	|	67318    	|	48Z55	      |	gold              |	20180109          |	0H42W2            |


6. Check solution:
```SQL
INSERT INTO solution VALUES (1, 'Jeremy Bowers')
SELECT value
FROM solution
```
Result:
| value |
| :---: | 
| Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer. |

7. Murderer - interview:
```SQL
SELECT *
FROM interview
WHERE person_id = 67318
```
Result:
| person_id |	transcript |
| :-------: | :--------: | 
| 67318     |	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017. |

8. Identify suspect:
```SQL
SELECT distinct name, car_make, car_model, height, hair_color,
  count(event_name='SQL Symphony Concert' and f.date like '201712%') as dec_2017_times_at_concert
FROM person p
JOIN drivers_license as d ON p.license_id = d.id
JOIN facebook_event_checkin as f ON f.person_id = p.id
WHERE gender = 'female' 
AND d.car_make = 'Tesla' 
AND d.car_model = 'Model S'
AND hair_color = 'red'
```

Result:
| name	            | car_make	  | car_model	 | height	| hair_color | dec_2017_times_at_concert |
| :---------------: | :---------: | :--------: | :----: | :-------:  | :-------:                 |
| Miranda Priestly	| Tesla	      | Model S    | 66	    | red        | 3                         |

9. Check solution:
```SQL
INSERT INTO solution VALUES (1, 'Miranda Priestly')
SELECT value FROM solution
```
Result:
| value |
| :---: | 
| Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne! |
