# SQL-Murder-Mystery
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.

1. Searching for information about a murder on 15 January 2018:

```SQL
SELECT *
FROM crime_scene_report
WHERE type = 'murder' AND date = '20180115' AND city = 'SQL City'
```
Result:
| date     |	type   |	description |	city    |
| :------: | :-----: | :----------: | :-----: | 
| 20180115 |	murder |	Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave". |	SQL City |

2. Seeking the witnesses:

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
WHERE address_street_name = 'Franklin Ave' AND name LIKE '%Annabel%'
```
Result:
| id  	| name          	| license_id	| address_number	| address_street_name	| ssn       | 
| :---: | :------------:  |  :-------:  | :-------------: | :-----------------: | :-------: |
| 16371	| Annabel Miller	| 490173    	| 103 	          | Franklin Ave  	    | 318771143 | 


3. Witnesses - interview:
```SQL
SELECT p.name, p.id, i.transcript
FROM interview i
JOIN person as p
  ON i.person_id = p.id
WHERE p.id = 14887 OR p.id = 16371
```
Result:
| name            |	id   	| transcript  |
| :-------------: | :--:  |  :-------:  |
| Morty Schapiro	| 14887	| I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W". |
| Annabel Miller	| 16371 |	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th. |

4. Checking Morty Schapiro interview:
```SQL
SELECT p.name, p.license_id,
  d.id, d.age, d.height, d.eye_color, d.hair_color, d.gender, 
  d.plate_number, d.car_make, d.car_model
FROM drivers_license d 
JOIN person p
  ON p.license_id=d.id
WHERE d.plate_number LIKE '%H42W%'
```
Result:
|name            	| license_id	| id	    | age	 | height	| eye_color	| hair_color	| gender	| plate_number	| car_make	| car_model  |
| :-------------: | :--:        | :---:   | :---:| :--:   | :-------: | :---------: | :--:    |  :-------:    | :-------: | :--------: | 
|Tushar Chandra 	| 664760	    | 664760	| 21	 | 71   	| black   	| black	      | male	  | 4H42WR      	| Nissan	  | Altima     |
|Jeremy Bowers	  | 423327	    | 423327	| 30	 | 70	    | brown	    | brown     	| male	  | 0H42W2	      | Chevrolet | Spark LS   |
|Maxine Whitely 	| 183779	    | 183779	| 21	 | 65	    | blue	    | blonde    	| female	| H42W0X       	| Toyota	  | Prius      |


```SQL
SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%' AND membership_status = 'gold'
```
Result:
| id    |	person_id	|	name	        |	membership_start_date	|	membership_status |	
| :---: | :-------: | :---------:   | :--------------------:| :---------------: |
| 48Z7A |	28819	    |	Joe Germuska	|	20160305            	|	gold              |	     
| 48Z55 |	67318    	|	Jeremy Bowers	|	20160101            	|	gold              |	

5. Checking Annabel Miller interview:
```SQL
SELECT m.id, m.person_id, m.membership_status,
  c.check_in_date, c.check_in_time, c.check_out_time
FROM get_fit_now_check_in c 
JOIN get_fit_now_member m
  ON m.id = c.membership_id
WHERE c.check_in_date = 20180109 AND m.membership_status = 'gold' AND m.person_id = 67318
```
Result:
| id	  |	person_id	|	membership_status	|	check_in_date | check_in_time	|	check_out_time |	
| :---: | :-------: | :-------------:   | :------------:| :-----------: | :------------: |
| 48Z55	|	67318	    |	gold            	|	20180109	    |	1530	        |	1700           |	


6. Check your solution:
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

8. Checking woman:

First option:
```SQL
SELECT *
FROM person p
JOIN drivers_license d
  ON p.license_id = d.id
JOIN facebook_event_checkin f
  ON f.person_id = p.id
WHERE gender = 'female' AND d.car_make = 'Tesla' AND d.car_model = 'Model S'
AND f.event_name = 'SQL Symphony Concert'
```

Second option:
```SQL
SELECT *
FROM person
WHERE id =
  (SELECT person_id
  FROM facebook_event_checkin
  WHERE event_name = 'SQL Symphony Concert' AND date like '201712%'
  GROUP BY person_id
  HAVING COUNT(DISTINCT event_name) = 3)
OR
license_id =
  (SELECT id
  FROM drivers_license
  WHERE gender = 'female' AND hair_color = 'red' AND height between 65 and 67
  AND car_make = 'Tesla' AND car_model = 'Model S')
OR
id =
  (SELECT ssn
  FROM income
  ORDER BY annual_income)
```
Result:
| id	  | name	            | license_id	| address_number	| address_street_name	| ssn       | 
| :---: | :---------------: | :---------: | :-------------: | :-----------------: | :-------: | 
| 99716	| Miranda Priestly	| 202298	    | 1883          	| Golden Ave	        | 987756388 | 

9. Check your solution:
```SQL
INSERT INTO solution VALUES (1, 'Miranda Priestly')
SELECT value FROM solution
```
Result:
| value |
| :---: | 
| Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne! |
