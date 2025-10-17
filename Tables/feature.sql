CREATE TABLE feature (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    level INT NULL,
    description NVARCHAR(MAX),
    class_id INT NULL,
    subclass_id INT NULL,
    parent_feature_id INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL
);