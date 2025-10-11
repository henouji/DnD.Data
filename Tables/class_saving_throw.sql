CREATE TABLE class_saving_throw(
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    ability_score_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id),
    INDEX idx_ability_id (ability_score_id)
)