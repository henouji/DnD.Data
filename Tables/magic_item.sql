CREATE TABLE magic_item (
    id INT PRIMARY KEY IDENTITY (200000, 10),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    
    rarity_id INT NULL,
    equipment_category_id INT NULL,
    variant BIT NULL DEFAULT 0,

    image_url NVARCHAR(MAX) NULL,

    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL DEFAULT 0
);

CREATE TABLE magic_items_variant (
    id INT PRIMARY KEY IDENTITY (210000, 2),
    base_magic_item_id INT NOT NULL,
    variant_magic_item_id INT NOT NULL
);

