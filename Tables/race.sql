CREATE TABLE race (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    speed INT NOT NULL,
    age_description NVARCHAR(MAX) NULL,
    size_id INT NOT NULL,
    size_description NVARCHAR(MAX) NULL,
    alignment_id INT NULL,
    alignment_description NVARCHAR(MAX) NULL,
    language_options INT NULL,
    language_description NVARCHAR(MAX) NULL,
    ability_bonus_options INT NULL,
    is_subrace BIT NULL,
    race_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
)