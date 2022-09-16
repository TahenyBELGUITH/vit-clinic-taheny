/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name varchar(100) ,
date_of_birth date ,
escape_attempts INT ,
neutered boolean ,
weight_kg decimal ,
species varchar(100)
);


CREATE TABLE owners (
owners_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
full_name varchar(100) ,
age INT
);



CREATE TABLE species (
species_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name varchar(100)
);


-- drop column
ALTER TABLE animals DROP COLUMN species;

-- add forign key
ALTER TABLE animals
ADD species_id INT REFERENCES species(species_id);


ALTER TABLE animals
ADD owners_id INT REFERENCES owners(owners_id);


