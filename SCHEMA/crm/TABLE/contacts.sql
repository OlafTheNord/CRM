CREATE TABLE crm.contacts
(
    id            BIGINT GENERATED ALWAYS AS IDENTITY,
    name          VARCHAR(255)                NOT NULL,
    surname       VARCHAR(255)                NULL,
    email         VARCHAR(255)                NOT NULL,
    primary_phone VARCHAR(255)                NOT NULL,
    ch_dt         TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE INDEX ix_email_phone ON crm.contacts (email, primary_phone);