-- Fixed starting equipment for classes (not choices)
CREATE TABLE class_starting_equipment (
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    equipment_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id),
    INDEX idx_equipment_id (equipment_id)
);