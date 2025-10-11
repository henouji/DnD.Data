-- Main table linking features to their option sets
CREATE TABLE feature_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    feature_id INT NOT NULL,
    option_set_name NVARCHAR(100) NOT NULL,  -- e.g. 'subfeature_options', 'enemy_type_options'
    description NVARCHAR(MAX) NULL,
    choose INT NOT NULL DEFAULT 1,
    option_type NVARCHAR(50) NOT NULL,       -- 'feature', 'string', etc.
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_feature_id (feature_id)
);

-- Table for all available options
CREATE TABLE feature_specific_options (
    id INT PRIMARY KEY IDENTITY(1,1),
    feature_specific_id INT NOT NULL,
    option_type NVARCHAR(50) NOT NULL,
    option_value NVARCHAR(255) NULL,       
    reference_feature_id INT NULL,         
    reference_id NVARCHAR(255) NULL,    
    reference_name NVARCHAR(255) NULL,     
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    deleted BIT NULL,
    INDEX idx_feature_specific_id (feature_specific_id)
);