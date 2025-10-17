CREATE VIEW
    vw_alignment AS
SELECT
    a.id,
    a.name,
    a.abbreviation,
    a.description
    IFNULL(a.updated_at, a.created_at) AS modified_date
FROM
    alignment a
WHERE a.deleted IS NULL OR a.deleted = 0;