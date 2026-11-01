CREATE TABLE crm.contacts
(
    id            BIGINT GENERATED ALWAYS AS IDENTITY,
    name          VARCHAR(255) NOT NULL,
    surname       VARCHAR(255) NULL,
    email         VARCHAR(255) NOT NULL,
    primary_phone VARCHAR(255) NULL
);