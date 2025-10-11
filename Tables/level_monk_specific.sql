CREATE TABLE level_monk_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    martial_arts_dice_count INT NOT NULL DEFAULT 1,
    martial_arts_dice_value INT NOT NULL DEFAULT 4,
    ki_points INT NOT NULL DEFAULT 0,
    unarmored_movement INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);