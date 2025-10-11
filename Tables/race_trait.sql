CREATE TABLE race_trait (
    id INT PRIMARY KEY IDENTITY(1,1),
    race_id INT NOT NULL,
    trait_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_race_id (race_id),
    INDEX idx_trait_id (trait_id)
);
