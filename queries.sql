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