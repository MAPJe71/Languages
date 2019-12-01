*&---------------------------------------------------------------------*
*& Report ZNPP2SAP
*&---------------------------------------------------------------------*
*&
*& ABAP syntax check in Notepad++
*&
*& written by Michael Keller
*&
*&---------------------------------------------------------------------*
REPORT znpp2sap.

TYPES: BEGIN OF result,
         icon   TYPE icon_d,
         line   TYPE i,
         msg    TYPE string,
         word   TYPE string,
         msgkey TYPE trmsg_key,
         color  TYPE lvc_t_scol,
       END OF result.

DATA: gt_fcat   TYPE lvc_t_fcat,
      gt_result TYPE TABLE OF result.

PARAMETERS pa_file TYPE string.

START-OF-SELECTION.
  PERFORM main.

*&---------------------------------------------------------------------*
*&      Form MAIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*
*
*----------------------------------------------------------------------*
FORM main.

  DATA: lt_scode  TYPE TABLE OF string,
        ls_result LIKE LINE OF gt_result,
        ls_trdir  TYPE trdir,
        ls_scol   TYPE lvc_s_scol,
        ls_color  TYPE lvc_s_colo.

  sy-title = 'Notepad++ ABAP syntax check'.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = pa_file
      filetype                = 'ASC'
*     has_field_separator     = SPACE
*     header_length           = 0
*     read_by_line            = 'X'
*     dat_mode                = SPACE
*     codepage                = SPACE
*     ignore_cerr             = ABAP_TRUE
*     replacement             = '#'
*     virus_scan_profile      =
*   IMPORTING
*     filelength              =
*     header                  =
    CHANGING
      data_tab                = lt_scode
*     isscanperformed         = SPACE
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.

  IF sy-subrc <> 0.
    MESSAGE 'File read error occured.' TYPE 'I'.
    CALL 'SYST_LOGOFF'.
  ENDIF.

  IF lt_scode IS INITIAL.
    MESSAGE 'No source code found.' TYPE 'I'.
    CALL 'SYST_LOGOFF'.
  ENDIF.

  SELECT SINGLE *
         FROM trdir
         INTO ls_trdir
         WHERE name = sy-repid.

  IF sy-subrc <> 0.
    MESSAGE 'No directory entry found.' TYPE 'I'.
    CALL 'SYST_LOGOFF'.
  ENDIF.

  SYNTAX-CHECK FOR lt_scode MESSAGE ls_result-msg
                            LINE ls_result-line
                            WORD ls_result-word
                            DIRECTORY ENTRY ls_trdir
                            MESSAGE-ID ls_result-msgkey.

  IF sy-subrc <> 0.
    ls_result-icon = icon_status_critical.
    ls_color-col = 6.
    ls_color-int = 1.
    ls_color-inv = 0.
    ls_scol-color = ls_color.
    APPEND ls_scol TO ls_result-color.
  ELSE.
    ls_result-msg = 'Syntax check ok. Good work.'.
    ls_result-icon = icon_status_ok.
    ls_color-col = 5.
    ls_color-int = 1.
    ls_color-inv = 0.
    ls_scol-color = ls_color.
    APPEND ls_scol TO ls_result-color.
  ENDIF.

  APPEND ls_result TO gt_result.

  PERFORM prepare_fcat.
  PERFORM show_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form PREPARE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*
*
*----------------------------------------------------------------------*
FORM prepare_fcat.

  DATA: ls_fcat TYPE lvc_s_fcat,
        lv_pos  TYPE i VALUE 1.

  CLEAR ls_fcat.
  ls_fcat-col_pos   = lv_pos.
  ls_fcat-icon      = abap_true.
  ls_fcat-fieldname = 'ICON'.
  ls_fcat-scrtext_s = 'Status'.
  ls_fcat-scrtext_m = 'Status'.
  ls_fcat-scrtext_l = 'Status'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-col_pos   = lv_pos + 1.
  ls_fcat-fieldname = 'LINE'.
  ls_fcat-scrtext_s = 'Line'.
  ls_fcat-scrtext_m = 'Line'.
  ls_fcat-scrtext_l = 'Line'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-col_pos   = lv_pos + 1.
  ls_fcat-fieldname = 'WORD'.
  ls_fcat-scrtext_s = 'Word'.
  ls_fcat-scrtext_m = 'Word'.
  ls_fcat-scrtext_l = 'Word'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-col_pos   = lv_pos + 1.
  ls_fcat-fieldname = 'MSG'.
  ls_fcat-scrtext_s = 'Message'.
  ls_fcat-scrtext_m = 'Message'.
  ls_fcat-scrtext_l = 'Message'.
  APPEND ls_fcat TO gt_fcat.

  CLEAR ls_fcat.
  ls_fcat-col_pos   = lv_pos + 1.
  ls_fcat-fieldname = 'COLOR'.
  ls_fcat-ref_field = 'TABCOL'.
  ls_fcat-ref_table = 'BAL_S_SHOW_COL'.
  ls_fcat-tech      = 'X'.
  ls_fcat-no_out    = 'X'.
  APPEND ls_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form SHOW_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*
*
*----------------------------------------------------------------------*
FORM show_alv.

  DATA ls_layout TYPE lvc_s_layo.

  ls_layout-ctab_fname = 'COLOR'.
  ls_layout-cwidth_opt = abap_true.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
*     i_interface_check     = ' '
      i_bypassing_buffer    = 'X'
*     i_buffer_active       =
*     i_callback_program    =
*     i_callback_pf_status_set = ' '
*     i_callback_user_command  = ' '
*     i_callback_top_of_page   = ' '
*     i_callback_html_top_of_page = ' '
*     i_callback_html_end_of_list = ' '
*     i_structure_name      =
*     i_background_id       = ' '
*     i_grid_title          = ' '
*     i_grid_settings       =
      is_layout_lvc         = ls_layout
      it_fieldcat_lvc       = gt_fcat
*     it_excluding          =
*     it_special_groups_lvc =
*     it_sort_lvc           =
*     it_filter_lvc         =
*     it_hyperlink          =
*     is_sel_hide           =
*     i_default             = ' '
*     i_save                = ' '
*     is_variant            =
*     it_events             =
*     it_event_exit         =
*     is_print_lvc          =
*     is_reprep_id_lvc      =
      i_screen_start_column = 10
      i_screen_start_line   = 10
      i_screen_end_column   = 120
      i_screen_end_line     = 11
*     i_html_height_top     =
*     i_html_height_end     =
*     it_alv_graphics       =
*     it_except_qinfo_lvc   =
*     ir_salv_fullscreen_adapter  =
*     IMPORTING
*     e_exit_caused_by_caller  =
*     es_exit_caused_by_user   =
    TABLES
      t_outtab              = gt_result
    EXCEPTIONS
      program_error         = 1
      OTHERS                = 2.

  IF sy-subrc <> 0. " without error handling
  ENDIF.

  CALL 'SYST_LOGOFF'.

ENDFORM.