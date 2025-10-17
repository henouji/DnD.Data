CREATE TABLE rule_section
(
    id BIGINT PRIMARY KEY IDENTITY(9999000,1),
    name VARCHAR(255) NOT NULL,
    description VARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE (),
    updated_at DATETIME DEFAULT GETDATE (),
    deleted BIT DEFAULT 0
);