CREATE TABLE class_starting_equipment_choice_group (
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    description NVARCHAR(500) NOT NULL, -- "(a) a greataxe or (b) any martial melee weapon"
    choose_count INT NOT NULL DEFAULT 1, -- How many options player can choose from this group
    choice_type NVARCHAR(50) NOT NULL DEFAULT 'equipment', -- Always 'equipment' for starting equipment
    option_set_type NVARCHAR(50) NOT NULL DEFAULT 'options_array', -- From JSON: "from.option_set_type"
    group_order INT NOT NULL DEFAULT 1, -- Order of choice groups for display
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id),
    INDEX idx_group_order (group_order)
);