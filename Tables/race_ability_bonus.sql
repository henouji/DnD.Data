CREATE TABLE race_ability_bonus
(
    id INT PRIMARY KEY IDENTITY(1,1),
    race_id INT NOT NULL,
    ability_score_id INT NOT NULL,
    bonus INT NOT NULL,
    is_optional BIT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_race_id (race_id),
    INDEX idx_ability_score_id (ability_score_id)
);