CREATE TABLE ideal
(
    id INT PRIMARY KEY IDENTITY(1,1),
    description NVARCHAR(1000) NULL,
    background_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
);
GO;

CREATE TABLE ideal_alignment
(
    id INT PRIMARY KEY IDENTITY(1,1),
    ideal_id INT NOT NULL,
    alignment_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_ideal_id (ideal_id),
    INDEX idx_alignment_id (alignment_id)
);
GO;