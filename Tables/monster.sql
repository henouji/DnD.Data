CREATE TABLE
    monster (
        id BIGINT PRIMARY KEY IDENTITY (3000000, 1),
        name NVARCHAR (100) NOT NULL,
        description NVARCHAR (MAX) NULL,
        alignment_id INT NOT NULL,
        size_id BIGINT NOT NULL,
        monster_type_id BIGINT NOT NULL, -- References Monster Type
        sub_monster_type_id BIGINT NULL, -- References Monster Type if is_subtype = 1
        -- Speed fields
        speed_walk INT NULL,
        speed_burrow INT NULL,
        speed_climb INT NULL,
        speed_fly INT NULL,
        speed_swim INT NULL,
        hit_points INT NULL,
        hit_dice NVARCHAR (20) NULL,
        hit_points_roll NVARCHAR (50) NULL,
        -- Attributes
        strength INT NULL,
        dexterity INT NULL,
        constitution INT NULL,
        intelligence INT NULL,
        wisdom INT NULL,
        charisma INT NULL,
        -- Senses
        darkvision VARCHAR(100) NULL,
        passive_perception INT NULL,
        blindsight NVARCHAR(50),
        tremorsense NVARCHAR(50),
        truesight NVARCHAR(50),
        -- Other fields
        languages VARCHAR(250) NULL,
        challenge_rating DECIMAL(4, 2) NULL,
        experience_points INT NULL,
        proficiency_bonus INT NULL,
        -- actions
        image_url NVARCHAR (250) NULL,
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NULL DEFAULT 0
    );

CREATE TABLE
    monster_type (
        id BIGINT PRIMARY KEY IDENTITY (3100000, 1),
        name NVARCHAR (100) NOT NULL,
        is_subtype BIT NOT NULL DEFAULT 0,
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NULL
    );

CREATE TABLE
    monster_armor_class (
        id BIGINT PRIMARY KEY IDENTITY (3200000, 1),
        monster_id BIGINT NOT NULL,
        armor_class_id BIGINT NOT NULL,
        equipment_id BIGINT NULL,
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NOT NULL DEFAULT 0
    );

CREATE TABLE
    monster_proficiency (
        id BIGINT PRIMARY KEY IDENTITY (3300000, 1),
        monster_id BIGINT NOT NULL,
        proficiency_id BIGINT NOT NULL,
        value INT NOT NULL,
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NOT NULL DEFAULT 0
    );

CREATE TABLE
    monster_damage_data (
        id BIGINT PRIMARY KEY IDENTITY (3400000, 1),
        monster_id BIGINT NOT NULL,
        damage_vulnerabilities NVARCHAR (MAX) NULL, -- Comma separated list
        damage_resistances NVARCHAR (MAX) NULL, -- Comma separated list
        damage_immunities NVARCHAR (MAX) NULL, -- Comma separated list
        condition_immunities NVARCHAR (MAX) NULL, -- Comma separated list
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NOT NULL DEFAULT 0
    );

CREATE TABLE
    monster_actions (
        id BIGINT PRIMARY KEY IDENTITY (3500000, 1),
        monster_id BIGINT NOT NULL,
        action_type NVARCHAR (20) NOT NULL CHECK (
            action_type IN (
                'action',
                'legendary_action',
                'reaction',
                'special_ability'
            )
        ),
        action_data NVARCHAR (MAX) NOT NULL, -- JSON data
        created_at DATETIME DEFAULT GETDATE (),
        updated_at DATETIME DEFAULT GETDATE (),
        deleted BIT NOT NULL DEFAULT 0
);