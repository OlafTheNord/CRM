CREATE OR REPLACE FUNCTION crm.contact_upd(_id            BIGINT,
                                           _name          VARCHAR(255),
                                           _surname       VARCHAR(255),
                                           _email         VARCHAR(255),
                                           _primary_phone VARCHAR(255))
    RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _dt    TIMESTAMP WITHOUT TIME ZONE;
    _res   JSONB;
    _error VARCHAR(500);
BEGIN
    SET TIME ZONE 'Europe/Belgrade';
    _dt = NOW();

    _error = CONCAT('id: ', _id,
                    ', name: ', _name,
                    ', surname: ', _surname,
                    ', email: ', _email,
                    ', primary_phone: ', _primary_phone);

    IF NOT EXISTS(SELECT 1 FROM crm.contacts)
    THEN
        _res = JSONB_BUILD_OBJECT('error_key', 'error.validate.contact.not_exist',
                                  'error', _error,
                                  'message', 'Contact does not exist.');
        RETURN _res;
    END IF;

    IF _email IS NULL OR _email = ''
        OR _primary_phone IS NULL OR _primary_phone = ''
        OR _name IS NULL OR _name = ''
    THEN
        _res = JSONB_BUILD_OBJECT('error_key', 'error.validate.contact.invalid_data',
                                  'error', _error,
                                  'message', 'Phone number or email is invalid.');
        RETURN _res;
    END IF;


    WITH contact_upd AS (
        UPDATE crm.contacts c
            SET name = _name,
                surname = _surname,
                email = _email,
                primary_phone = _primary_phone,
                ch_dt = _dt
            WHERE c.id = _id
            RETURNING c.name, c.surname, c.email, c.primary_phone)

    SELECT JSON_AGG(JSONB_BUILD_OBJECT('name', c.name,
                                       'surname', c.surname,
                                       'email', c.email,
                                       'primary_phone', c.primary_phone))
    FROM contact_upd c
    INTO _res;

    RETURN _res;
END;
$$;