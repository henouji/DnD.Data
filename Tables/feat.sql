CREATE TABLE feat
(
    id INT PRIMARY KEY IDENTITY(90000,1),
    name VARCHAR(50) NOT NULL,
    description VARCHAR(MAX) NULL,
    deleted BIT NULL DEFAULT 0
);
GO;

CREATE TABLE feat_prerequisite
(
    id INT PRIMARY KEY IDENTITY(99000, 1),
    feat_id INT NOT NULL,
    ability_score_id INT NOT NULL,
    minimum_score INT NOT NULL,
    deleted BIT NULL DEFAULT 0
);
GO;