CREATE TABLE level_barbarian_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    rage_count INT NOT NULL,
    rage_damage_bonus INT NOT NULL,
    brutal_critical_dice INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);