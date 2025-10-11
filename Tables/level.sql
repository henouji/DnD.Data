CREATE TABLE level (
    id INT PRIMARY KEY IDENTITY(70000,7),
    level INT NOT NULL CHECK (level BETWEEN 1 AND 20),
    class_id INT NOT NULL,
    ability_score_bonuses INT NULL DEFAULT 0,
    proficiency_bonus INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (class_id) REFERENCES class(id)
);

CREATE TABLE level_features (
    id INT PRIMARY KEY IDENTITY(80000,8),
    level_id INT NOT NULL,
    feature_id INT NOT NULL,
    FOREIGN KEY (level_id) REFERENCES level(id),
    FOREIGN KEY (feature_id) REFERENCES feature(id),
    UNIQUE(level_id, feature_id)
); 