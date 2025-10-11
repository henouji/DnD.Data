CREATE TABLE class (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    hit_die INT NOT NULL,
    proficiency_options INT NULL,
    is_subclass BIT DEFAULT 0,
    parent_class_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
)