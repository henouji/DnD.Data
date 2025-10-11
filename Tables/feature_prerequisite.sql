CREATE TABLE feature_prerequisite (
    id INT PRIMARY KEY IDENTITY(1,1),
    feature_id INT NOT NULL,
    reference_type NVARCHAR(50) NOT NULL,
    reference_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_feature_id (feature_id)
);