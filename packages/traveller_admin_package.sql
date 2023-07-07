--------------TRAVELER ADMIN PACKAGE--------------
CREATE OR REPLACE PACKAGE traveler_admin_package AS
    TYPE object_rec IS RECORD(
        name USER_DEPENDENCIES.name%TYPE,
        type USER_DEPENDENCIES.type%TYPE,
        referenced_name USER_DEPENDENCIES.referenced_name%TYPE,
        referenced_type USER_DEPENDENCIES.referenced_type%TYPE
    );
    TYPE object_array IS TABLE OF object_rec INDEX BY PLS_INTEGER;
    --P1
    PROCEDURE display_disabled_triggers;
    --P2
    FUNCTION all_dependent_objects(object_name VARCHAR2) RETURN object_array;
    --P3
    PROCEDURE print_dependent_objects(objects IN object_array);
END;

--------------TRAVELER ADMIN PACKAGE BODY--------------

CREATE OR REPLACE PACKAGE BODY traveler_admin_package AS
    --P1
    PROCEDURE display_disabled_triggers IS
    CURSOR triggers IS SELECT trigger_name FROM user_triggers WHERE status = 'DISABLED';
    BEGIN
        FOR trigger IN triggers LOOP
            DBMS_OUTPUT.PUT_LINE( 'Trigger ' || trigger.trigger_name ||' is disabled' );
        END LOOP;
    END;
    --P2
    FUNCTION all_dependent_objects(object_name VARCHAR2)
    RETURN object_array IS
        CURSOR object_cur IS SELECT name, type, referenced_name, referenced_type
                        FROM USER_DEPENDENCIES WHERE referenced_name = UPPER( object_name );
        v_objects object_array;
        i PLS_INTEGER := 1;
    BEGIN
        FOR v_object IN object_cur LOOP
            v_objects(i) := v_object;
            i := i + 1;
        END LOOP;
        IF (v_objects.COUNT < 1) THEN
            RAISE NO_DATA_FOUND;
        END IF;
        RETURN v_objects;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No data found');
    END;
    --P3
    PROCEDURE print_dependent_objects(objects IN object_array) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('NAME          TYPE        REFERENCED_NAME         REFERENCED_TYPE');
        FOR i IN objects.FIRST .. objects.LAST LOOP
            DBMS_OUTPUT.PUT_LINE( RPAD(objects(i).name, 31) || RPAD(objects(i).type, 31) ||
                                  RPAD(objects(i).referenced_name, 31) || RPAD(objects(i).referenced_type,31) );
        END LOOP;
    END;
END;
