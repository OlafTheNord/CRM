CREATE OR REPLACE FUNCTION crm.contact_add(_name          VARCHAR(255),
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

    _error = CONCAT('name: ', _name,
                    ', surname: ', _surname,
                    ', email: ', _email,
                    ', primary_phone: ', _primary_phone);

    IF _email IS NULL OR _primary_phone IS NULL
    THEN
        _res = JSONB_BUILD_OBJECT('error_key', 'error.validate.contact.invalid_data',
                                  'error', _error,
                                  'message', 'Phone number or email is invalid.');
        RETURN _res;
    END IF;

    IF
        EXISTS(SELECT 1
               FROM crm.contacts
               WHERE email = _email
                  OR primary_phone = _primary_phone)
    THEN
        _res = JSONB_BUILD_OBJECT('error_key', 'error.validate.contact.already_exist',
                                  'error', _error,
                                  'message', 'Phone number or email already exists.');
        RETURN _res;
    END IF;

    INSERT INTO crm.contacts(name, surname, email, primary_phone, ch_dt)
    SELECT _name,
           _surname,
           _email,
           _primary_phone,
           _dt;

    SELECT JSON_AGG(JSONB_BUILD_OBJECT('id', c.id,
                                       'name', c.name))
    FROM crm.contacts c
    WHERE c.email = _email
      AND c.primary_phone = _primary_phone
    INTO _res;

    RETURN _res;
END;
$$;