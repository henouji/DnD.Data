CREATE TABLE level_rogue_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    sneak_attack_dice INT NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);