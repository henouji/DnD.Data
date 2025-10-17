CREATE TABLE feats
(
    id INT PRIMARY KEY IDENTITY(90000,1),
    name VARCHAR(50) NOT NULL,
    description VARCHAR(MAX) NULL
);
GO;
CREATE TABLE feats_prerequisite
(
    id INT PRIMARY KEY IDENTITY(99000, 1),
    ability_score_id INT NOT NULL,
    minimum_score INT NOT NULL
);
GO;