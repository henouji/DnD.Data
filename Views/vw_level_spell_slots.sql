-- View for spell slots by level and class
CREATE VIEW vw_level_spell_slots AS
SELECT 
    l.id as level_id,
    l.level,
    l.class_id,
    c.name as class_name,
    ssl.level as spell_level,
    ssl.name as spell_level_name,
    lss.slot_count,
    lsp.cantrips_known,
    lsp.spells_known
FROM level l
    JOIN class c ON l.class_id = c.id
    JOIN level_spellcasting lsp ON l.id = lsp.level_id
    JOIN level_spell_slots lss ON lsp.id = lss.level_spellcasting_id
    JOIN spell_slot_level ssl ON lss.spell_slot_level_id = ssl.id
WHERE lss.slot_count > 0
ORDER BY l.level, ssl.level;