CREATE VIEW vw_multiclass AS
SELECT 
    mc.id as multiclass_id,
    mc.class_id,
    c.name as class_name,
    
    -- Prerequisites
    ab.name as prerequisite_ability,
    mp.minimum_score,
    
    -- Fixed Proficiencies
    p1.name as proficiency_name,
    
    -- Choice Groups
    mcg.choose_count,
    mcg.choice_type,
    
    -- Choice Options
    p2.name as choice_option_name,
    mco.option_type,
    
    -- Metadata
    mc.created_at,
    mc.updated_at
    
FROM multiclass mc
INNER JOIN classes c ON mc.class_id = c.id
LEFT JOIN multiclass_prerequisite mp ON mc.id = mp.multiclass_id AND mp.deleted_at IS NULL
LEFT JOIN ability_scores ab ON mp.ability_score_id = ab.id
LEFT JOIN multiclass_proficiency mcp ON mc.id = mcp.multiclass_id AND mcp.deleted_at IS NULL
LEFT JOIN proficiencies p1 ON mcp.proficiency_id = p1.id
LEFT JOIN multiclass_proficiency_choice_group mcg ON mc.id = mcg.multiclass_id AND mcg.deleted_at IS NULL
LEFT JOIN multiclass_proficiency_choice_option mco ON mcg.id = mco.choice_group_id AND mco.deleted_at IS NULL
LEFT JOIN proficiencies p2 ON mco.proficiency_id = p2.id
WHERE mc.deleted_at IS NULL;