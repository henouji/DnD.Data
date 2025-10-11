CREATE TABLE level_bard_specific (
    id INT PRIMARY KEY IDENTITY(1,1),
    level_id INT NOT NULL,
    bardic_inspiration_die INT NOT NULL,
    song_of_rest_die INT NOT NULL DEFAULT 0,
    magical_secrets_max_5 INT NOT NULL DEFAULT 0,
    magical_secrets_max_7 INT NOT NULL DEFAULT 0,
    magical_secrets_max_9 INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (level_id) REFERENCES level(id),
    UNIQUE(level_id)
);