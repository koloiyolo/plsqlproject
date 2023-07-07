--------------EXECUTIONS: TRAVELLER ASSISTANCE PACKAGE--------------

------P1------
BEGIN
    TRAVELER_ASSISTANCE_PACKAGE.COUNTRY_DEMOGRAPHICS('Belize');
END;
------P2------
DECLARE
    country_name VARCHAR2(50) := 'Belize';
    country TRAVELER_ASSISTANCE_PACKAGE.country_type;
BEGIN
    TRAVELER_ASSISTANCE_PACKAGE.FIND_REGION_AND_CURRENCY(country_name, country);
    DBMS_OUTPUT.PUT_LINE(country.country_name || ', ' || country.region || ', ' || country.currency);
END;
------P3 & P4------
DECLARE
    region_name VARCHAR2(50) := 'Central America';
    countries TRAVELER_ASSISTANCE_PACKAGE.countries_type;
BEGIN
    TRAVELER_ASSISTANCE_PACKAGE.COUNTRIES_IN_SAME_REGION(region_name, countries);
    DBMS_OUTPUT.PUT_LINE('Countries in the same region are: ');
    TRAVELER_ASSISTANCE_PACKAGE.PRINT_REGION_ARRAY(countries);
END;
------P5 & P6------
DECLARE
    country_name VARCHAR2(50) := 'Belize';
    country_langs TRAVELER_ASSISTANCE_PACKAGE.country_languages_type;
BEGIN
    TRAVELER_ASSISTANCE_PACKAGE.COUNTRY_LANGUAGES(country_name, country_langs);
    DBMS_OUTPUT.PUT_LINE('Languages spoken in ' || country_name || ' are: ');
    TRAVELER_ASSISTANCE_PACKAGE.PRINT_LANGUAGE_ARRAY(country_langs);
END;

--------------EXECUTIONS: TRAVELLER ADMIN PACKAGE--------------

------P1------
--- See output of user_triggers
SELECT trigger_name FROM user_triggers;
--- DISABLE trigger
ALTER TRIGGER COUNT_TRIGGER DISABLE;
--- SHOW result
BEGIN
    traveler_admin_package.display_disabled_triggers();
END;
--- ENABLE trigger
ALTER TRIGGER COUNT_TRIGGER ENABLE;
--- SHOW result          TYPE        REFERENCED_NAME         REFERENCED_TYPE
EMP_DETAILS_VIEW               VIEW                           REGIONS
TABLE
TRAVELER_ASSISTANCE_PACKAGE    PACKAGE                        REGIONS
TABLE
TRAVELER_ASSISTANCE_PACKAGE    PACKAGE BODY                   REGIONS
TABLE

BEGIN
    traveler_admin_package.display_disabled_triggers();
END;

------P2 & P3------
--- See user dependecies
SELECT * FROM USER_DEPENDENCIES WHERE referenced_name = 'REGIONS';
--- See output of all_dependent_objects
DECLARE
    v_objects TRAVELER_ADMIN_PACKAGE.object_array;
BEGIN
    v_objects := traveler_admin_package.all_dependent_objects('regions');
    traveler_admin_package.print_dependent_objects(v_objects);
END;
