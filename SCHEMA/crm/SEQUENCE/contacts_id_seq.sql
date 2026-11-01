CREATE SEQUENCE contacts_id_seq;

ALTER SEQUENCE contacts_id_seq OWNER TO postgres;

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;