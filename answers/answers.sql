-- Part 2: Simple Selects and Counts
-- What are all the types of pokemon that a pokemon can have?
SELECT name AS "Possible Types"
FROM types;

-- What is the name of the pokemon with id 45?
SELECT name AS "Pokemon"
FROM pokemons
WHERE id = 45;

-- How many pokemon are there?
SELECT COUNT(id) as "Number of Pokemon"
FROM pokemons;

-- How many types are there?
SELECT COUNT(id) as "Number of Types"
FROM types;

-- How many pokemon have a secondary type?
SELECT COUNT(id) as "Number of Pokemon with Secondary Types"
FROM pokemons
WHERE secondary_type IS NOT NULL;

-- Part 3: Joins and Groups
-- What is each pokemon's primary type?
SELECT pokemons.name AS "Pokemon",
    types.name AS "Primary Type"
FROM pokemons
    INNER JOIN types ON pokemons.primary_type = types.id;

-- What is Rufflet's secondary type?
SELECT types.name AS "Rufflet's secondary type"
FROM pokemons
    INNER JOIN types ON pokemons.secondary_type = types.id
WHERE pokemons.name = "Rufflet";

-- What are the names of the pokemon that belong to the trainer with trainer ID
-- 303?
SELECT pokemons.name AS "Trainer 303 Pokemon names"
FROM pokemon_trainer
    INNER JOIN pokemons ON pokemon_trainer.pokemon_id = pokemons.id
WHERE trainerID = 303;

-- How many pokemon have a secondary type Poison?
SELECT COUNT(pokemons.id) AS "Number of Pokemon with secondary type Poison"
FROM pokemons
    INNER JOIN types ON pokemons.secondary_type = types.id
WHERE types.name = "Poison";

-- What are all the primary types and how many pokemon have that type?
SELECT types.name AS "Primary Type",
    COUNT(pokemons.id) AS "Number of Pokemon"
FROM pokemons
    INNER JOIN types ON pokemons.primary_type = types.id
GROUP BY types.name;

-- How many pokemon at level 100 does each trainer with at least one level 100
-- pokemon have? (Hint: your query should not display a trainer)
SELECT COUNT(pokemon_trainer.pokelevel) AS "Number of Level 100 Pokemon"
FROM pokemon_trainer
    INNER JOIN pokemons ON pokemon_trainer.pokemon_id = pokemons.id
    INNER JOIN trainers ON pokemon_trainer.trainerID = trainers.trainerID
WHERE pokelevel = 100
GROUP BY trainers.trainerID
ORDER BY "Number of Level 100 Pokemon" DESC;

-- How many pokemon only belong to one trainer and no other?
SELECT COUNT(count) AS "Number of Pokemon belonging to one trainer"
FROM (
        SELECT COUNT(trainerID) as count
        FROM pokemon_trainer
        GROUP BY pokemon_id
        HAVING count = 1
    ) AS t;

-- Part 4: Final Report
-- Write a query that returns the columns: Pokemon Name, Trainer Name, Level,
-- Primary Type Name, Secondary Type Name. Sort the data by finding out which
-- trainer has the strongest pokemon so that this will act as a ranking of
-- strongest to weakest trainer. You may interpret strongest in whatever way
-- you want, but you will have to explain your decision.
SELECT pokemons.name AS "Pokemon Name",
    trainers.trainerName AS "Trainer Name",
    pokemon_trainer.pokelevel AS "Level",
    type1.name AS "Primary Type Name",
    type2.name AS "Secondary Type Name"
FROM pokemon_trainer
    INNER JOIN pokemons ON pokemon_trainer.pokemon_id = pokemons.id
    INNER JOIN trainers ON pokemon_trainer.trainerID = trainers.trainerID
    INNER JOIN types type1 ON pokemons.primary_type = type1.id
    LEFT JOIN types type2 ON pokemons.secondary_type = type2.id
    INNER JOIN (
        SELECT trainerID,
            SUM(pokelevel) AS levelSum,
            SUM(hp) as healthSum
        FROM pokemon_trainer
        GROUP BY trainerID
    ) AS t3 ON pokemon_trainer.trainerID = t3.trainerID
ORDER BY levelSum DESC,
    healthSum DESC,
    pokemon_trainer.hp DESC;
