CREATE TABLE language (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    type NVARCHAR(100) NULL,
    script NVARCHAR(100) NULL,
    speakers NVARCHAR(255) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
);