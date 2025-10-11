CREATE TABLE level_warlock_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    invocations_known INT NOT NULL DEFAULT 0,
    mystic_arcanum_level_6 INT NOT NULL DEFAULT 0,
    mystic_arcanum_level_7 INT NOT NULL DEFAULT 0,
    mystic_arcanum_level_8 INT NOT NULL DEFAULT 0,
    mystic_arcanum_level_9 INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);