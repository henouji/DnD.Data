CREATE TABLE race_language
(
    id INT PRIMARY KEY IDENTITY(1,1),
    race_id INT NOT NULL,
    language_id INT NOT NULL,
    is_optional BIT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_race_id (race_id),
    INDEX idx_language_id (language_id)
);
