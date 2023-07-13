
--------------TRAVELER ASSISTANCE PACKAGE--------------

CREATE OR REPLACE PACKAGE traveler_assistance_package AS
    TYPE country_type IS RECORD(
        country_name COUNTRIES.country_name%TYPE,
        region REGIONS.region_name%TYPE,
        currency CURRENCIES.currency_name%TYPE
    );
    TYPE countries_type IS TABLE OF country_type INDEX BY PLS_INTEGER;
    TYPE country_language_type IS RECORD(
        country_name COUNTRIES.country_name%TYPE,
        language_name LANGUAGES.language_name%TYPE,
        official_language SPOKEN_LANGUAGES.official%TYPE
    );
    TYPE country_languages_type IS TABLE OF country_language_type INDEX BY PLS_INTEGER;
    --P1
    PROCEDURE country_demographics(v_country_name VARCHAR2);
    --P2
    PROCEDURE find_region_and_currency(v_country_name IN VARCHAR2, country OUT country_type);
    -- --P3
    PROCEDURE countries_in_same_region(v_region_name IN VARCHAR2, countries OUT countries_type);
    -- --P4
    PROCEDURE print_region_array(countries countries_type);
    -- --P5
    PROCEDURE country_languages(v_country_name IN VARCHAR2, country_lang OUT country_languages_type );
    -- --P6
    PROCEDURE print_language_array(country_langs country_languages_type);
END;

--------------INIT PROCEDURES--------------     

CREATE OR REPLACE PACKAGE BODY traveler_assistance_package AS
    --P1
    PROCEDURE country_demographics(v_country_name VARCHAR2) IS
    BEGIN
        FOR country IN (SELECT * FROM COUNTRIES WHERE LOWER(COUNTRY_NAME) = LOWER(v_country_name)) LOOP
            DBMS_OUTPUT.PUT_LINE(country.COUNTRY_NAME || ',  ' || country.LOCATION || ', ' || country.POPULATION
                                 || ', ' || country.AIRPORTS || ', ' || country.CLIMATE);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No data found for country ' || v_country_name);
    END;
    --P2
    PROCEDURE find_region_and_currency(v_country_name IN VARCHAR2, country OUT country_type) IS
    BEGIN
        SELECT c.country_name, r.region_name, cu.currency_name INTO country
        FROM COUNTRIES c, REGIONS r, CURRENCIES cu
        WHERE LOWER(c.COUNTRY_NAME) = LOWER(v_country_name) AND
                c.REGION_ID = r.REGION_ID AND
                c.CURRENCY_CODE = cu.CURRENCY_CODE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No data found for country ' || v_country_name);
    END;
    --P3
    PROCEDURE countries_in_same_region(v_region_name IN VARCHAR2, countries OUT countries_type) IS
        CURSOR countries_region IS SELECT c.country_name, r.region_name, cu.currency_name
            FROM countries c, regions r, currencies cu
            WHERE c.region_id = r.region_id 
            AND c.currency_code = cu.currency_code
            AND LOWER(r.region_name) = LOWER(v_region_name);
        i PLS_INTEGER := 1;
    BEGIN
        FOR country IN countries_region LOOP
            countries(i) := country;
            i := i + 1;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No data found for country ' || v_region_name);
    END;
    --P4
    PROCEDURE print_region_array(countries countries_type) IS
    BEGIN
        FOR i IN countries.FIRST .. countries.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(countries(i).country_name || ', ' || countries(i).region || ', ' || countries(i).currency);
        END LOOP;
    END;
    --P5
    PROCEDURE country_languages(v_country_name IN VARCHAR2, country_lang OUT country_languages_type ) IS
        CURSOR country_languages_cursor IS SELECT c.country_name, l.language_name, sl.official
            FROM COUNTRIES c,LANGUAGES l, SPOKEN_LANGUAGES sl
            WHERE LOWER(c.country_name) = LOWER(v_country_name)
                AND c.country_id = sl.country_id
                AND sl.language_id = l.language_id;
        i PLS_INTEGER := 1;
    BEGIN
        FOR country_language IN country_languages_cursor LOOP
            country_lang(i) := country_language;
            i := i + 1;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No data found for country ' || v_country_name);
    END;
    --P6
    PROCEDURE print_language_array(country_langs country_languages_type) IS
    BEGIN
        FOR i IN country_langs.FIRST .. country_langs.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(country_langs(i).country_name || ', ' || country_langs(i).language_name || ', ' || country_langs(i).official_language);
        END LOOP;
    END;
END;
