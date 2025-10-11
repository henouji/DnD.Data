-- View for all level data with class-specific information
CREATE VIEW vw_level_complete AS
SELECT 
    l.id,
    l.level,
    l.class_id,
    c.name as class_name,
    l.ability_score_bonuses,
    l.proficiency_bonus,
    
    -- Barbarian specific
    lb.rage_count,
    lb.rage_damage_bonus,
    lb.brutal_critical_dice,
    
    -- Bard specific  
    lbd.bardic_inspiration_die,
    lbd.song_of_rest_die,
    lbd.magical_secrets_max_5,
    lbd.magical_secrets_max_7,
    lbd.magical_secrets_max_9,
    
    -- Cleric specific
    lc.channel_divinity_charges,
    lc.destroy_undead_cr,
    lc.divine_intervention_improvement,
    
    -- Druid specific
    ld.wild_shape_max_cr,
    ld.wild_shape_swim,
    ld.wild_shape_fly,
    
    -- Fighter specific
    lf.action_surges,
    lf.indomitable_uses,
    lf.extra_attacks,
    
    -- Monk specific
    lm.martial_arts_dice_count,
    lm.martial_arts_dice_value,
    lm.ki_points,
    lm.unarmored_movement,
    
    -- Paladin specific
    lp.aura_range,
    
    -- Ranger specific
    lr.favored_enemies,
    lr.favored_terrain,
    
    -- Rogue specific
    lro.sneak_attack_dice,
    
    -- Sorcerer specific
    ls.sorcery_points,
    ls.metamagic_known,
    
    -- Warlock specific
    lw.invocations_known,
    lw.mystic_arcanum_level_6,
    lw.mystic_arcanum_level_7,
    lw.mystic_arcanum_level_8,
    lw.mystic_arcanum_level_9,
    
    -- Wizard specific
    lz.arcane_recovery_levels,
    
    -- Spellcasting
    lsp.cantrips_known,
    lsp.spells_known,
    ab.name as spellcasting_ability,
    lsp.ritual_casting,
    lsp.spellcasting_focus_required

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
    LEFT JOIN level_spellcasting lsp ON l.id = lsp.level_id
    LEFT JOIN ability_score ab ON lsp.spellcasting_ability_id = ab.id;