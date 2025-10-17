CREATE TABLE spell_slot_level
(
    id INT PRIMARY KEY IDENTITY(1,1),
    level INT NOT NULL,
    name NVARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT DEFAULT 0
);
