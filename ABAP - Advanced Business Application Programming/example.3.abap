     REPORT z_soc_class_report.
    SELECTION-SCREEN BEGIN OF SCREEN 100.
    PARAMETERS p_carrid TYPE spfli-carrid.
    SELECTION-SCREEN END OF SCREEN 100. 

    TYPES spfli_tab TYPE STANDARD TABLE OF spfli. 

    CLASS presentation_server DEFINITION.
      PUBLIC SECTION.
        CLASS-METHODS:
          get_carrid RETURNING VALUE(carrid) TYPE spfli-carrid,
          display_table IMPORTING VALUE(table) TYPE spfli_tab.
    ENDCLASS. 

    CLASS presentation_server IMPLEMENTATION.
      METHOD get_carrid.
        CALL SELECTION-SCREEN 100.
        IF sy-subrc = 0.
          carrid = p_carrid.
        ENDIF.
      ENDMETHOD.
      METHOD display_table.
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
       ENDMETHOD.
    ENDCLASS. 

    CLASS application_server DEFINITION.
      PUBLIC SECTION.
        CLASS-METHODS
           sort_table CHANGING table TYPE spfli_tab.
        ENDCLASS. 

    CLASS application_server IMPLEMENTATION.
      METHOD sort_table.
        SORT table BY cityfrom cityto.
      ENDMETHOD.
    ENDCLASS. 

    CLASS persistency_server DEFINITION.
      PUBLIC SECTION.
        CLASS-METHODS
           get_table IMPORTING carrid TYPE spfli-carrid
                     EXPORTING table  TYPE spfli_tab
                               arc     TYPE sy-subrc.
    ENDCLASS. 

    CLASS persistency_server IMPLEMENTATION.
      METHOD get_table.
       SELECT *
              FROM spfli
              WHERE carrid = @carrid
              INTO TABLE @table.
        arc = sy-subrc.
      ENDMETHOD.
    ENDCLASS. 

    CLASS report DEFINITION.
      PUBLIC SECTION.
        CLASS-METHODS main.
    ENDCLASS. 

    CLASS report IMPLEMENTATION.
      METHOD main.
        DATA: carrid TYPE spfli-carrid,
              table  TYPE spfli_tab,
              arc     TYPE sy-subrc.
        carrid = presentation_server=>get_carrid( ).
        persistency_server=>get_table( EXPORTING carrid = carrid
                                       IMPORTING table  = table
                                                 arc     = arc ).
        IF arc = 0.
          application_server=>sort_table(
            CHANGING table = table ).
          presentation_server=>display_table( table ).
        ENDIF.
      ENDMETHOD.
    ENDCLASS. 

    START-OF-SELECTION.
    report=>main( ). 