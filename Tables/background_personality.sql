CREATE TABLE background_personality (
    id INT PRIMARY KEY IDENTITY(1,1),
    description NVARCHAR(MAX) NULL,
    background_id INT NULL,
    type_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
);

GO;

CREATE TABLE background_personality_alignment (
    id INT PRIMARY KEY IDENTITY(1,1),
    background_personality_id INT NOT NULL,
    alignment_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_background_personality_id (background_personality_id),
    INDEX idx_alignment_id (alignment_id)
);

GO;

CREATE TABLE background_personality_type (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL, -- ideals, bond, flaw, trait
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
);

GO;