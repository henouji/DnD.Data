-- Simple table for choice groups
CREATE TABLE class_starting_equipment_choice_group (
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    description NVARCHAR(500) NOT NULL, -- "(a) a greataxe or (b) any martial melee weapon"
    choose_count INT NOT NULL DEFAULT 1, -- How many options player can choose
    display_order INT NOT NULL DEFAULT 1, -- Order for display (1, 2, 3...)
    
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
);