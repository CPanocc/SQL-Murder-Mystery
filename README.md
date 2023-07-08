# SQL-Murder-Mystery
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.

Searching for murder on Jan.15, 2018

```SQL
SELECT *
FROM crime_scene_report
WHERE type='murder' AND date='20180115' AND city='SQL City'
```

Result:
| ssn     	| Person  | Id	    | name	  | Gym     | Id	    | membership_status	| check_in_date	plate_number |
| :-------: |  :---:  |  :---:  | :---:   | :---:   | :---:   | :---------------: | :------------------------: | 
| 871539279	| 67318 	| Jeremy  | Bowers	| 48Z55  	| gold	  | 20180109         	| 0H42W2                     | 

