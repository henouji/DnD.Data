CREATE TABLE level_fighter_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    action_surges INT NOT NULL DEFAULT 1,
    indomitable_uses INT NOT NULL DEFAULT 0,
    extra_attacks INT NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);