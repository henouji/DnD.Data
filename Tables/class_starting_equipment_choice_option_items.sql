-- For options that contain multiple items (like "light crossbow and 20 bolts")
CREATE TABLE class_starting_equipment_choice_option_items (
    id INT PRIMARY KEY IDENTITY(1,1),
    choice_option_id INT NOT NULL,
    equipment_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    -- Performance indexes
    INDEX IX_option_items_option (choice_option_id),
    INDEX IX_option_items_equipment (equipment_id)
);