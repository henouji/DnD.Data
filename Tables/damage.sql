CREATE TABLE
    damage (
        id INT PRIMARY KEY IDENTITY (83000, 1),
        damage_description VARCHAR(250) NULL,
        damage_dice VARCHAR(20) NOT NULL,
        damage_type_id INT NOT NULL
    );