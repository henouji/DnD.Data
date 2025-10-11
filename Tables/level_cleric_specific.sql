CREATE TABLE level_cleric_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    channel_divinity_charges INT NOT NULL DEFAULT 1,
    destroy_undead_cr DECIMAL(3,1) NULL,
    divine_intervention_improvement BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);