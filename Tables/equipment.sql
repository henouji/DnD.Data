CREATE TABLE
    equipment (
        id INT PRIMARY KEY IDENTITY (80000, 8),
        name NVARCHAR (256) NOT NULL,
        description NVARCHAR (MAX) NULL,
        special NVARCHAR (MAX) NULL,
        -- FK References to equipment_category table
        equipment_category_id INT NULL,
        gear_category_id INT NULL,
        -- Direct string enum values (NOT foreign keys)
        weapon_category NVARCHAR (64) NULL, -- 'Simple', 'Martial'
        armor_category NVARCHAR (64) NULL, -- 'Light', 'Medium', 'Heavy', 'Shield'
        tool_category NVARCHAR (128) NULL, -- 'Artisan\'s Tools', 'Musical Instrument', etc.
        vehicle_category NVARCHAR (128) NULL, -- 'Mounts and Other Animals', etc.
        -- Armor specific fields
        armor_class_id INT NULL,
        str_minimum INT NULL,
        stealth_disadvantage BIT NULL,
        -- Range values (weapons)
        range_normal INT NULL, -- Normal range in feet
        range_long INT NULL, -- Long range in feet
        throw_range_normal INT NULL, -- Throwing normal range
        throw_range_long INT NULL, -- Throwing long range
        -- Cost and physical properties
        cost_quantity INT NULL,
        cost_unit NVARCHAR (10) NULL,
        weight DECIMAL(10, 2) NULL,
        quantity INT NULL DEFAULT 1,
        -- Vehicle specific
        speed_quantity DECIMAL(5, 1) NULL,
        speed_unit NVARCHAR (20) NULL,
        capacity NVARCHAR (50) NULL,
        -- Computed columns (derived from other fields)
        weapon_range AS (
            CASE
                WHEN range_normal = 5
                AND (
                    range_long IS NULL
                    OR range_long <= 5
                ) THEN 'Melee'
                WHEN range_normal > 5
                OR range_long > 5 THEN 'Ranged'
                ELSE NULL
            END
        ) PERSISTED,
        category_range AS (
            CASE
                WHEN weapon_category IS NOT NULL THEN weapon_category + ' ' + CASE
                    WHEN range_normal = 5
                    AND (
                        range_long IS NULL
                        OR range_long <= 5
                    ) THEN 'Melee'
                    WHEN range_normal > 5
                    OR range_long > 5 THEN 'Ranged'
                    ELSE 'Unknown'
                END
                ELSE NULL
            END
        ) PERSISTED,
        -- Audit columns
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NULL,
        -- Indexes
        INDEX idx_equipment_category_id (equipment_category_id),
        INDEX idx_gear_category_id (gear_category_id),
        INDEX idx_weapon_category (weapon_category),
        INDEX idx_name (name)
    );

CREATE TABLE
    equipment_weapon_property (
        id INT PRIMARY KEY IDENTITY (81000, 1),
        equipment_id INT NOT NULL,
        weapon_property_id INT NOT NULL
    );

CREATE TABLE
    equipment_damage (
        id INT PRIMARY KEY IDENTITY (83000, 1),
        equipment_id INT NOT NULL,
        damage_id INT NOT NULL
    );