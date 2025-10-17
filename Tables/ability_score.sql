CREATE TABLE ability_score (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    full_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT DEFAULT 0
);