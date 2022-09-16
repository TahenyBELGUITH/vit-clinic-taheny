/*Queries that provide answers to the questions from all projects.*/

/*Find all animals whose name ends in "mon".*/
SELECT * from animals WHERE name like '%mon';

/*List the name of all animals born between 2016 and 2019.*/
SELECT name FROM animals WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-12-31';

/*List the name of all animals that are neutered and have less than 3 escape attempts.*/
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

/*List the date of birth of all animals named either "Agumon" or "Pikachu".*/
 SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

/*List name and escape attempts of animals that weight more than 10.5kg*/
 SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

/*Find all animals that are neutered.*/
SELECT name FROM animals where neutered = true;

/*Find all animals not named Gabumon.*/
SELECT name FROM animals WHERE name != 'Gabumon';

/*Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)*/
SELECT name FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.

BEGIN;
UPDATE animals 
SET species = 'unspecified';

SELECT name, species 
FROM animals;

ROLLBACK;

SELECT name, species 
FROM animals;


-- Inside a transaction:
-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
-- Commit the transaction.
-- Verify that change was made and persists after commit.

BEGIN;
UPDATE animals 
SET species = 'digimon' 
WHERE name LIKE '%mon';

UPDATE animals 
SET species = 'pokemon' 
WHERE species IS NULL;

SELECT name, species 
FROM animals;
COMMIT;
 
 -- Inside a transaction delete all records in the animals table, then roll back the transaction.
BEGIN;
DELETE 
FROM animals;
ROLLBACK;


-- Inside a transaction:
-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
-- Update all animals' weight to be their weight multiplied by -1.
-- Rollback to the savepoint
-- Update all animals' weights that are negative to be their weight multiplied by -1.
-- Commit transaction
BEGIN; 
DELETE 
FROM animals 
WHERE date_of_birth > '01-01-2022';

SELECT name, date_of_birth 
FROM animals;

SAVEPOINT SP1;

UPDATE animals 
SET weight_kg = weight_kg * -1;

SELECT name, weight_kg 
FROM animals;

ROLLBACK TO SP1;

UPDATE animals 
SET weight_kg = weight_kg * -1 
WHERE weight_kg < 0;

SELECT name, weight_kg 
FROM animals;
COMMIT;

-- Write queries to answer the following questions:
-- How many animals are there?
-- How many animals have never tried to escape?
-- What is the average weight of animals?
-- Who escapes the most, neutered or not neutered animals?
-- What is the minimum and maximum weight of each type of animal?
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT COUNT(*) AS animals_count 
FROM animals;

SELECT COUNT(*) AS never_escaped_animals 
FROM animals 
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS avg_weight 
FROM animals;

SELECT COUNT(escape_attempts) AS escape_count, neutered 
FROM animals 
GROUP BY neutered;

SELECT MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight, species 
FROM animals 
GROUP BY species;

SELECT AVG(escape_attempts) as avg_escapes, species 
FROM animals 
WHERE date_of_birth BETWEEN '01-01-1990' AND '12-31-2000' 
GROUP BY species;


-- Write queries (using JOIN) to answer the following questions:

-- What animals belong to Melody Pond?

SELECT name from animals
JOIN owners 
ON owners.full_name = 'Melody Pond' AND animals.owners_id = owners.owners_id;


-- List of all animals that are pokemon (their type is Pokemon).

SELECT * from animals
JOIN species 
ON species.name = 'Pokemon' AND species.species_id = animals.species_id;


-- List all owners and their animals, remember to include those that don't own any animal.

SELECT owners.full_name, animals.name
from owners
LEFT JOIN animals 
ON owners.owners_id = animals.owners_id;

-- How many animals are there per species?

SELECT COUNT(*), species.species_id
from animals
JOIN species
ON animals.species_id = species.species_id
GROUP BY species.species_id;


-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, animals.id, owners.full_name
from animals
JOIN owners ON animals.owners_id = owners.owners_id
AND owners.full_name = 'Jennifer Orwell' AND animals.species_id=(SELECT species_id from species where name='Digimon');


-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name,animals.escape_attempts
from animals
JOIN owners ON animals.owners_id = owners.owners_id
AND owners.full_name = 'Dean Winchester' AND animals.escape_attempts=0;

-- Who owns the most animals?
SELECT COUNT(*), owners.full_name from animals
JOIN owners ON animals.owners_id=owners.owners_id
GROUP BY owners.full_name
ORDER BY COUNT(*) desc
LIMIT 1;


-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name , date_of_visit from visits
INNER JOIN animals ON visits.id = animals.id 
AND vets.vets_id = (SELECT vets_id from vets where name ='William Tatcher')
INNER JOIN vets ON visits.vets_id = vets.vets_id 
ORDER BY date_of_visit desc
LIMIT 1;


-- How many different animals did Stephanie Mendez see?
SELECT DISTINCT  animals.name , vets.name from visits
INNER JOIN vets ON vets.vets_id = visits.vets_id
INNER JOIN animals ON vets.vets_id = (SELECT vets_id from vets where name ='Stephanie Mendez') 
AND animals.id = visits.id;


-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name from specializations 
RIGHT JOIN vets ON vets.vets_id = specializations.vets_id
LEFT JOIN species  ON  species.species_id = specializations.species_id; 


-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name , vets.name from visits 
INNER JOIN vets ON vets.vets_id = visits.vets_id 
AND  date_of_visit  BETWEEN 'Apr 1 , 2020' AND ' Aug 30, 2020'
INNER JOIN animals ON animals.id = visits.id 
AND vets.vets_id = (SELECT vets_id from vets where vets.name = 'Stephanie Mendez')



-- What animal has the most visits to vets?
SELECT animals.name , COUNT(animals.id) from visits 
INNER JOIN vets ON vets.vets_id = visits.vets_id 
INNER JOIN animals ON animals.id = visits.id 
GROUP BY animals.name
ORDER BY COUNT(animals.id) desc
LIMIT 1;



-- Who was Maisy Smith's first visit?
SELECT animals.name , date_of_visit from visits 
INNER JOIN vets ON vets.vets_id = visits.vets_id 
INNER JOIN animals ON animals.id = visits.id AND vets.name ='Maisy Smith'
ORDER BY date_of_visit 
LIMIT 1;


-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT * from visits 
FULL OUTER JOIN vets ON vets.vets_id = visits.vets_id 
FULL OUTER JOIN animals ON animals.id = visits.id 
ORDER BY  date_of_visit desc
LIMIT 1;




-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) 
FROM vets
JOIN visits ON visits.vets_id = vets.vets_id
JOIN animals ON visits.id = animals.id
JOIN specializations ON vets.vets_id = specializations.vets_id
WHERE NOT specializations.species_id = animals.species_id;




-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name
FROM animals
JOIN species ON species.species_id = animals.species_id
JOIN visits ON visits.id = animals.id
JOIN vets ON vets.vets_id = visits.vets_id AND vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(species.species_id) DESC
LIMIT 1;

