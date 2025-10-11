CREATE TABLE class_proficiency (
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    proficiency_id INT NULL, 
    is_optional BIT NOT NULL DEFAULT 0, 
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id),
    INDEX idx_proficiency_type (proficiency_type),
    INDEX idx_proficiency_id (proficiency_id)
);