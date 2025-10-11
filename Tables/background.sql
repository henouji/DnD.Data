CREATE TABLE background (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    language_options INT NULL,
    starting_equipment_options INT NULL,
    trait_options INT NULL,
    ideal_options INT NULL,
    bond_options INT NULL,
    flaw_options INT NULL
)