     REPORT z_soc_report. 

    SELECTION-SCREEN BEGIN OF SCREEN 100.
    PARAMETERS p_carrid TYPE spfli-carrid.
    SELECTION-SCREEN END OF SCREEN 100. 

    TYPES spfli_tab TYPE STANDARD TABLE OF spfli. 

    DATA: carrid TYPE spfli-carrid,
          table  TYPE spfli_tab,
          arc     TYPE sy-subrc. 

    START-OF-SELECTION.
      PERFORM get_carrid CHANGING carrid.
      PERFORM get_table  USING    carrid
                         CHANGING table
                                  arc. 

    IF arc = 0
      PERFORM sort_table    CHANGING table.
      PERFORM display_table USING    table.
    ENDIF. 

    * Presentation layer 

    FORM get_carrid
         CHANGING value(carrid) TYPE spfli-carrid.
      CALL SELECTION-SCREEN 100.
      IF sy-subrc = 0.
        carrid = p_carrid.
      ENDIF.
    ENDFORM. 

    FORM display_table
         USING table TYPE spfli_tab.
      DATA: alv     TYPE REF TO cl_salv_table,
            alv_exc TYPE REF TO cx_salv_msg.
      TRY.
         cl_salv_table=>factory(
           IMPORTING r_salv_table = alv
           CHANGING t_table = table ).
         alv->display( ).
       CATCH cx_salv_msg INTO alv_exc.
         MESSAGE alv_exc TYPE 'I' DISPLAY LIKE 'E'.
      ENDTRY.
    ENDFORM. 

    * Application layer 

    FORM sort_table
         CHANGING table TYPE spfli_tab.
         SORT table BY cityfrom cityto.
    ENDFORM. 

    * Persistency layer 

    FORM get_table
         USING     carrid TYPE spfli-carrid
         CHANGING table   TYPE spfli_tab
                  arc     TYPE sy-subrc.
      SELECT *
             FROM spfli
             WHERE carrid = @carrid
             INTO TABLE @table.
      arc = sy-subrc.
    ENDFORM. 