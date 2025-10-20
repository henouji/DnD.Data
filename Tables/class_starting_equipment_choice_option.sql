-- Simple table for individual options within choice groups
CREATE TABLE class_starting_equipment_choice_option (
    id INT PRIMARY KEY IDENTITY(1,1),
    choice_group_id INT NOT NULL,
    option_letter CHAR(1) NOT NULL, -- 'a', 'b', 'c', etc.
    display_text NVARCHAR(200) NOT NULL, -- "1 greataxe", "any martial melee weapon"
    
    -- Either specific equipment OR category choice (mutually exclusive)
    equipment_id INT NULL,              -- For specific items
    equipment_quantity INT NULL,        -- How many of the specific item
    equipment_category_id INT NULL,     -- For category choices
    
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
);