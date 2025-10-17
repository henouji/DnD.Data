CREATE TABLE class_starting_equipment_option_group
(
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    description NVARCHAR(500) NOT NULL,
    -- "(a) a light crossbow and 20 bolts or (b) any simple weapon"
    choose_count INT NOT NULL DEFAULT 1,
    option_type NVARCHAR(50) NOT NULL,
    -- 'equipment'
    option_set_type NVARCHAR(50) NOT NULL,
    -- 'options_array'
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id)
);

GO;
CREATE TABLE class_starting_equipment_option
(
    id INT PRIMARY KEY IDENTITY(1,1),
    option_group_id INT NOT NULL,
    option_type NVARCHAR(50) NOT NULL,
    -- 'counted_reference', 'choice', 'multiple'
    equipment_id INT NULL,
    -- For direct equipment references
    equipment_category_id INT NULL,
    -- For category references like "simple-weapons"
    count_quantity INT NULL,
    -- For counted_reference (20 bolts)
    choice_description NVARCHAR(500) NULL,
    -- "any simple weapon"
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_option_group_id (option_group_id),
    INDEX idx_equipment_id (equipment_id),
    INDEX idx_equipment_category_id (equipment_category_id)
);


GO;
CREATE TABLE class_starting_equipment_option_item
(
    id INT PRIMARY KEY IDENTITY(1,1),
    option_id INT NOT NULL,
    -- References class_starting_equipment_option
    equipment_id INT NULL,
    equipment_category_id INT NULL,
    count_quantity INT NOT NULL DEFAULT 1,
    item_order INT NOT NULL DEFAULT 1,
    -- For multiple items in one option
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_option_id (option_id),
    INDEX idx_equipment_id (equipment_id)
);

GO;