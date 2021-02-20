DO
$$DECLARE
    v_rec varchar;
    v_schema varchar[] := array[ 'osm' ];
BEGIN
    FOREACH v_rec IN ARRAY v_schema
        LOOP
            IF NOT EXISTS ( SELECT 1 FROM information_schema.schemata WHERE schema_name = v_rec ) THEN
                RAISE INFO 'Creating schema %', v_rec;
                -- E.g. CREATE SCHEMA foo;
                EXECUTE 'CREATE SCHEMA ' || v_rec || ';';
            ELSE
                RAISE INFO 'Schema % already exists', v_rec;
            END IF;
        END LOOP;
END$$

