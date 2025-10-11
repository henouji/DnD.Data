-- View for class progression summaries
CREATE VIEW vw_class_progression AS
SELECT 
    c.name as class_name,
    l.level,
    l.proficiency_bonus,
    l.ability_score_bonuses,
    
    -- Primary class resource (varies by class)
    CASE 
        WHEN c.name = 'Barbarian' THEN CAST(lb.rage_count AS NVARCHAR(20))
        WHEN c.name = 'Bard' THEN CAST(lbd.bardic_inspiration_die AS NVARCHAR(20)) + 'd6'
        WHEN c.name = 'Cleric' THEN CAST(lc.channel_divinity_charges AS NVARCHAR(20)) + ' Channel Divinity'
        WHEN c.name = 'Druid' THEN 'CR ' + CAST(ld.wild_shape_max_cr AS NVARCHAR(20))
        WHEN c.name = 'Fighter' THEN CAST(lf.action_surges AS NVARCHAR(20)) + ' Action Surge'
        WHEN c.name = 'Monk' THEN CAST(lm.ki_points AS NVARCHAR(20)) + ' Ki Points'
        WHEN c.name = 'Paladin' THEN CAST(lp.aura_range AS NVARCHAR(20)) + 'ft Aura'
        WHEN c.name = 'Ranger' THEN CAST(lr.favored_enemies AS NVARCHAR(20)) + ' Favored Enemies'
        WHEN c.name = 'Rogue' THEN CAST(lro.sneak_attack_dice AS NVARCHAR(20)) + 'd6 Sneak Attack'
        WHEN c.name = 'Sorcerer' THEN CAST(ls.sorcery_points AS NVARCHAR(20)) + ' Sorcery Points'
        WHEN c.name = 'Warlock' THEN CAST(lw.invocations_known AS NVARCHAR(20)) + ' Invocations'
        WHEN c.name = 'Wizard' THEN 'Level ' + CAST(lz.arcane_recovery_levels AS NVARCHAR(20)) + ' Recovery'
        ELSE 'N/A'
    END as primary_resource,
    
    -- Spellcasting info
    lsp.cantrips_known,
    lsp.spells_known,
    
    -- Count of spell slots by level
    (SELECT COUNT(*) FROM level_spell_slots lss2 
     JOIN spell_slot_level ssl2 ON lss2.spell_slot_level_id = ssl2.id
     WHERE lss2.level_spellcasting_id = lsp.id AND ssl2.level = 1 AND lss2.slot_count > 0) as has_1st_level_slots,
    (SELECT COUNT(*) FROM level_spell_slots lss2 
     JOIN spell_slot_level ssl2 ON lss2.spell_slot_level_id = ssl2.id
     WHERE lss2.level_spellcasting_id = lsp.id AND ssl2.level = 2 AND lss2.slot_count > 0) as has_2nd_level_slots,
    (SELECT COUNT(*) FROM level_spell_slots lss2 
     JOIN spell_slot_level ssl2 ON lss2.spell_slot_level_id = ssl2.id
     WHERE lss2.level_spellcasting_id = lsp.id AND ssl2.level = 3 AND lss2.slot_count > 0) as has_3rd_level_slots
    
FROM level l
    JOIN class c ON l.class_id = c.id
    LEFT JOIN level_barbarian_specific lb ON l.id = lb.level_id
    LEFT JOIN level_bard_specific lbd ON l.id = lbd.level_id
    LEFT JOIN level_cleric_specific lc ON l.id = lc.level_id
    LEFT JOIN level_druid_specific ld ON l.id = ld.level_id
    LEFT JOIN level_fighter_specific lf ON l.id = lf.level_id
    LEFT JOIN level_monk_specific lm ON l.id = lm.level_id
    LEFT JOIN level_paladin_specific lp ON l.id = lp.level_id
    LEFT JOIN level_ranger_specific lr ON l.id = lr.level_id
    LEFT JOIN level_rogue_specific lro ON l.id = lro.level_id
    LEFT JOIN level_sorcerer_specific ls ON l.id = ls.level_id
    LEFT JOIN level_warlock_specific lw ON l.id = lw.level_id
    LEFT JOIN level_wizard_specific lz ON l.id = lz.level_id
    LEFT JOIN level_spellcasting lsp ON l.id = lsp.level_id;