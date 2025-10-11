CREATE TABLE background_proficiency (
    id INT PRIMARY KEY IDENTITY(1,1),
    background_id INT NOT NULL,
    proficiency_id INT NOT NULL,
    is_tool_proficiency BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_background_id (background_id),
    INDEX idx_proficiency_id (proficiency_id)
);