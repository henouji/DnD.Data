CREATE TABLE background_feature (
    id INT PRIMARY KEY IDENTITY(1,1),
    background_id INT NOT NULL,
    feature_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_background_id (background_id),
    INDEX idx_feature_id (feature_id)
)