CREATE TABLE class_starting_equipment_choice_option_items (
    id INT PRIMARY KEY IDENTITY(1,1),
    choice_option_id INT NOT NULL, -- References class_starting_equipment_choice_option
    equipment_id INT NOT NULL,
    count_quantity INT NOT NULL DEFAULT 1,
    item_order INT NOT NULL DEFAULT 1, -- Order within the multiple option
    item_option_type NVARCHAR(50) NOT NULL DEFAULT 'counted_reference', -- Usually 'counted_reference'
    
    -- Audit columns
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    
    INDEX idx_choice_option_id (choice_option_id),
    INDEX idx_equipment_id (equipment_id),
    INDEX idx_item_order (item_order)
);