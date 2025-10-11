CREATE TABLE class_starting_equipment_choice_option (
    id INT PRIMARY KEY IDENTITY(1,1),
    choice_group_id INT NOT NULL,
    option_type NVARCHAR(50) NOT NULL, -- 'counted_reference', 'choice', 'multiple'
    
    -- For direct equipment references (counted_reference)
    equipment_id INT NULL,
    count_quantity INT NULL DEFAULT 1,
    
    -- For equipment category choices (choice)
    equipment_category_id INT NULL,
    choice_description NVARCHAR(500) NULL, -- "any martial melee weapon"
    
    -- For nested choices within choices
    nested_choose_count INT NULL,
    nested_choice_type NVARCHAR(50) NULL,
    nested_option_set_type NVARCHAR(50) NULL,
    
    -- Display and ordering
    option_order INT NOT NULL DEFAULT 1,
    option_letter NVARCHAR(5) NULL, -- 'a', 'b', 'c' for display
    
    -- Audit columns
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    
    INDEX idx_choice_group_id (choice_group_id),
    INDEX idx_equipment_id (equipment_id),
    INDEX idx_equipment_category_id (equipment_category_id),
    INDEX idx_option_order (option_order)
);