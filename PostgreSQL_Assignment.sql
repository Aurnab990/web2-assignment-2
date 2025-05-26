CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);
CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(255) NOT NULL
);
CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(255) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status)
VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes)
VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- 1st PROBLEM solution
INSERT INTO rangers (ranger_id, name, region) VALUES
(4, 'Derek Fox', 'Coastal Plains');

--  2nd PROBLEM solution
SELECT COUNT(DISTINCT species_id) as unique_species_sighted FROM sightings;

--  3rd PROBLEM solution
SELECT * FROM sightings
WHERE location ILIKE '%pass';

-- 4th PROBLEM solution
SELECT name, COUNT(*) total_sightings FROM rangers
JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY NAME;

-- 5th PROBLEM solution
SELECT common_name FROM species
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.sighting_id IS NULL;

-- 6th Problem solution
SELECT common_name, sighting_time, name from sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY sighting_time DESC
LIMIT 2;

-- 7th Problem solution
UPDATE species
SET conservation_status = 'Historic'
WHERE extract(year FROM discovery_date) < 1800;

-- 8th Problem solution
SELECT sighting_id,
CASE 
    WHEN extract(hour from sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN extract(hour from sighting_time) BETWEEN 17 AND 23 THEN 'Evening'
    ELSE  'Morning'
    END AS time_of_day
FROM sightings;

-- 9th Problem solution
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);
