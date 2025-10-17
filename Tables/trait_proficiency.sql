CREATE TABLE trait_proficiency
(
    id INT PRIMARY KEY IDENTITY(1,1),
    trait_id INT NOT NULL,
    proficiency_id BIGINT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_trait_id (trait_id),
    INDEX idx_proficiency_id (proficiency_id)
);