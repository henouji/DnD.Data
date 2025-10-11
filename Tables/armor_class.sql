CREATE TABLE armor_class (
    id INT PRIMARY KEY IDENTITY(82000,1),
    type VARCHAR(30) NOT NULL,      -- Type of Modifier  [DEX, Natural, armor]
    value INT NOT NULL,         -- BASE AC Value
    dex_bonus BIT NULL, 
    max_bonus INT NULL,
    created_at DATETIME DEFAULT GETDATE (),
    updated_at DATETIME DEFAULT GETDATE (),
    deleted BIT NOT NULL DEFAULT 0
);
