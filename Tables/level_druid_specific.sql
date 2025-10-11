CREATE TABLE level_druid_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    wild_shape_max_cr DECIMAL(3,1) NOT NULL DEFAULT 0.25,
    wild_shape_swim BIT DEFAULT 0,
    wild_shape_fly BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);