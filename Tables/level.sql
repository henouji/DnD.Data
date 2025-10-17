CREATE TABLE level
(
    id INT PRIMARY KEY IDENTITY (70000, 7),
    level INT NOT NULL CHECK (level BETWEEN 1 AND 20),
    class_id INT NOT NULL,
    ability_score_bonuses INT NULL DEFAULT 0,
    proficiency_bonus INT NULL,
    created_at DATETIME DEFAULT GETDATE (),
    updated_at DATETIME DEFAULT GETDATE (),
    deleted BIT NULL,
);
GO;

CREATE TABLE level_features
(
    id INT PRIMARY KEY IDENTITY (80000, 8),
    level_id INT NOT NULL,
    feature_id INT NOT NULL
);
GO;

CREATE TABLE level_class_data
(
    id INT PRIMARY KEY IDENTITY (90000, 9),
    level_id INT NOT NULL,
    attribute_name NVARCHAR (100) NOT NULL,
    attribute_value NVARCHAR (100) NOT NULL,
    value_type NVARCHAR (50) NOT NULL DEFAULT 'INT',
    created_at DATETIME DEFAULT GETDATE (),
    updated_at DATETIME DEFAULT GETDATE (),
    deleted BIT NULL
);
GO;