CREATE TABLE level_spellcasting
(
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    cantrips_known INT NULL,
    spells_known INT NULL,
    spellcasting_ability_id INT NULL,
    spell_save_dc_bonus INT NULL,
    spell_attack_bonus INT NULL,
    ritual_casting BIT DEFAULT 0,
    spellcasting_focus_required BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    FOREIGN KEY (spellcasting_ability_id) REFERENCES ability_score(id),
    UNIQUE(level_id)
);
GO;

CREATE TABLE level_spell_slots
(
    id INT PRIMARY KEY IDENTITY(1,1),
    level_spellcasting_id INT NOT NULL,
    spell_slot_level_id INT NOT NULL,
    slot_count INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_spellcasting_id) REFERENCES level_spellcasting(id),
    FOREIGN KEY (spell_slot_level_id) REFERENCES spell_slot_level(id),
    UNIQUE(level_spellcasting_id, spell_slot_level_id)
);
GO;