CREATE TABLE spell_slot_level (
    id INT PRIMARY KEY IDENTITY(1,1),
    level INT NOT NULL UNIQUE CHECK (level BETWEEN 1 AND 9),
    name NVARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Initialize the spell slot levels
INSERT INTO spell_slot_level (level, name) VALUES
(1, '1st Level'),
(2, '2nd Level'),
(3, '3rd Level'),
(4, '4th Level'),
(5, '5th Level'),
(6, '6th Level'),
(7, '7th Level'),
(8, '8th Level'),
(9, '9th Level');