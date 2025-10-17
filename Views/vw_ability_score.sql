CREATE VIEW
    vw_ability_score AS
SELECT
    ab.id,
    ab.name,
    ab.full_name,
    ab.description
FROM
    ability_score ab
WHERE
    ab.deleted IS NULL
    OR ab.deleted = 0;