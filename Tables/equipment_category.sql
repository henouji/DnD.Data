CREATE TABLE equipment_category(
    id INT PRIMARY KEY IDENTITY(1,1),
    equipment_category_type_id INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
);

CREATE TABLE equipment_category_type(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
)
