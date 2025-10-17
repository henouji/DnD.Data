CREATE TABLE [rule]
(
    id BIGINT PRIMARY KEY IDENTITY (8888000, 1),
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1024),
    created_at DATETIME DEFAULT GETDATE (),
    updated_at DATETIME DEFAULT GETDATE (),
    deleted BIT DEFAULT 0
);
GO;

CREATE TABLE rule_subsection
(
    id BIGINT PRIMARY KEY IDENTITY (8889000, 1),
    rule_id BIGINT NOT NULL,
    rule_section_id BIGINT NOT NULL,
    created_at DATETIME DEFAULT GETDATE (),
    updated_at DATETIME DEFAULT GETDATE (),
    deleted BIT DEFAULT 0
);
GO;