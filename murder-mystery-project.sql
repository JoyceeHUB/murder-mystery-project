-- Murder Mystery Project

-- STEP 1: Find the murder crime in SQL City on Jan 15th, 2018
-- Since the crime is a murder that occurred on January 15th, 2018, in SQL City, I used the following SQL query to retrieve the crime details that match these attributes:
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City' AND type = 'murder' AND date = 20180115;

-- This query provided information about two witnesses:
-- 1. The first witness was said to live in the last house on Northwestern Dr.
-- 2. The second witness’s name is Annabel (which could be either a first or last name) and lives somewhere on Franklin Ave.

-- To identify the two witnesses from the person table, I used the following query:
SELECT *
FROM person
WHERE address_street_name LIKE '%Northwestern Dr%'
  AND address_number = (SELECT MAX(address_number) FROM person)
   OR (name LIKE 'Annabel%' AND address_street_name LIKE '%Franklin Ave%');

-- Next, I queried the interview table to get their transcripts using these codes:
SELECT *
FROM interview
WHERE person_id = 16371 OR person_id = 14887;

-- From their transcripts, I obtained details about the killer, including information about a gym bag, membership ID, and membership status. Based on these descriptions, I searched for potential suspects in the get_fit_now_member and get_fit_now_check_in tables with the following codes:
SELECT *
FROM get_fit_now_member m
JOIN get_fit_now_check_in c ON m.id = c.membership_id
WHERE (m.id LIKE '48Z%' AND membership_status = 'gold')
   OR (check_in_date = 20180109 AND (membership_id = '48Z7A' OR membership_id = '48Z55'));

-- I also searched the drivers_license table using this query, but it did not provide any useful clues:
SELECT *
FROM drivers_license
WHERE plate_number LIKE '%H42W%';

-- At this point, I had two suspects. To confirm the culprit, I ran their person IDs in the interview table using this query:
SELECT *
FROM interview
WHERE person_id = 67318 OR person_id = 28819;

-- The results showed that person ID 67318 was the murderer (the transcript had the confession).

-- To determine the suspect’s name, I queried the person table using their ID:
SELECT *
FROM person
WHERE id = 67318;

-- This revealed that the killer was Jeremy Bowers.

-- For the murderer:
-- The killer gave out some personal details on the person’s age, hair color, car model and events she attended including number of times. So I used the code below to try to ascertain:
SELECT *
FROM drivers_license
WHERE car_make = 'Tesla' 
  AND car_model = 'Model S' 
  AND hair_color = 'red' 
  AND age BETWEEN 64 AND 68;

-- 2 results were gotten (license_id 202298 and 291182)

SELECT COUNT(person_id) AS c, *
FROM facebook_event_checkin
WHERE event_name LIKE '%Symphony Concert%' 
  AND date LIKE '201712%' 
GROUP BY person_id
HAVING c = 3;

-- 2 results were gotten (person_id 24556 and 99716)

-- To get the culprit, the person that exists in both results:
SELECT *
FROM person
WHERE (id = 24556 OR id = 99716) 
  AND (license_id = 202298 OR license_id = 291182);

-- Mastermind behind the murder: Miranda Priestly