CREATE OR REPLACE PACKAGE BODY "TEST"."COUNTRIES_API" IS
  /**
   * generator="OM_TAPIGEN"
   * generator_version="0.5.0"
   * generator_action="COMPILE_API"
   * generated_at="2018-12-20 19:43:11"
   * generated_by="OGOBRECHT"
   */

  FUNCTION row_exists (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE /*PK*/ )
  RETURN BOOLEAN
  IS
    v_return BOOLEAN := FALSE;
    v_dummy  PLS_INTEGER;
    CURSOR   cur_bool IS
      SELECT 1
        FROM "COUNTRIES"
       WHERE "COUNTRY_ID" = p_country_id;
  BEGIN
    OPEN cur_bool;
    FETCH cur_bool INTO v_dummy;
    IF cur_bool%FOUND THEN
      v_return := TRUE;
    END IF;
    CLOSE cur_bool;
    RETURN v_return;
  END;

  FUNCTION row_exists_yn (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE /*PK*/ )
  RETURN VARCHAR2
  IS
  BEGIN
    RETURN CASE WHEN row_exists( p_country_id => p_country_id )
             THEN 'Y'
             ELSE 'N'
           END;
  END;

  FUNCTION create_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE   DEFAULT NULL /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE DEFAULT NULL,
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE    DEFAULT NULL /*FK*/ )
  RETURN "COUNTRIES"."COUNTRY_ID"%TYPE IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    INSERT INTO "COUNTRIES" (
      "COUNTRY_ID" /*PK*/,
      "COUNTRY_NAME",
      "REGION_ID" /*FK*/ )
    VALUES (
      p_country_id,
      p_country_name,
      p_region_id )
    RETURN
      "COUNTRY_ID"
    INTO v_return;
    RETURN v_return;
  END create_row;

  PROCEDURE create_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE   DEFAULT NULL /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE DEFAULT NULL,
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE    DEFAULT NULL /*FK*/ )
  IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_row (
      p_country_id   => p_country_id /*PK*/,
      p_country_name => p_country_name,
      p_region_id    => p_region_id /*FK*/ );
  END create_row;

  FUNCTION create_row (
    p_row          IN "COUNTRIES"%ROWTYPE )
  RETURN "COUNTRIES"."COUNTRY_ID"%TYPE IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_row (
      p_country_id   => p_row."COUNTRY_ID" /*PK*/,
      p_country_name => p_row."COUNTRY_NAME",
      p_region_id    => p_row."REGION_ID" /*FK*/ );
    RETURN v_return;
  END create_row;

  PROCEDURE create_row (
    p_row          IN "COUNTRIES"%ROWTYPE )
  IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_row (
      p_country_id   => p_row."COUNTRY_ID" /*PK*/,
      p_country_name => p_row."COUNTRY_NAME",
      p_region_id    => p_row."REGION_ID" /*FK*/ );
  END create_row;

  FUNCTION read_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE /*PK*/ )
  RETURN "COUNTRIES"%ROWTYPE IS
    v_row "COUNTRIES"%ROWTYPE;
    CURSOR cur_row IS
      SELECT *
        FROM "COUNTRIES"
       WHERE "COUNTRY_ID" = p_country_id;
  BEGIN
    OPEN cur_row;
    FETCH cur_row INTO v_row;
    CLOSE cur_row;
    RETURN v_row;
  END read_row;

  PROCEDURE update_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE DEFAULT NULL /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE,
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE /*FK*/ )
  IS
    v_row   "COUNTRIES"%ROWTYPE;

  BEGIN
    IF row_exists ( p_country_id => p_country_id ) THEN
      v_row := read_row ( p_country_id => p_country_id );
      -- update only, if the column values really differ
      IF COALESCE(v_row."COUNTRY_NAME", '@@@@@@@@@@@@@@@') <> COALESCE(p_country_name, '@@@@@@@@@@@@@@@')
      OR COALESCE(v_row."REGION_ID", -999999999999999.999999999999999) <> COALESCE(p_region_id, -999999999999999.999999999999999)

      THEN
        UPDATE COUNTRIES
           SET "COUNTRY_NAME" = p_country_name,
               "REGION_ID"    = p_region_id /*FK*/
         WHERE "COUNTRY_ID" = p_country_id;
      END IF;
    END IF;
  END update_row;

  PROCEDURE update_row (
    p_row          IN "COUNTRIES"%ROWTYPE )
  IS
  BEGIN
    update_row(
      p_country_id   => p_row."COUNTRY_ID" /*PK*/,
      p_country_name => p_row."COUNTRY_NAME",
      p_region_id    => p_row."REGION_ID" /*FK*/ );
  END update_row;

  FUNCTION create_or_update_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE DEFAULT NULL /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE,
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE /*FK*/ )
  RETURN "COUNTRIES"."COUNTRY_ID"%TYPE IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    IF row_exists( p_country_id => p_country_id ) THEN
      update_row(
        p_country_id   => p_country_id /*PK*/,
        p_country_name => p_country_name,
        p_region_id    => p_region_id /*FK*/ );
      v_return := read_row ( p_country_id => p_country_id )."COUNTRY_ID";
    ELSE
      v_return := create_row (
        p_country_id   => p_country_id /*PK*/,
        p_country_name => p_country_name,
        p_region_id    => p_region_id /*FK*/ );
    END IF;
    RETURN v_return;
  END create_or_update_row;

  PROCEDURE create_or_update_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE DEFAULT NULL /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE,
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE /*FK*/ )
  IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_or_update_row(
      p_country_id   => p_country_id /*PK*/,
      p_country_name => p_country_name,
      p_region_id    => p_region_id /*FK*/ );
  END create_or_update_row;

  FUNCTION create_or_update_row (
    p_row          IN "COUNTRIES"%ROWTYPE )
  RETURN "COUNTRIES"."COUNTRY_ID"%TYPE IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_or_update_row(
      p_country_id   => p_row."COUNTRY_ID" /*PK*/,
      p_country_name => p_row."COUNTRY_NAME",
      p_region_id    => p_row."REGION_ID" /*FK*/ );
    RETURN v_return;
  END create_or_update_row;

  PROCEDURE create_or_update_row (
    p_row          IN "COUNTRIES"%ROWTYPE )
  IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_or_update_row(
      p_country_id   => p_row."COUNTRY_ID" /*PK*/,
      p_country_name => p_row."COUNTRY_NAME",
      p_region_id    => p_row."REGION_ID" /*FK*/ );
  END create_or_update_row;

  FUNCTION get_a_row
  RETURN "COUNTRIES"%ROWTYPE IS
    v_row "COUNTRIES"%ROWTYPE;
  BEGIN
    v_row."COUNTRY_ID"   := substr(sys_guid(),1,2) /*PK*/;
    v_row."COUNTRY_NAME" := substr(sys_guid(),1,40);
    v_row."REGION_ID"    := 59777415 /*FK*/;
    return v_row;
  END get_a_row;

  FUNCTION create_a_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE   DEFAULT get_a_row()."COUNTRY_ID" /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE DEFAULT get_a_row()."COUNTRY_NAME",
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE    DEFAULT get_a_row()."REGION_ID" /*FK*/ )
  RETURN "COUNTRIES"."COUNTRY_ID"%TYPE IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_row (
      p_country_id   => p_country_id /*PK*/,
      p_country_name => p_country_name,
      p_region_id    => p_region_id /*FK*/ );
    RETURN v_return;
  END create_a_row;

  PROCEDURE create_a_row (
    p_country_id   IN "COUNTRIES"."COUNTRY_ID"%TYPE   DEFAULT get_a_row()."COUNTRY_ID" /*PK*/,
    p_country_name IN "COUNTRIES"."COUNTRY_NAME"%TYPE DEFAULT get_a_row()."COUNTRY_NAME",
    p_region_id    IN "COUNTRIES"."REGION_ID"%TYPE    DEFAULT get_a_row()."REGION_ID" /*FK*/ )
  IS
    v_return "COUNTRIES"."COUNTRY_ID"%TYPE;
  BEGIN
    v_return := create_row (
      p_country_id   => p_country_id /*PK*/,
      p_country_name => p_country_name,
      p_region_id    => p_region_id /*FK*/ );
  END create_a_row;

  FUNCTION read_a_row
  RETURN "COUNTRIES"%ROWTYPE IS
    v_row  "COUNTRIES"%ROWTYPE;
    CURSOR cur_row IS SELECT * FROM COUNTRIES;
  BEGIN
    OPEN cur_row;
    FETCH cur_row INTO v_row;
    CLOSE cur_row;
    RETURN v_row;
  END read_a_row;

END "COUNTRIES_API";
/

