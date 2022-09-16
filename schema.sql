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


CREATE TABLE vets (
vets_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
name varchar(100) ,
age INT,
date_of_graduation date
);


-- association table == join table(contains forign keys)
CREATE TABLE specializations (
 vets_id INT REFERENCES vets (vets_id) ON DELETE CASCADE ON UPDATE CASCADE,
 species_id INT REFERENCES species(species_id) ON DELETE CASCADE ON UPDATE CASCADE
)




CREATE TABLE visits (
 vets_id INT REFERENCES vets (vets_id) ON DELETE CASCADE ON UPDATE CASCADE ,
 id INT REFERENCES animals(id) ON DELETE CASCADE ON UPDATE CASCADE,
 date_of_visit date
)

