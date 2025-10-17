CREATE TABLE multiclass
(
    id INT PRIMARY KEY IDENTITY(1,1),
    class_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_class_id (class_id)
);

GO;

CREATE TABLE multiclass_prerequisite
(
    id INT PRIMARY KEY IDENTITY(1,1),
    multiclass_id INT NOT NULL,
    ability_score_id INT NOT NULL,
    minimum_score INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_multiclass_id (multiclass_id),
    INDEX idx_ability_score_id (ability_score_id)
);

GO;

CREATE TABLE multiclass_proficiency
(
    id INT PRIMARY KEY IDENTITY(1,1),
    multiclass_id INT NOT NULL,
    proficiency_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_multiclass_id (multiclass_id),
    INDEX idx_proficiency_id (proficiency_id)
);

GO;

CREATE TABLE multiclass_proficiency_choice_group
(
    id INT PRIMARY KEY IDENTITY(1,1),
    multiclass_id INT NOT NULL,
    choose_count INT NOT NULL DEFAULT 1,
    choice_type NVARCHAR(50) NOT NULL,
    -- 'proficiencies'
    option_set_type NVARCHAR(50) NOT NULL,
    -- 'options_array'
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_multiclass_id (multiclass_id)
);

GO;

CREATE TABLE multiclass_proficiency_choice_option
(
    id INT PRIMARY KEY IDENTITY(1,1),
    choice_group_id INT NOT NULL,
    proficiency_id INT NOT NULL,
    option_type NVARCHAR(50) NOT NULL DEFAULT 'reference',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_choice_group_id (choice_group_id),
    INDEX idx_proficiency_id (proficiency_id)
);

GO;