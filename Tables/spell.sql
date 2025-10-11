CREATE TABLE spell (
    id BIGINT PRIMARY KEY IDENTITY(77770000, 1),
    name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX) NULL,
    higher_level VARCHAR(MAX) NULL,
    damage VARCHAR(MAX) NULL, -- Flat json string

    -- Metadata
    range VARCHAR(50) NULL,
    attack_type VARCHAR(50) NULL,
    components VARCHAR(50) NULL, -- Flat json string
    material VARCHAR(MAX) NULL,
    ritual BIT NULL,
    heal_at_slot_level VARCHAR(MAX) NULL, -- Flat json string
    duration VARCHAR(50) NULL,
    concentration BIT NULL,
    casting_time VARCHAR(50) NULL,
    level INTEGER NULL,
    dc_ability_score_id INT NULL,
    dc_success VARCHAR(50) NULL,
    dc_description VARCHAR(MAX) NULL,
    area_of_effect VARCHAR(50) NULL, 
    area_of_effect_size INT NULL,
    magic_school_id INT NULL
);

CREATE TABLE spell_class (
    id BIGINT PRIMARY KEY IDENTITY(78770000, 1),
    spell_id BIGINT NOT NULL,
    class_id INT NOT NULL, 
    is_subclass BIT NOT NULL DEFAULT 0
);