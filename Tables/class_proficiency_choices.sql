CREATE TABLE class_proficiency_choice_group
(
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    description NVARCHAR(500) NOT NULL,
    -- "Choose two from Animal Handling, Athletics..."
    choose_count INT NOT NULL DEFAULT 1,
    choice_type NVARCHAR(50) NOT NULL,
    -- 'proficiencies'
    option_set_type NVARCHAR(50) NOT NULL,
    -- 'options_array'
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id)
);
GO;

CREATE TABLE class_proficiency_choice_option
(
    id INT PRIMARY KEY IDENTITY(1,1),
    choice_group_id INT NOT NULL,
    proficiency_id BIGINT NOT NULL,
    option_type NVARCHAR(50) NOT NULL DEFAULT 'reference',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_choice_group_id (choice_group_id),
    INDEX idx_proficiency_id (proficiency_id)
);
GO;
