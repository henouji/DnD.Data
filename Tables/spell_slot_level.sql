CREATE TABLE spell_slot_level
(
    id INT PRIMARY KEY IDENTITY(1,1),
    level INT NOT NULL UNIQUE CHECK (level BETWEEN 1 AND 9),
    name NVARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT DEFAULT 0
);
