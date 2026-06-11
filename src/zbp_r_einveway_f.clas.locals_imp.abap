CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS ceinv FOR MODIFY
      IMPORTING keys FOR ACTION head~ceinv RESULT result.

    METHODS ceway FOR MODIFY
      IMPORTING keys FOR ACTION head~ceway RESULT result.

    METHODS einvoice FOR MODIFY
      IMPORTING keys FOR ACTION head~einvoice RESULT result.

    METHODS eway FOR MODIFY
      IMPORTING keys FOR ACTION head~eway RESULT result.

    METHODS savedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~savedata.

    METHODS veheway FOR MODIFY
      IMPORTING keys FOR ACTION head~veheway RESULT result.

    METHODS dateway FOR MODIFY
      IMPORTING keys FOR ACTION head~dateway RESULT result.

    METHODS traeway FOR MODIFY
      IMPORTING keys FOR ACTION head~traeway RESULT result.

ENDCLASS.


CLASS lhc_head IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM zdt_einveway
      FOR ALL ENTRIES IN @keys
      WHERE vbeln = @keys-billingdocument
      INTO TABLE @FINAL(lt_tab).
    SELECT * FROM i_billingdocument
      FOR ALL ENTRIES IN @keys
      WHERE billingdocument = @keys-billingdocument
      " TODO: variable is assigned but never used (ABAP cleaner)
      INTO TABLE @FINAL(lt_tab1).
    SELECT * FROM zdt_gstrmap
      " TODO: variable is assigned but never used (ABAP cleaner)
      INTO TABLE @FINAL(lt_gstmap).

    SELECT * FROM zr_einveway_v0
      FOR ALL ENTRIES IN @keys
      WHERE billingdocument = @keys-billingdocument
      INTO TABLE @FINAL(lt_einveway).

    FINAL(ls_key) = keys[ 1 ].
    FINAL(ls_einveway) = VALUE #( lt_einveway[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
    FINAL(ls_einvewaydb) = VALUE #( lt_tab[ vbeln = ls_key-billingdocument ] OPTIONAL ).

    result = VALUE #( FOR gs_header IN keys
                      ( %tky             = gs_header-%tky

                        %action-einvoice = COND #( WHEN ls_einveway-irnind IS NOT INITIAL
                                                    AND ls_einvewaydb-irn  IS INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )

                        %action-eway     = COND #( WHEN ls_einveway-ewayind IS NOT INITIAL
                                                    AND ls_einveway-irnind  IS INITIAL
                                                    AND ls_einvewaydb-eway  IS INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )

                        %action-ceinv    = COND #( WHEN ls_einveway-irnind         IS NOT INITIAL
                                                    AND ls_einvewaydb-irn          IS NOT INITIAL
                                                    AND ls_einveway-ewayind        IS NOT INITIAL
                                                    AND ls_einvewaydb-ewaycancflag IS NOT INITIAL
                                                    AND ls_einvewaydb-irncancflag  IS INITIAL THEN
                                                     if_abap_behv=>fc-o-enabled

                                                   WHEN ls_einveway-irnind        IS NOT INITIAL
                                                    AND ls_einvewaydb-irn         IS NOT INITIAL
                                                    AND ls_einveway-ewayind       IS INITIAL
                                                    AND ls_einvewaydb-irncancflag IS INITIAL THEN
                                                     if_abap_behv=>fc-o-enabled

                                                   ELSE
                                                     if_abap_behv=>fc-o-disabled )

                        %action-ceway    = COND #( WHEN ls_einveway-ewayind        IS NOT INITIAL
                                                    AND ls_einvewaydb-ewaycancflag IS INITIAL
                                                    AND ls_einvewaydb-eway         IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )

                        %action-veheway    = COND #( WHEN ls_einveway-ewayind        IS NOT INITIAL
                                                    AND ls_einvewaydb-ewaycancflag IS INITIAL
                                                    AND ls_einvewaydb-eway         IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )

                        %action-dateway    = COND #( WHEN ls_einveway-ewayind        IS NOT INITIAL
                                                    AND ls_einvewaydb-ewaycancflag IS INITIAL
                                                    AND ls_einvewaydb-eway         IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )
                        %action-traeway    = COND #( WHEN ls_einveway-ewayind        IS NOT INITIAL
                                                    AND ls_einvewaydb-ewaycancflag IS INITIAL
                                                    AND ls_einvewaydb-eway         IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD ceinv.
    DATA lv_json  TYPE string.
    DATA lv_gid   TYPE string.
    DATA lv_gid1  TYPE string.
    DATA lt_error TYPE STANDARD TABLE OF zdt_error_log.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_p     TYPE char10.
    DATA ls_error TYPE zdt_error_log.
    DATA lv_p1    TYPE numc5.

    SELECT * FROM zdt_token
      INTO TABLE @FINAL(lt_parm).
    SELECT * FROM zdt_gstrmap
      INTO TABLE @FINAL(lt_gstmap).
    IF keys IS NOT INITIAL.
      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).
      IF sy-subrc IS INITIAL.
        SELECT * FROM zr_einveway_v1
          FOR ALL ENTRIES IN @keys
          WHERE billingdocument = @keys-billingdocument
          INTO TABLE @FINAL(lt_billdocitem).
      ENDIF.
    ENDIF.

    LOOP AT keys INTO FINAL(ls_key).
      DATA(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(ls_billdocitem) = VALUE #( lt_billdocitem[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
      FINAL(ls_gstmap) = VALUE #( lt_gstmap[ fkart = ls_billdoc-billingdocumenttype ] OPTIONAL ).
      ls_billdoc-irn = condense( val  = ls_billdoc-irn
                                 from = ` `
                                 to   = `` ).

      IF ls_billdoc-irn IS INITIAL.
        DATA(lv_msg) = 'IRN Not generated yet'.
        APPEND VALUE #( %tky = ls_key-%tky )
               TO failed-head.

        APPEND VALUE #( %tky        = ls_key-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-head.
      ENDIF.

      IF ls_billdoc-ewaycancflag IS INITIAL AND ls_gstmap-ewayind IS NOT INITIAL.
        lv_msg = 'Cancel the Eway First'.
        APPEND VALUE #( %tky = ls_key-%tky )
               TO failed-head.

        APPEND VALUE #( %tky        = ls_key-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-head.
      ENDIF.

      IF ls_billdoc-cnlrsneinv IS INITIAL OR ls_billdoc-cnlremarkseinv IS INITIAL.
        lv_msg = 'Please enter IRN Cancellation Code/Remarks.'.
        APPEND VALUE #( %tky = ls_key-%tky )
               TO failed-head.

        APPEND VALUE #( %tky        = ls_key-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-head.
        RETURN.
      ENDIF.
      " Cancellation Based on IRN -------
      lv_json = ' { '.
      lv_json = |{ lv_json }  "Irn": "{ ls_billdoc-irn }" , |.
      lv_json = |{ lv_json }  "CnlRsn": "{ ls_billdoc-cnlrsneinv }", |.
      lv_json = |{ lv_json }  "CnlRem": "{ ls_billdoc-cnlremarkseinv }" |.
      lv_json = |{ lv_json } \} |.

      " Cancellation Based on Document -------
      SELECT SINGLE * FROM i_billingdocument
      WHERE billingdocument = @ls_billdoc-billingdocument
      INTO @DATA(ls_bill).

      SELECT SINGLE * FROM zdt_header_token
      WHERE company = @ls_bill-companycode
      INTO @DATA(ls_headtkn).

      TRY.
*          IF lt_parm IS NOT INITIAL.
*            FINAL(lv_token) = VALUE #( lt_parm[ tparameter = 'Token' ]-value OPTIONAL ).
*            FINAL(lv_customer) = VALUE #( lt_parm[ tparameter = 'CustomerID' ]-value OPTIONAL ).
*          ENDIF.
*          lv_gid = lv_token.
*          lv_gid1 = lv_customer.
          lv_gid = ls_headtkn-gstin.
          lv_gid1 = ls_headtkn-clientid.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCOMM_GENIRN'
                                      service_id    = 'ZOS_CANCELIRN_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          lo_request->set_header_field( i_name  = 'Clientcode'
                                         i_value = lv_gid1 ).
          lo_request->set_header_field( i_name  = 'GSTIN'
                                        i_value = lv_gid ).

          lo_request->set_text( lv_json ).
          FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close( ).
          CLEAR lv_json.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
      ENDTRY.
      IF ls_result IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM zdt_einveway
        WHERE vbeln = @ls_billdoc-billingdocument
        INTO @DATA(ls_save).
      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " SPLIT ls_result AT '"error": false' INTO TABLE FINAL(lt_tab1).
      " IF ls_result CS '"error": false'.
      IF ls_result CS '"status":"1"'.
        SPLIT ls_result AT '"data":{"cnlDt":"' INTO TABLE FINAL(lt_tab2).
        FINAL(lv_str2) = VALUE #( lt_tab2[ 2 ] OPTIONAL ).
        ls_save-irncanceldate = lv_str2+0(22).
        ls_save-irncancflag   = 'X'.
        ls_save-irnflag       = ' '.
        MODIFY zdt_einveway FROM @ls_save.
        CLEAR ls_save.
      ELSE.
        " TODO: variable is assigned but never used (ABAP cleaner)
        APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
        SELECT MAX( item ) FROM zdt_error_log
          WHERE billdoc = @ls_billdoc-billingdocument
          INTO @FINAL(lv_max).
        lv_p = lv_max.

        SPLIT ls_result AT '"error_desc":"' INTO TABLE FINAL(lt_msg).

        LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
          IF <fs_msg> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.
          SPLIT <fs_msg> AT 'Index' INTO TABLE FINAL(lt_msg1).
          lv_msg = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
          ls_error-billdoc = ls_billdoc-billingdocument.
          ls_error-item    = lv_p1.
          lv_p1 += 1.
          ls_error-message = lv_msg.
          ls_error-logdate = sy-datum.
          ls_error-logtime = sy-uzeit.
          APPEND ls_error TO lt_error.
          CLEAR ls_error.
        ENDLOOP.

        DELETE lt_error WHERE item = '00000'.
        MODIFY zdt_error_log FROM TABLE @lt_error.

        MODIFY zdt_error_log FROM TABLE @lt_error.
        CLEAR ls_save.

      ENDIF.

    ENDLOOP.
    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
         ENTITY head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

  METHOD ceway.
    DATA lv_json  TYPE string.
    DATA lv_gid   TYPE string.
    DATA lv_gid1  TYPE string.
    DATA lv_gid2  TYPE string.
    DATA lt_error TYPE STANDARD TABLE OF zdt_error_log.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_p     TYPE char10.
    DATA ls_error TYPE zdt_error_log.
    DATA lv_p1    TYPE numc5.

    SELECT * FROM zdt_token
      INTO TABLE @FINAL(lt_parm).
    SELECT * FROM zdt_gstrmap
      INTO TABLE @FINAL(lt_gstmap).
    IF keys IS NOT INITIAL.
      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).
      IF sy-subrc IS INITIAL.
        SELECT * FROM zr_einveway_v1
          FOR ALL ENTRIES IN @keys
          WHERE billingdocument = @keys-billingdocument
          INTO TABLE @FINAL(lt_billdocitem).
      ENDIF.
    ENDIF.
    LOOP AT keys INTO FINAL(ls_key).
      DATA(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
      FINAL(ls_billdocitem) = VALUE #( lt_billdocitem[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
      FINAL(ls_gstmap) = VALUE #( lt_gstmap[ fkart = ls_billdoc-billingdocumenttype ] OPTIONAL ).

      ls_billdoc-eway = condense( val  = ls_billdoc-eway
                                  from = ` `
                                  to   = `` ).

      IF ls_billdoc-eway IS INITIAL.
        DATA(lv_msg) = 'EWAY Not generated yet'.
        APPEND VALUE #( %tky = ls_key-%tky )
               TO failed-head.

        APPEND VALUE #( %tky        = ls_key-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-head.
      ENDIF.

      IF ls_billdoc-cancelrsncodeewb IS INITIAL OR ls_billdoc-cancelremarksewb IS INITIAL.
        lv_msg = 'Please enter eWay Cancellation Code/Remarks.'.
        APPEND VALUE #( %tky = ls_key-%tky )
               TO failed-head.

        APPEND VALUE #( %tky        = ls_key-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-head.
        RETURN.
      ENDIF.

      IF ls_gstmap-ewayind IS NOT INITIAL.
        lv_json = '{'.
        lv_json = |{ lv_json } "action": "CANEWB", |.
        lv_json = |{ lv_json } "data": |.
        lv_json = |{ lv_json }\{|.
        lv_json = |{ lv_json } "ewbNo": { ls_billdoc-eway },   |.
        lv_json = |{ lv_json } "cancelRsnCode": { ls_billdoc-cancelrsncodeewb }, |.
        lv_json = |{ lv_json } "cancelRmrk": "{ ls_billdoc-cancelremarksewb }" |.
        lv_json = |{ lv_json }\}\}|.
      ENDIF.

      SELECT SINGLE * FROM i_billingdocument
    WHERE billingdocument = @ls_billdoc-billingdocument
    INTO @DATA(ls_bill).

      SELECT SINGLE * FROM zdt_header_token
      WHERE company = @ls_bill-companycode
      INTO @DATA(ls_headtkn).
      TRY.
*          IF lt_parm IS NOT INITIAL.
*            FINAL(lv_token) = VALUE #( lt_parm[ tparameter = 'Token' ]-value OPTIONAL ).
*            FINAL(lv_customer) = VALUE #( lt_parm[ tparameter = 'CustomerID' ]-value OPTIONAL ).
*          ENDIF.
*          lv_gid = lv_token.
*          lv_gid1 = lv_customer.
          lv_gid = ls_headtkn-gstin.
          lv_gid1 = ls_headtkn-clientid.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCOMM_GENIRN'
                                      service_id    = 'ZOS_CANCELEWAY_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          lo_request->set_header_field( i_name  = 'Clientcode'
                                         i_value = lv_gid1 ).
          lo_request->set_header_field( i_name  = 'GSTIN'
                                        i_value = lv_gid ).
          lv_gid2 = ls_billdocitem-in_gstidentificationnumber.
          IF ls_gstmap-irnind IS INITIAL.
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = lv_gid2 ).
          ELSE.
            lo_request->set_header_field( i_name  = 'onlyewbcancel'
                                          i_value = 'Y' ).
          ENDIF.
          lo_request->set_text( lv_json ).

          FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close( ).
          CLEAR lv_json.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
      ENDTRY.

      IF ls_result IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM zdt_einveway
        WHERE vbeln = @ls_billdoc-billingdocument
        INTO @DATA(ls_save).
      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      IF ls_result CS '"status":"1"'.
        SPLIT ls_result AT ',"cancelDate":"' INTO TABLE FINAL(lt_tab2).
        FINAL(lv_str2) = VALUE #( lt_tab2[ 2 ] OPTIONAL ).
        ls_save-ewaycanceldate = lv_str2+0(22).
        ls_save-ewaycancflag   = 'X'.
        ls_save-ewayflag       = ' '.
        MODIFY zdt_einveway FROM @ls_save.
        CLEAR ls_save.
      ELSE.
        " TODO: variable is assigned but never used (ABAP cleaner)
        APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
        SELECT MAX( item ) FROM zdt_error_log
          WHERE billdoc = @ls_billdoc-billingdocument
          INTO @FINAL(lv_max).
        lv_p = lv_max.

        SPLIT ls_result AT '"error_desc":"' INTO TABLE FINAL(lt_msg).

        LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
          IF <fs_msg> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.
          SPLIT <fs_msg> AT 'Index' INTO TABLE FINAL(lt_msg1).
          lv_msg = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
          ls_error-billdoc = ls_billdoc-billingdocument.
          ls_error-item    = lv_p1.
          lv_p1 += 1.
          ls_error-message = lv_msg.
          ls_error-logdate = sy-datum.
          ls_error-logtime = sy-uzeit.
          APPEND ls_error TO lt_error.
          CLEAR ls_error.
        ENDLOOP.

        DELETE lt_error WHERE item = '00000'.
        MODIFY zdt_error_log FROM TABLE @lt_error.

        MODIFY zdt_error_log FROM TABLE @lt_error.
        CLEAR ls_save.

      ENDIF.

    ENDLOOP.
    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
         ENTITY head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

  METHOD einvoice.
    DATA lv_gid           TYPE string.
    DATA lv_gid1          TYPE string.
    " DATA lv_roffv TYPE text20 VALUE 0.
    DATA lv_vfdat         TYPE c LENGTH 10.
    DATA val_totinvval    TYPE text25        VALUE 0.
    DATA lv_hdr           TYPE string.
    DATA lv_docdtls       TYPE string.
    DATA lv_trandtls      TYPE string.
    DATA lv_sellerdtls    TYPE string.
    DATA lv_buyerdtls     TYPE string.
    DATA lv_dispdtls      TYPE string.
    DATA lv_shipdtls      TYPE string.
    DATA lv_addldocdtls   TYPE string.
    DATA lv_expdtls       TYPE string.
    DATA val_tot_fc       TYPE text25        VALUE 0.
    DATA val_igstval      TYPE text25        VALUE 0.
    DATA val_cgstval      TYPE text25        VALUE 0.
    DATA val_sgstval      TYPE text25        VALUE 0.
    DATA val_assval       TYPE text25        VALUE 0.
    DATA lv_discount       TYPE text25        VALUE 0.
    DATA val_cesval       TYPE text25        VALUE 0.
    DATA lv_ewbdtl        TYPE string.
    DATA val_stcesval     TYPE text25        VALUE 0.
    DATA lv_roffv         TYPE text25        VALUE 0.
    DATA val_othchrg      TYPE text25        VALUE 0.
    DATA lv_valdtls       TYPE string.
    DATA lv_refdtls       TYPE string.
    DATA lv_paydtls       TYPE string.
    DATA lv_itemlists     TYPE string.
    DATA lv_qty           TYPE string.
    DATA lv_unitp         TYPE text25        VALUE 0.
    DATA lv_dismt         TYPE text25        VALUE 0.
    DATA lv_totrt         TYPE text20        VALUE 0.
    DATA lv_igstm         TYPE text25        VALUE 0.
    DATA lv_cgstm         TYPE text25        VALUE 0.
    DATA lv_sgstm         TYPE text25        VALUE 0.
    DATA lv_cesrt         TYPE text20        VALUE 0.
    DATA lv_ass           TYPE text25        VALUE 0.
    DATA lv_igstt         TYPE text20        VALUE 0.
    DATA lv_cgstt         TYPE text20        VALUE 0.
    DATA lv_sgstt         TYPE text20        VALUE 0.
    DATA lv_stcna         TYPE text20        VALUE 0.
    DATA lv_invmt         TYPE text25        VALUE 0.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_hsdat         TYPE c LENGTH 10.
    DATA lv_ind           TYPE char1.
    DATA lv_itemlist      TYPE string.
    DATA lv_schmt         TYPE text25        VALUE 0.
    DATA lv_pretax        TYPE text25        VALUE 0.
    DATA lv_stcess        TYPE text20        VALUE 0.
    DATA lv_cessm         TYPE text25        VALUE 0.
    DATA lv_stcessm       TYPE text25        VALUE 0.
    DATA lv_itemlist1     TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA len              TYPE i.
    DATA lv_payload3      TYPE string.
    DATA lv_end_line      TYPE string.
    DATA lv_end           TYPE string.
    DATA lv_transportdtls TYPE string.
    DATA lv_json          TYPE string.
    DATA ls_save          TYPE zdt_einveway.
    DATA lt_error         TYPE STANDARD TABLE OF zdt_error_log.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_p             TYPE char10.
    DATA ls_error         TYPE zdt_error_log.
    DATA lv_p1            TYPE numc5.
    DATA lv_dateeway      TYPE char30.
    DATA lv_validtill      TYPE char30.
    DATA lv_diffgstn TYPE string.

    IF keys IS NOT INITIAL.

      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).

      SELECT * FROM zr_einveway_v0
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc_n).

      SELECT * FROM zr_gsttaxclassification
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_taxclass).

      SELECT * FROM i_billingdocument
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billingdoc).
      IF sy-subrc IS INITIAL.

        SELECT * FROM zr_einveway_v1
          FOR ALL ENTRIES IN @keys
          WHERE billingdocument = @keys-billingdocument
          INTO TABLE @FINAL(lt_billdocitem).

      ENDIF.

    ENDIF.
    SELECT * FROM zdt_token
      INTO TABLE @FINAL(lt_parm).
    IF lt_parm IS NOT INITIAL.
      FINAL(lv_token) = VALUE #( lt_parm[ tparameter = 'Token' ]-value OPTIONAL ).
      FINAL(lv_customer) = VALUE #( lt_parm[ tparameter = 'CustomerID' ]-value OPTIONAL ).
    ENDIF.
    lv_gid = lv_token.
    lv_gid1 = lv_customer.
    SELECT * FROM zdt_state_code1
      INTO TABLE @FINAL(lt_state).
    SELECT * FROM zdt_ccodeaddress
      INTO TABLE @FINAL(lt_companycode).
    SELECT * FROM zdt_uom
      INTO TABLE @FINAL(lt_uom).
    SELECT * FROM zdt_portcode
   " TODO: variable is assigned but never used (ABAP cleaner)
      INTO TABLE @FINAL(lt_port).
    LOOP AT keys INTO FINAL(ls_keys).

      DATA(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_keys-billingdocument ] OPTIONAL ).
      FINAL(ls_billdoc_n) = VALUE #( lt_billdoc_n[ billingdocument = ls_keys-billingdocument ] OPTIONAL ).
      FINAL(ls_billdocitem) = VALUE #( lt_billdocitem[ billingdocument = ls_keys-billingdocument ] OPTIONAL ).
      FINAL(ls_taxclass) = VALUE #( lt_taxclass[ billingdocument = ls_keys-billingdocument ] OPTIONAL ).
      FINAL(ls_billingdoc) = VALUE #( lt_billingdoc[ billingdocument = ls_keys-billingdocument ] OPTIONAL ).

      CLEAR lv_vfdat.
      CONCATENATE ls_billdoc-billingdocumentdate+6(2) ls_billdoc-billingdocumentdate+4(2) ls_billdoc-billingdocumentdate(4) INTO lv_vfdat SEPARATED BY '/'.
      val_totinvval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                               WHERE ( billingdocument = ls_keys-billingdocument )
                                               NEXT i = i + ls_i-materialvalue ) +
                                               REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                               WHERE ( billingdocument = ls_keys-billingdocument )
                                               NEXT i = i + ls_i-totalgstvalue ) +
                                               REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                               WHERE ( billingdocument = ls_keys-billingdocument )
                                               NEXT i = i + ls_i-cessvalue ) +
                                               REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                               WHERE ( billingdocument = ls_keys-billingdocument )
                                               NEXT i = i + ls_i-discountvalue ).

      """"""""""""""""""TMG will be maintained""""""""""""""""""""""""""""""""""""
      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      IF sy-sysid = 'PZJ' OR sy-sysid = 'A1S'.
        CONCATENATE
*      '{"User_GSTIN":"' ls_billdocitem-in_gstidentificationnumber '",'
         '{"User_GSTIN":"20AACCC3707F1ZE",'
         '"Version": "1.01",'
         '"IRN": "",'
         '"SourceSystem": "SAP",'
         '"is_irn":"Y",'
         '"is_ewb":"N",'
         '"email": "",'
         INTO lv_hdr.
      ELSE.
        CONCATENATE
      '{"User_GSTIN":"' ls_billdocitem-in_gstidentificationnumber '",'
*       '{"User_GSTIN":"20AACCC3707F1ZE",'
       '"Version": "1.01",'
       '"IRN": "",'
       '"SourceSystem": "SAP",'
       '"is_irn":"Y",'
       '"is_ewb":"N",'
       '"email": "",'
       INTO lv_hdr.

      ENDIF.
      """"""""""""""""""TMG will be maintained""""""""""""""""""""""""""""""""""""

      IF ls_billdoc_n-billtopartycountry <> 'IN'.
        IF ls_billingdoc-totaltaxamount > 0.
          ls_billdoc-cattrxn = 'EXPWP'.
        ELSE.
          ls_billdoc-cattrxn = 'EXPWOP'.
        ENDIF.
      ENDIF.
      IF ls_taxclass-customertaxclassification = '3' OR ls_taxclass-customertaxclassification = '6'.
        IF ls_billingdoc-totaltaxamount > 0.
          ls_billdoc-cattrxn = 'SEZWP'.
        ELSE.
          ls_billdoc-cattrxn = 'SEZWOP'.
        ENDIF.
      ENDIF.
      IF ls_taxclass-customertaxclassification = '4'.
        ls_billdoc-cattrxn = 'DEXP'.
      ENDIF.

      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      DATA: lv_typ TYPE string.
      IF ls_billdoc-billtopartygstin <> ls_billdoc-shiptopartygstin.
        lv_typ = 'SHP'.
      ELSE.
        lv_typ = 'REG'.
      ENDIF.
      CONDENSE: lv_typ.

      CONCATENATE '"TranDtls":{ '
                  '"TaxSch":"GST",'
                  '"SupTyp":"' ls_billdoc-cattrxn '",'
                  '"RegRev":"N",'
                  '"SubTypeDescription":"Others",'
                  '"SubType":"' ls_billdoc-subtype '",'
                  "'"Typ":"REG",'
                  '"Typ":"' lv_typ '",'
                  '"OutwardInward":"' ls_billdoc-supplytext '",'
                  '"EcmGstin":"",'
                  '"IgstOnIntra":"",'
                  '"DiffPercentage": "0.00",'
                  '"Taxability": "Taxable",'
                  '"InterIntra": "",'
                  '"CancelFlag": "",'
                  '"CnlRsn": "",'
                  '"CnlRem": ""'
              ' },' INTO lv_docdtls.

      DATA(lv_bil) = |{ ls_billdoc-billingdocument ALPHA = OUT }|.
      lv_bil = condense( val  = lv_bil
                         from = ` `
                         to   = `` ).

      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      SELECT single * FROM
      zdt_gstrmap
      where blart = 'RV'
      and fkart = @ls_billdoc-BillingDocumentType
      into @data(ls_invtyp).

      CONCATENATE '"DocDtls":{'
                  ' "Typ":"' ls_invtyp-doctype '",'
                  ' "No":"' lv_bil '",'
                  ' "Dt":"' lv_vfdat '",'
                  '"ReasonForCnDn": ""'
                 '},' INTO lv_trandtls.

      FINAL(ls_companycode) = VALUE #( lt_companycode[ bukrs = ls_billdocitem-companycode ] OPTIONAL ).
      """"""""""""""""""TMG will be maintained""""""""""""""""""""""""""""""""""""
      DATA(lv_pin) = |"Pin": { ls_companycode-pincode },|.

      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      IF sy-sysid = 'PZJ' OR sy-sysid = 'A1S'.
        CONCATENATE ' "SellerDtls":{'
*                  '   "Gstin":"' ls_billdocitem-in_gstidentificationnumber'",'
                     '   "Gstin":"20AACCC3707F1ZE",'
                    '   "LglNm":"' ls_companycode-legalname'",' " ls_companycode-CompanyCodeName
                    '   "TrdNm":"' ls_companycode-legalname'",' " ls_companycode-CompanyCodeName
                    '   "Addr1":"' ls_companycode-address1 '",' " ls_companycode-CityName
                    '   "Addr2":"' ls_companycode-address2 '",' " ls_companycode-Country
                    '   "Loc":"' ls_companycode-city '",' " ls_companycode-CityName
                    lv_pin "'",'   "Pin": 392001 ,'
                    '   "Stcd": "20",'
                    '   "Ph": "",'
                    '   "Em":"",'
                    '"SupplierCode": ""'
                    ' },' INTO lv_sellerdtls.

      ELSE.
        CONCATENATE ' "SellerDtls":{'
      '   "Gstin":"' ls_billdocitem-in_gstidentificationnumber'",'
*                   '   "Gstin":"20AACCC3707F1ZE",'
      '   "LglNm":"' ls_companycode-legalname'",' " ls_companycode-CompanyCodeName
      '   "TrdNm":"' ls_companycode-legalname'",' " ls_companycode-CompanyCodeName
      '   "Addr1":"' ls_companycode-address1 '",' " ls_companycode-CityName
      '   "Addr2":"' ls_companycode-address2 '",' " ls_companycode-Country
      '   "Loc":"' ls_companycode-city '",' " ls_companycode-CityName
      lv_pin "'",'   "Pin": 392001 ,'
      '   "Stcd": "20",'
      '   "Ph": "",'
      '   "Em":"",'
      '"SupplierCode": ""'
      ' },' INTO lv_sellerdtls.
      ENDIF.

      """"""""""""""""""TMG will be maintained""""""""""""""""""""""""""""""""""""

      SELECT SINGLE * FROM i_buspartemailaddresstp_3
        WHERE businesspartner = @ls_billdoc-billtoparty
        INTO @FINAL(ls_email).

      DATA(lv_buyerstatecode) = VALUE char2( lt_state[ sapstatecode = ls_billdoc-billtopartystatecode ]-gststatecode OPTIONAL ).
      IF ls_billdoc_n-billtopartycountry <> 'IN'.
        ls_billdoc-billtopartygstin = 'URP'.
        lv_buyerstatecode = '96'.
      ENDIF.
      lv_pin = |"Pin": { ls_billdoc-billtopartypostalcode },|.
      IF ls_billdoc_n-billtopartycountry <> 'IN'.
        lv_pin = |"Pin": 999999,|.
      ENDIF.

      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
       " changed by siba
        data:billaddress1 type c leNGTH 100,
             billaddress2 type c leNGTH 100.
             if ls_billdoc-billtopartyaddress1 is not INITIAL.
             billaddress1 = ls_billdoc-billtopartyaddress1.
             endif.
             if ls_billdoc-billtopartyaddress2 is not INITIAL.
             billaddress2 = ls_billdoc-billtopartyaddress2.
             endif.

      CONCATENATE ' "BuyerDtls":{'
                  '    "Gstin":"' ls_billdoc-billtopartygstin '",' " ls_buyer-TaxNumber3
                  '    "LglNm":"' ls_billdoc-billtopartyname'",'
                  '    "TrdNm":"' ls_billdoc-billtopartyname '",'
                  '    "Pos":"' lv_buyerstatecode '",' " lv_statecode
                  '    "Addr1":"' billaddress1 '",'  " ls_billdoc-billtopartyaddress1
                  '    "Addr2":"' billaddress2 '",'  " ls_billdoc-billtopartyaddress2
                  '    "Loc":"' ls_billdoc-billtopartylocation '",'
                  lv_pin "'",'    "Pin": 560089 ,' " ls_buyer-PostalCode
                  '    "Stcd": "' lv_buyerstatecode '",' " lv_statecode
                  " '    "State": "' lv_statecode '",'
                  '    "Ph": "",'
                  '    "Em":"' ls_email-emailaddress '"'
                  ' },' INTO lv_buyerdtls.

      lv_pin = |"Pin": { ls_billdocitem-plantpincode },|.
      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      "SB Change
      IF sy-sysid = 'PZJ' OR sy-sysid = 'A1S'.
        CONCATENATE ' "DispDtls":{'
*                   '   "Gstin":"' ls_billdocitem-plantgstin '",' " ls_billtoparty-TaxNumber3
                       '   "Gstin": "20AACCC3707F1ZE",'
                     '   "Nm":"' ls_billdocitem-plantlegalname '",'
                     '   "Addr1":"' ls_billdocitem-plantaddress1 '",'
                     '   "Addr2":"' ls_billdocitem-plantaddress2 '",'
                     '   "Loc":"' ls_billdocitem-plantcity '",'
                    lv_pin "'   "Pin": 392001,' " ls_billtoparty-PostalCode
                     '   "Stcd": "20"' " lv_statecode
                    ' },' INTO lv_dispdtls.
      ELSE.
        CONCATENATE ' "DispDtls":{'
                          '   "Gstin":"' ls_billdocitem-plantgstin '",' " ls_billtoparty-TaxNumber3
*                     '   "Gstin": "20AACCC3707F1ZE",'
                          '   "Nm":"' ls_billdocitem-plantlegalname '",'
                          '   "Addr1":"' ls_billdocitem-plantaddress1 '",'
                          '   "Addr2":"' ls_billdocitem-plantaddress2 '",'
                          '   "Loc":"' ls_billdocitem-plantcity '",'
                         lv_pin "'   "Pin": 392001,' " ls_billtoparty-PostalCode
                          '   "Stcd": "20"' " lv_statecode
                         ' },' INTO lv_dispdtls.
      ENDIF.

*      CONCATENATE ' "DispDtls":{'
*                     '   "Gstin": "",'
*                   '   "Nm":"",'
*                   '   "Addr1":"",'
*                   '   "Addr2":"",'
*                   '   "Loc":"",'
*                   '   "Pin":"",'
*                   '   "Stcd": ""' " lv_statecode
*                  ' },' INTO lv_dispdtls.
      "SB Change
      IF ls_billdoc_n-billtopartycountry = 'IN'.
        lv_pin = |"Pin": { ls_billdoc-shiptopartypostalcode },|.
        lv_buyerstatecode = VALUE char2( lt_state[ sapstatecode = ls_billdoc-shiptopartystatecode ]-gststatecode OPTIONAL ).

        " ---------------------------------------------------------------------
        " ---------------------------------------------------------------------

        " changed by siba
        data:shipaddress1 type c leNGTH 100,
             shipaddress2 type c leNGTH 100.
             if ls_billdoc-shiptopartyaddress1 is not INITIAL.
             shipaddress1 = ls_billdoc-shiptopartyaddress1.
             endif.
             if ls_billdoc-shiptopartyaddress2 is not INITIAL.
             shipaddress2 = ls_billdoc-shiptopartyaddress2.
             endif.


        CONCATENATE ' "ShipDtls":{'
        '   "Gstin":"' ls_billdoc-shiptopartygstin '",' " ls_billtoparty-TaxNumber3
                    '   "LglNm":"' ls_billdoc-shiptopartyname '",'
                      '   "TrdNm":"' ls_billdoc-shiptopartyname '",'
                    '   "Addr1":"' shipaddress1 '",'     """"      '   "Addr1":"' shiptopartyaddress1 '",'
                    '   "Addr2":"' shipaddress2 '",'     """"     '   "Addr2":"' ls_billdoc-shiptopartyaddress2 '",'
                    '   "Loc":"' ls_billdoc-shiptopartylocation '",' " ls_billtoparty-CityName
                    lv_pin "'   "Pin": 560089,'
                    '   "Stcd": "' lv_buyerstatecode '"'
                      "'   "Gstin":"' ls_billtoparty-TaxNumber3 '",'
                      '},' INTO lv_shipdtls.
      ELSE.
        lv_pin = |"Pin": { ls_billdocitem-buyerpincode },|.
        lv_buyerstatecode = VALUE char2( lt_state[ sapstatecode = ls_billdocitem-statecode ]-gststatecode OPTIONAL ).

        " ---------------------------------------------------------------------
        " ---------------------------------------------------------------------
        CONCATENATE ' "ShipDtls":{'
         '   "Gstin":"' ls_billdocitem-portgst '",' " ls_billtoparty-TaxNumber3
                     '   "LglNm":"' ls_billdocitem-portname '",'
                       '   "TrdNm":"' ls_billdocitem-portname '",'
                     '   "Addr1":"' ls_billdocitem-addressport '",'
                     '   "Addr2":"' ls_billdocitem-addressport '",'
                     '   "Loc":"' ls_billdocitem-portcity '",' " ls_billtoparty-CityName
                     lv_pin "'   "Pin": 560089,'
                     '   "Stcd": "' lv_buyerstatecode '"'
                       "'   "Gstin":"' ls_billtoparty-TaxNumber3 '",'
                       '},' INTO lv_shipdtls.
      ENDIF.

      CLEAR: lv_diffgstn.
      IF ls_billdoc-billtopartygstin <> ls_billdoc-shiptopartygstin.
        lv_diffgstn = 'X'.
      ENDIF.
      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      CONCATENATE ' "AddlDocDtls": [{'
                      '   "Url": "http://google.com",'                       " http://google.com" ,                            '
                      '  "Docs": "dljshdiuewhjkdsjhdusohdsauohajk",'                       " dljshdiuewhjkdsjhdusohdsauohajk",              '
                      '  "Info": "dljshduihue480u042oh2ouodn984io2ouh9823h0uh32"'                       " dljshduihue480u042oh2ouodn984io2ouh9823h0uh32" '
                 ' } ]' INTO lv_addldocdtls.

      """""""""Added for Export"""""""""""""""""""""""""""
      IF ls_billdocitem-billtopartycountry <> 'IN'.

        " ---------------------------------------------------------------------
        " ---------------------------------------------------------------------
        CONCATENATE ',"ExpDtls":[ {'
                      '"ShipBNo":"",'
                      '"ShipBDt":"' lv_vfdat '",'
                    '"Port":"' ls_billdocitem-portcode '",'
                    '"RefClm":"Y",'
                    '"ForCur":"' ls_billdocitem-transactioncurrency '",'
                    '"expcat": "",'
                    '"wfhpay": "",'
                    '"invforcur": "",'
                    '"expduty": "",'
                    '"CntCode":"IN"'
                    "'"ExpDuty":""'
                  '  } ]' INTO lv_expdtls.
      ELSE.

        CONCATENATE ',"ExpDtls": [ {'
                        '"ShipBNo":"",'
                        '"ShipBDt":"",'
                      '"Port":"",'
                      '"RefClm":"",'
                      '"ForCur":"",'
                      '"expcat": "",'
                      '"wfhpay": "",'
                      '"invforcur": "",'
                      '"expduty": "",'
                      '"CntCode":""'
                      "'"ExpDuty":""'
                    '  } ]' INTO lv_expdtls.

      ENDIF.

      """""""""Added for Export"""""""""""""""""""""""""""
      val_totinvval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-materialvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-totalgstvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-cessvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-tcsvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-roundoffvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-discountvalue ).
      val_tot_fc = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-materialvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-totalgstvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-cessvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-tcsvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-roundoffvalue ) +
                                                REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-discountvalue ). " ls_billdoc-TotalNetAmount + ls_billdoc-TotalTaxAmount.

      val_igstval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                WHERE ( billingdocument = ls_keys-billingdocument )
                                                NEXT i = i + ls_i-igstvalue ).
      val_cgstval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                              WHERE ( billingdocument = ls_keys-billingdocument )
                              NEXT i = i + ls_i-cgstvalue ).
      val_sgstval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                    WHERE ( billingdocument = ls_keys-billingdocument )
                    NEXT i = i + ls_i-sgstvalue ).

      val_assval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                  WHERE ( billingdocument = ls_keys-billingdocument )
                                  NEXT i = i + ls_i-materialvalue ) + REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                  WHERE ( billingdocument = ls_keys-billingdocument )
                                  NEXT i = i + ls_i-discountvalue ).

      val_cesval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                    WHERE ( billingdocument = ls_keys-billingdocument )
                                    NEXT i = i + ls_i-cessvalue ).

*      DATA: lv_roffv_dec TYPE dmbtr. " CHANGE BY OMKAR
DATA : LV_RODOF TYPE dmbtr.
      LV_RODOF = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                    WHERE ( billingdocument = ls_keys-billingdocument )
                                    NEXT i = i + ls_i-roundoffvalue ).

      lv_discount = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                          WHERE ( billingdocument = ls_keys-billingdocument )
                                          NEXT i = i + ls_i-discountvalue ).

      IF LV_RODOF < 0.
        lv_roffv = LV_RODOF * -1.
        CONDENSE lv_roffv.
        lv_roffv = |-| && lv_roffv.
      ELSE.
        lv_roffv = LV_RODOF.
      ENDIF.
      CONDENSE lv_roffv.

      " val_assval = '90.0'.
      " val_igstval = '16.20'.
      " val_totinvval = '106.20'.
      " val_tot_fc = '106.20'.

      CONCATENATE '"ValDtls":{'
            '  "AssVal":' val_assval ','
             ' "CgstVal":' val_cgstval ','
             ' "SgstVal":' val_sgstval ','
              '"IgstVal":' val_igstval ','
              '"CesVal":' val_cesval ','
              '"StCesVal":' val_stcesval ','
              '"CesNonAdVal": "0.00",'
              "'"RndOffAmt":' lv_roffv ','
*              '"rndoffamt":' lv_roffv ','
              '"roundoffamt": ' lv_roffv ','
             ' "TotInvVal":' val_totinvval ','
             ' "TotInvValFc": ' val_tot_fc ','
             ' "Discount": ' lv_discount ','
             ' "OthChrg": ' val_othchrg ''
          ' },' INTO lv_valdtls.


      SELECT SINGLE * FROM zdt_gstrmap
        WHERE fkart = @ls_billdoc-billingdocumenttype
        INTO @FINAL(ls_gstmap).

      FINAL(lv_date) = |"{ ls_billdoc-transporterdocumentdate+6(2) }/{ ls_billdoc-transporterdocumentdate+4(2) }/{ ls_billdoc-transporterdocumentdate+0(4) }"|.
      IF ls_gstmap-ewayind = 'X'.

        IF ls_billdoc-billingdocumenttype = 'F2'.
          IF ( ls_billdoc-salesorganization = '1000' AND ls_billdoc-distributionchannel = '10' AND ls_billdoc-division = '08' ) OR
             ( ls_billdoc-salesorganization = '2000' AND ls_billdoc-distributionchannel = '10' AND ls_billdoc-division = '08' ) OR
             ( ls_billdoc-salesorganization = '3000' AND ls_billdoc-distributionchannel = '10' AND ls_billdoc-division = '08' ) OR
             ( ls_billdoc-salesorganization = '4000' AND ls_billdoc-distributionchannel = '10' AND ls_billdoc-division = '08' ).

**********************


            CONCATENATE ' , "EwbDtls": [ {'
         '"is_ewb": "N",'
         '"SubType": "",'
         '"TransId": "",'
        ' "Distance": 0,'
*        ' "Distance": "'  lv_distance '",'
        ' "TransName": "",'
        ' "TransMode": "' ls_billdoc-modeoftransport '",'
        ' "TransDocNo": "",'
         '"TransDocDt": "",'
        ' "VehNo": "' ls_billdoc-vehiclenumber '",'
         '"VehType": ""'
     '} ]' INTO lv_ewbdtl.

          ELSE.

            IF    ls_billdoc-trasnportergstin        IS INITIAL
               OR ls_billdoc-transporterdocumentdate IS INITIAL
               OR ls_billdoc-modeoftransport IS INITIAL
               OR ls_billdoc-vehiclenumber           IS INITIAL.

              DATA(lv_msg15) = |Transporter Details are mandatory field|.

              APPEND VALUE #( %tky        = ls_keys-%tky
                              %state_area = 'Validate_Head'
                              %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = lv_msg15 ) )
                     TO reported-head.

              APPEND VALUE #( %tky = ls_keys-%tky )
                     TO failed-head.
            ENDIF.
DATA lv_distance TYPE string.
lv_distance = ls_billdoc-distance.
            CONCATENATE ' , "EwbDtls": [ {'
            '"is_ewb": "Y",'
            '"SubType": "1",'
            '"TransId": "' ls_billdoc-trasnportergstin '",'
*           ' "Distance": 0,'
            ' "Distance": "' lv_distance '",'
           ' "TransName": "' ls_billdoc-transportername '",'
           ' "TransMode": "' ls_billdoc-modeoftransport '",'
           ' "TransDocNo": "' ls_billdoc-transporterdocumentnumber '",'
            '"TransDocDt": ' lv_date ','
           ' "VehNo": "' ls_billdoc-vehiclenumber '",'
            '"VehType": "R"' "ls_billdoc-vehicletype '"'
        '} ]' INTO lv_ewbdtl.
          ENDIF.
        ENDIF.

      ELSE.
        CONCATENATE ' , "EwbDtls": [ {'
     '"is_ewb": "N",'
     '"SubType": "",'
     '"TransId": "",'
    ' "Distance": 0,'
*    ' "Distance": "'  lv_distance '",'
    ' "TransName": "",'
    ' "TransMode": "",'
    ' "TransDocNo": "",'
     '"TransDocDt": "",'
    ' "VehNo": "",'
     '"VehType": ""'
 '} ]' INTO lv_ewbdtl.
      ENDIF.
      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------

      " Remove unnecessary fields

      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      CONCATENATE '"RefDtls":{'
                  '  "InvRm":"' '",'
                  '  "InvStDt":"'  '",'
                  '  "InvEndDt":"' '",'
                  ' "PrecDocDtls": [ {          '
                  ' "DocPerdDtls_InvStDt": "' '",'
                  ' "DocPerdDtls_InvEndDt": "' '",'
                  ' "InvNo": "' '",'
                  ' "InvDt": "' '",'
                  ' "OthRefNo": "' space '"  '
                  '   } ],        '

                   ' "ContrDtls": [  {            '
                   ' "RecAdvRefr": "' space '", '
                   ' "RecAdvDt": "' space '",    '
                   ' "TendRefr": "' space '",     '
                   ' "ContrRefr": "' space '",  '
                   ' "ExtRefr": "' space '",     '
                   ' "ProjRefr": "' space '",  '
                   ' "PORefr": "'  '",'
                   ' "PORefDt":"'  '"'
                   ' }  ] },  ' INTO lv_refdtls.

      " ---------------------------------------------------------------------
      " ---------------------------------------------------------------------
      CONCATENATE '"PayDtls":{'
                  '  "Nam":"' space '",'
                  '  "Mode":"' space '",'
                  '  "FinInsBr":"' space '",'
                  '  "AccDet": "' space '" ,'
                  '  "PayTerm":"' space '",'
                  '  "PayInstr":"' space '",'
                  '  "CrTrn":"' space '",'
                  '  "DirDr":"' space '",'
                  '  "CrDay":"' space '",'
                  '  "PaidAmt":"' space '",'
                  '  "PaymtDue":"' space '"'
                  '  },' INTO lv_paydtls.

      DATA: lv_roffv_dec  TYPE dmbtr,
            lv_roffv_char TYPE char20.

      lv_itemlists = ' "ItemList":['.
      LOOP AT lt_billdocitem INTO DATA(wa_data) WHERE billingdocument = ls_keys-billingdocument.

        FINAL(lv_uom_u) = VALUE #( lt_uom[ sapuom = wa_data-billingquantityunit ]-gstuom OPTIONAL ).  "new one
*        FINAL(lv_uom) = VALUE #( lt_uom[ sapuom = wa_data-billingquantityunit ]-gstuom OPTIONAL ).      old one
""New Logic Added by SAR Tech Team 21.05.2026......
        if lv_uom_u = 'KGM'.
            DATA(lv_uom) = 'KGS'.
        ELSE.
            lv_uom =  lv_uom_u .
        ENDIF.

        SELECT SINGLE consumptiontaxctrlcode
          FROM i_productplantbasic
          WHERE product = @wa_data-product AND plant = @wa_data-plant
          INTO @FINAL(lv_hsn).
        lv_qty = wa_data-billingquantity.
        lv_unitp = wa_data-materialbasevalue.
        IF wa_data-discountvalue < 0.
          SHIFT lv_dismt LEFT DELETING LEADING space.
          lv_dismt = wa_data-discountvalue * -1.

        ELSE.
          lv_dismt = wa_data-discountvalue.
        ENDIF.

        val_totinvval = wa_data-materialvalue.
        lv_totrt = wa_data-totalgstrate.

        lv_igstm = wa_data-igstvalue.
        lv_cgstm = wa_data-cgstvalue.
        lv_sgstm = wa_data-sgstvalue.
*        lv_invmt = 10620 / 100.

        DATA: val_othchrg_item_dec TYPE dmbtr.
        "val_othchrg_item_dec = wa_data-tcsvalue + wa_data-roundoffvalue.
        lv_schmt = wa_data-tcsvalue."+ wa_data-roundoffvalue.

        CLEAR: lv_roffv_dec, lv_roffv_char.
        lv_roffv_dec = wa_data-roundoffvalue.
        IF lv_roffv_dec < 0.
          lv_roffv_char = lv_roffv_dec * -1.
          CONDENSE lv_roffv_char.
          lv_roffv_char = |-| && lv_roffv_char.
        ELSE.
          lv_roffv_char = lv_roffv_dec.
        ENDIF.
        CONDENSE lv_roffv_char.

        "lv_cesrt = wa_data-cessbasevalue.
        "lv_stcess = wa_data-cessvalue.
        lv_cessm = wa_data-cessvalue.
        lv_ass = wa_data-materialvalue + wa_data-discountvalue.
        wa_data-slno = |{ wa_data-slno ALPHA = OUT }|.
        lv_igstt = wa_data-igstrate.
        lv_cgstt = wa_data-cgstrate.
        lv_sgstt = wa_data-sgstrate.
        "lv_stcna = wa_data-cessvalue.

        lv_invmt = wa_data-materialvalue + wa_data-discountvalue + lv_igstm + lv_sgstm + lv_cgstm + lv_schmt + lv_cessm + lv_roffv_dec.

        CLEAR lv_hsdat.
        CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4) INTO lv_hsdat SEPARATED BY '/'.
        IF wa_data-batch IS NOT INITIAL.
          CONCATENATE '   "BchDtls": {            '
                  '   "Nm"    : "' wa_data-batch '",'
                  '   "ExpDt" :  "' lv_vfdat '",'
                  '   "WrDt"  : "' lv_vfdat '" ' INTO DATA(lv_batch).
        ELSE.
          CONCATENATE '   "BchDtls": {            '
                  '   "Nm"    : "' '",'
                  '   "ExpDt" :  "' '",'
                  '   "WrDt"  : "' '" ' INTO lv_batch.
        ENDIF.

        IF lv_ind = 'X'.
          lv_itemlist = lv_itemlist && ','.
        ENDIF.
        lv_ind = 'X'.

*        IF val_othchrg_item_dec < 0.
*          lv_schmt = val_othchrg_item_dec * -1.
*          CONDENSE lv_schmt.
*          lv_schmt = |-| && lv_schmt.
*        ELSE.
*          lv_schmt = val_othchrg_item_dec.
*        ENDIF.
        CONDENSE lv_schmt.

        " ---------------------------------------------------------------------
        " ---------------------------------------------------------------------
        CONCATENATE
                '   {'
                '    "SlNo": "' wa_data-slno '",'
                '    "OrdLineRef": "' wa_data-slno '",'
                '    "PrdSlNo":  "",'                       " PDSL0001
                '    "ItemCode":"",'                        " IC1001
                '    "PrdNm":"' wa_data-product '",'
                '    "PrdDesc":"' wa_data-productname '",'
                '    "HsnCd":"' lv_hsn '",'
                "'    "IsServc": "' wa_data-gdser '" ,'
                '    "BarCde":"",'
                '    "Qty":' lv_qty','
                '    "FreeQty":' lv_qty ','
                '    "Unit":"' lv_uom '",'
                '    "UnitPrice":' lv_unitp ','
                '    "TotAmt":' val_totinvval ','
                '    "Discount":' lv_dismt ','
                '    "OthChrg":' lv_schmt ','
                '    "PreTaxVal":' lv_pretax ','                " lv_dmbtr
                '    "AssAmt":' lv_ass ','
                '    "GstRt":' lv_totrt ','
                '    "CesRt":' lv_cesrt ','
                '    "IgstRt": ' lv_igstt ','
                '    "CgstRt": ' lv_cgstt ','
                '    "SgstRt": ' lv_sgstt ','
                '    "StateCesRt": 0,' "lv_cesrt ','
                '    "IgstAmt":' lv_igstm ','
                '    "CgstAmt":' lv_cgstm ','
                '    "SgstAmt":' lv_sgstm ','
                '    "CessAmt":' lv_stcna ','               " Changed for EINV CR2
                '    "CesNonAdvlAmt":' lv_cessm ','        " Changed for EINV CR2
                '    "StateCesAmt": 0,' "lv_stcess ','         " Changed for EINV CR2
                '    "StateCesNonAdvlAmt":' lv_stcessm ',' " Changed for EINV CR2
                '    "TotItemVal":' lv_invmt ','
                '    "rndoffamt":' lv_roffv_char ','
                lv_batch
                "'   "BchDtls": {            '
                "'   "Nm"    : "' wa_data-Batch '",'
                "'   "ExpDt" :  "' lv_vfdat '",'
                "'   "WrDt"  : "' lv_vfdat '" '
                "'},'
                ','
                ' "AttribDtls": ['
                '{ '
                 ' "Nm"   : "' space '", '
                  '  "Val" : "' space '"   '
                  ' }]'
                  '}'
'} '
                 INTO lv_itemlist1.
        CONCATENATE lv_itemlist lv_itemlist1 INTO lv_itemlist.
        CLEAR lv_batch.
      ENDLOOP.
      len = strlen( lv_itemlist ).
      len -= 1.
      lv_payload3 = lv_itemlist. "(len).
      lv_end_line = '],'.
      lv_end = ' }   '.

      CONCATENATE lv_hdr
                lv_trandtls
                lv_docdtls
                lv_sellerdtls
                lv_buyerdtls
                lv_dispdtls
                lv_shipdtls
                lv_itemlists
                lv_payload3
                lv_end_line
                lv_valdtls
                lv_paydtls
                lv_refdtls
                lv_addldocdtls
                lv_expdtls
                lv_transportdtls
                lv_expdtls
                lv_ewbdtl
                lv_end INTO lv_json.

      SELECT SINGLE billingdocument,
                    billingdocumentiscancelled
      FROM i_billingdocument
      WHERE billingdocument = @ls_billdoc-billingdocument
      INTO @DATA(ls_billingdocument).
      IF ls_billingdocument-billingdocumentiscancelled IS NOT INITIAL.

        lv_msg15 = |Billing Document is cancelled|.

        APPEND VALUE #( %tky        = ls_keys-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg15 ) )
               TO reported-head.

        APPEND VALUE #( %tky = ls_keys-%tky )
               TO failed-head.
      ENDIF.

      SELECT SINGLE * FROM i_billingdocument
    WHERE billingdocument = @ls_billdoc-billingdocument
    INTO @DATA(ls_bill).

      SELECT SINGLE * FROM zdt_header_token
      WHERE company = @ls_bill-companycode
      INTO @DATA(ls_headtkn).

      lv_gid = ls_headtkn-gstin.
      lv_gid1 = ls_headtkn-clientid.
      IF failed-head IS INITIAL.
        TRY.
            FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                        comm_scenario = 'ZCOMM_GENIRN'
                                        service_id    = 'ZOS_GENIRN_REST' ).
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).

            lo_request->set_header_field( i_name  = 'Clientcode'
                                        i_value = lv_gid1 ).
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = lv_gid ).
            lo_request->set_header_field( i_name  = 'SHP'
                                          i_value = lv_diffgstn ).
            lo_request->set_text( lv_json ).
            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.
      ENDIF.

      IF ls_result IS NOT INITIAL.
        SELECT SINGLE * FROM zdt_einveway
          WHERE vbeln = @ls_billdoc-billingdocument
          INTO @ls_save.
*        SPLIT ls_result AT '"status":"1"' INTO TABLE FINAL(lt_tab1).
        IF ls_result CS '"error":[{"error_code"'.

          " TODO: variable is assigned but never used (ABAP cleaner)
          APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
          SELECT MAX( item ) FROM zdt_error_log
            WHERE billdoc = @ls_billdoc-billingdocument
            INTO @FINAL(lv_max).
          lv_p = lv_max.

          SPLIT ls_result AT '"error_desc":"' INTO TABLE FINAL(lt_msg).

          LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
            IF <fs_msg> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.
            SPLIT <fs_msg> AT 'Index' INTO TABLE FINAL(lt_msg1).
            FINAL(lv_msg) = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
            ls_error-billdoc = ls_billdoc-billingdocument.
            ls_error-item    = lv_p1.
            lv_p1 += 1.
            ls_error-message = lv_msg.
            ls_error-logdate = sy-datum.
            ls_error-logtime = sy-uzeit.
            APPEND ls_error TO lt_error.
            CLEAR ls_error.
          ENDLOOP.

          DELETE lt_error WHERE item = '00000'.
          MODIFY zdt_error_log FROM TABLE @lt_error.

        ELSE.

          SPLIT ls_result AT 'data":{"irn":"' INTO TABLE FINAL(lt_split01).
          FINAL(ls_split) = VALUE #( lt_split01[ 2 ] OPTIONAL ).

          SPLIT ls_split AT '","ack_no":"' INTO TABLE FINAL(lt_split02).
          FINAL(lv_irn) = VALUE #( lt_split02[ 1 ] OPTIONAL ).

          FINAL(ls_split2) = VALUE #( lt_split02[ 2 ] OPTIONAL ).

          SPLIT ls_split2 AT '","ack_dt":"' INTO TABLE FINAL(lt_split03).
          FINAL(lv_ackno) = VALUE #( lt_split03[ 1 ] OPTIONAL ).

          FINAL(lv_ackndatevar) = VALUE #( lt_split03[ 2 ] OPTIONAL ).
          DATA(lv_ackdate) = |{ lv_ackndatevar+0(19) }|.

          SPLIT ls_result AT '"signed_qrcode":"' INTO TABLE FINAL(lt_split04).
          FINAL(ls_split3) = VALUE #( lt_split04[ 2 ] OPTIONAL ).

          SPLIT ls_split3 AT '","document_type"' INTO TABLE FINAL(lt_split05).
          FINAL(lv_signed) = VALUE #( lt_split05[ 1 ] OPTIONAL ).

          SPLIT ls_result AT '"eway_bill_no":"' INTO TABLE FINAL(lt_split06).
          FINAL(ls_split4) = VALUE #( lt_split06[ 2 ] OPTIONAL ).

          SPLIT ls_split4 AT '","eway_bill_date":"' INTO TABLE FINAL(lt_split07).
          FINAL(lv_eway) = VALUE #( lt_split07[ 1 ] OPTIONAL ).
          FINAL(lv_ewaydate) = VALUE #( lt_split07[ 2 ] OPTIONAL ).
          IF lv_ewaydate IS NOT INITIAL.
            lv_dateeway = |{ lv_ewaydate+0(19) }|.
          ENDIF.

          SPLIT lv_ewaydate AT '"valid_upto":"' INTO TABLE FINAL(lt_split08).
          DATA(lv_validtillstring) = VALUE #( lt_split08[ 2 ] OPTIONAL ).
          IF lv_validtillstring IS NOT INITIAL.
            lv_validtill = |{ lv_validtillstring+0(19) }|.
          ENDIF.

          ls_save-ackno        = lv_ackno.
          ls_save-ackdate        = lv_ackdate.
          ls_save-signedqrcode = lv_signed.
          ls_save-irn          = lv_irn.
          ls_save-erdat        = sy-datum.
          ls_save-erzet        = sy-uzeit.
          ls_save-irnflag      = 'X'.
          IF ls_gstmap-ewayind = 'X'.
            ls_save-ewayflag = 'X'.
          ENDIF.
          ls_save-irncancflag = ' '.
          IF lv_dateeway IS NOT INITIAL.
            ls_save-eway     = lv_eway.
            ls_save-ewaydate = lv_dateeway.
            ls_save-ewayvaliditydate = lv_validtill.
          ENDIF.
          ls_save-vbeln = ls_billdoc-billingdocument.

          MODIFY zdt_einveway FROM @ls_save.
          CLEAR ls_save.

        ENDIF.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
         ENTITY head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

  METHOD eway.
    DATA lv_vfdat       TYPE c LENGTH 10.
    DATA lv_transporter TYPE c LENGTH 10.
    DATA lv_json        TYPE string.
    DATA val_totinvval  TYPE text25                VALUE 0.
    DATA val_igstval    TYPE text25                VALUE 0.
    DATA val_cgstval    TYPE text25                VALUE 0.
    DATA val_sgstval    TYPE text25                VALUE 0.
    DATA val_assval     TYPE text25                VALUE 0.
    DATA val_cesval     TYPE text25                VALUE 0.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_qty         TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_unitp       TYPE text25                VALUE 0.
    DATA lv_dismt       TYPE text25                VALUE 0.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_totrt       TYPE text20                VALUE 0.
    DATA lv_igstm       TYPE text25                VALUE 0.
    DATA lv_cgstm       TYPE text25                VALUE 0.
    DATA lv_sgstm       TYPE text25                VALUE 0.
    DATA lv_cesrt       TYPE text20                VALUE 0.
    DATA lv_ass         TYPE text25                VALUE 0.
    DATA lv_igstt       TYPE text20                VALUE 0.
    DATA lv_cgstt       TYPE text20                VALUE 0.
    DATA lv_sgstt       TYPE text20                VALUE 0.
    DATA lv_stcna       TYPE text20                VALUE 0.
    DATA lv_item        TYPE char10.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_invmt       TYPE text25                VALUE 0.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_invmt1      TYPE text25                VALUE 0.
    DATA lv_gid1        TYPE string.
    DATA lv_gid         TYPE string.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_gid2        TYPE string.
    DATA ls_save        TYPE zdt_einveway.
    DATA lt_error       TYPE STANDARD TABLE OF zdt_error_log.
    DATA ls_error       TYPE zdt_error_log.
    DATA lv_p1          TYPE char10.
    DATA lv_p           TYPE p LENGTH 8 DECIMALS 0.
    SELECT * FROM zdt_token
      " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
      INTO TABLE @FINAL(lt_parm).

    SELECT * FROM zdt_gstrmap
      INTO TABLE @FINAL(lt_gstmap).
    IF keys IS NOT INITIAL.
      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).
      IF sy-subrc IS INITIAL.
        SELECT * FROM zr_einveway_v1
          FOR ALL ENTRIES IN @keys
          WHERE billingdocument = @keys-billingdocument
          INTO TABLE @FINAL(lt_billdocitem).
      ENDIF.
    ENDIF.
    SELECT * FROM zdt_state_code1
      INTO TABLE @FINAL(lt_state).
    SELECT * FROM zdt_ccodeaddress
      " TODO: variable is assigned but never used (ABAP cleaner)
      INTO TABLE @FINAL(lt_companycode).
    SELECT * FROM zdt_uom
      INTO TABLE @FINAL(lt_uom).
    SELECT * FROM zdt_portcode
   " TODO: variable is assigned but never used (ABAP cleaner)
      INTO TABLE @FINAL(lt_port).

    LOOP AT keys INTO FINAL(ls_key).

      FINAL(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
      FINAL(ls_billdocitem) = VALUE #( lt_billdocitem[ billingdocument = ls_key-billingdocument ] OPTIONAL ).
      FINAL(ls_gstmap) = VALUE #( lt_gstmap[ fkart = ls_billdoc-billingdocumenttype ] OPTIONAL ).

      CLEAR lv_vfdat.
      CONCATENATE ls_billdoc-billingdocumentdate+6(2) ls_billdoc-billingdocumentdate+4(2) ls_billdoc-billingdocumentdate(4) INTO lv_vfdat SEPARATED BY '/'.
      CLEAR lv_transporter.
      CONCATENATE ls_billdoc-transporterdocumentdate+6(2) ls_billdoc-transporterdocumentdate+4(2) ls_billdoc-transporterdocumentdate(4) INTO lv_transporter SEPARATED BY '/'.
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(lv_buyerstatecode) = VALUE char2( lt_state[ sapstatecode = ls_billdoc-shiptopartystatecode ]-gststatecode OPTIONAL ).
      IF ls_gstmap-irnind IS NOT INITIAL. " Billing Invoice

        lv_json = ' [ { '.
        lv_json = |{ lv_json } "Irn": "{ ls_billdoc-irn }", |.
        lv_json = |{ lv_json } "TransId": "{ ls_billdoc-trasnportergstin }", |.
        lv_json = |{ lv_json } "TransName": "{ ls_billdoc-transportername }",   |.
        lv_json = |{ lv_json } "TransMode": "{ ls_billdoc-modeoftransport }", |.
        lv_json = |{ lv_json } "Distance": 0, |.
*        lv_json = |{ lv_json } "Distance": "{ ls_billdoc-distance }", |.
        lv_json = |{ lv_json } "TransDocNo": "{ ls_billdoc-transporterdocumentnumber }", |.
        lv_json = |{ lv_json } "TransDocDt": "{ lv_transporter }", |.
        lv_json = |{ lv_json } "VehNo": "{ ls_billdoc-vehiclenumber }", |.
        lv_json = |{ lv_json } "VehType": "{ ls_billdoc-vehicletype }", |.

        lv_json = |{ lv_json } "DispDtls": |.
        lv_json = |{ lv_json } \{|.
        lv_json = |{ lv_json } "Nm": "{ ls_billdocitem-plantlegalname }", |.
        lv_json = |{ lv_json } "Addr1": "{ ls_billdocitem-plantaddress1 }", |.
        lv_json = |{ lv_json } "Addr2": "{ ls_billdocitem-plantaddress2 }", |.
        lv_json = |{ lv_json } "Loc": "{ ls_billdocitem-plantcity }", |.
        lv_json = |{ lv_json } "Pin": { ls_billdocitem-plantpincode }, |.
        lv_json = |{ lv_json } "Stcd": "{ ls_billdocitem-plantstatecode }" |.
        lv_json = |{ lv_json }\} \} ]|.

      ELSE. " PROFORMA INVOICE

        IF    ls_billdoc-trasnportergstin        IS INITIAL
           OR ls_billdoc-transporterdocumentdate IS INITIAL
           OR ls_billdoc-modeoftransport IS INITIAL
           OR ls_billdoc-vehiclenumber           IS INITIAL.

          DATA(lv_msg14) = |Transporter Details are mandatory field|.

          APPEND VALUE #( %tky        = ls_key-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg14 ) )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_key-%tky )
                 TO failed-head.
        ENDIF.

        val_totinvval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                       WHERE ( billingdocument = ls_key-billingdocument )
                                                       NEXT i = i + ls_i-materialvalue ) +
                                                       REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                       WHERE ( billingdocument = ls_key-billingdocument )
                                                       NEXT i = i + ls_i-totalgstvalue ) +
                                                       REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                       WHERE ( billingdocument = ls_key-billingdocument )
                                                       NEXT i = i + ls_i-cessvalue ) -
                                                       REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                                       WHERE ( billingdocument = ls_key-billingdocument )
                                                       NEXT i = i + ls_i-discountvalue ).
        val_igstval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                          WHERE ( billingdocument = ls_key-billingdocument )
                                          NEXT i = i + ls_i-igstvalue ).
        val_cgstval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                WHERE ( billingdocument = ls_key-billingdocument )
                                NEXT i = i + ls_i-cgstvalue ).
        val_sgstval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                      WHERE ( billingdocument = ls_key-billingdocument )
                      NEXT i = i + ls_i-sgstvalue ).

        val_assval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                    WHERE ( billingdocument = ls_key-billingdocument )
                                    NEXT i = i + ls_i-materialvalue ).
        val_cesval = REDUCE dmbtr( INIT i TYPE dmbtr FOR ls_i IN lt_billdocitem
                                      WHERE ( billingdocument = ls_key-billingdocument )
                                      NEXT i = i + ls_i-cessvalue ).

        CLEAR lv_vfdat.
        CONCATENATE ls_billdoc-billingdocumentdate+6(2) ls_billdoc-billingdocumentdate+4(2) ls_billdoc-billingdocumentdate(4) INTO lv_vfdat SEPARATED BY '/'.

        CLEAR lv_transporter.
        CONCATENATE ls_billdoc-transporterdocumentdate+6(2) ls_billdoc-transporterdocumentdate+4(2) ls_billdoc-transporterdocumentdate(4) INTO lv_transporter SEPARATED BY '/'.
        lv_json = '{'.
        lv_json = |{ lv_json } "action": "GENEWAYBILL", |.
        lv_json = |{ lv_json } "data": |.
        lv_json = |{ lv_json }\{|.
        lv_json = |{ lv_json } "supplyType": "O", |.
        lv_json = |{ lv_json } "subSupplyType": "1", |.
        lv_json = |{ lv_json } "subSupplyDesc": "", |.
        lv_json = |{ lv_json } "docType": "INV", |.
        lv_json = |{ lv_json } "docNo": "{ ls_billdoc-billingdocument }", |.
        lv_json = |{ lv_json } "docDate": "{ lv_vfdat }", |.
        IF sy-sysid = 'PZJ' OR sy-sysid = 'A1S'.
          lv_json = |{ lv_json } "fromGstin": "20AACCC3707F1ZE", |.
        ELSE.
          lv_json = |{ lv_json } "fromGstin": "{ ls_billdocitem-plantgstin }", |.
        ENDIF.
        lv_json = |{ lv_json } "fromTrdName": "{ ls_billdocitem-plantlegalname }", |.
        lv_json = |{ lv_json } "fromAddr1": "{ ls_billdocitem-plantaddress1 }", |.
        lv_json = |{ lv_json } "fromAddr2": "{ ls_billdocitem-plantaddress2 }", |.
        lv_json = |{ lv_json } "fromPlace": "{ ls_billdocitem-plantcity }", |.
        lv_json = |{ lv_json } "fromPincode": "{ ls_billdocitem-plantpincode }", |.
        lv_json = |{ lv_json } "actFromStateCode": "20", |.
        lv_json = |{ lv_json } "fromStateCode": "20", |.
        lv_json = |{ lv_json } "toGstin": "{ ls_billdoc-shiptopartygstin }", |.
        lv_json = |{ lv_json } "toTrdName": "{ ls_billdoc-shiptopartyname }", |.
        lv_json = |{ lv_json } "toAddr1": "{ ls_billdoc-shiptopartyaddress1 }", |.
        lv_json = |{ lv_json } "toAddr2": "{ ls_billdoc-shiptopartyaddress2 }", |.
        lv_json = |{ lv_json } "toPlace": "{ ls_billdoc-shiptopartylocation }", |.
        lv_json = |{ lv_json } "toPincode": "{ ls_billdoc-shiptopartypostalcode }", |.
        lv_json = |{ lv_json } "actToStateCode": "20", |.
        lv_json = |{ lv_json } "toStateCode": "20", |.
        lv_json = |{ lv_json } "totalValue": { val_assval }, |.
        lv_json = |{ lv_json } "cgstValue": { val_cgstval }, |.
        lv_json = |{ lv_json } "sgstValue": { val_sgstval }, |.
        lv_json = |{ lv_json } "igstValue": { val_igstval }, |.
        lv_json = |{ lv_json } "cessValue": { val_cesval }, |.
        lv_json = |{ lv_json } "totInvValue": { val_totinvval }, |.
        lv_json = |{ lv_json } "transMode": "{ ls_billdoc-modeoftransport }", |.
        lv_json = |{ lv_json } "transDistance": "",|. "{ ls_billdoc-distance }", |.
        lv_json = |{ lv_json } "transporterName": "{ ls_billdoc-transportername }", |.
        lv_json = |{ lv_json } "transporterId": "{ ls_billdoc-trasnportergstin }", |.
        lv_json = |{ lv_json } "transDocNo": "",|.     "{ ls_billdoc-transporterdocumentnumber }", |.
        lv_json = |{ lv_json } "transDocDate": "{ lv_transporter }", |.
        lv_json = |{ lv_json } "vehicleNo": " { ls_billdoc-vehiclenumber }", |.
        lv_json = |{ lv_json } "vehicleType": "R",|. "{ ls_billdoc-vehicletype }", |.
        lv_json = |{ lv_json } "gstin_id": 5, |.
        lv_json = |{ lv_json } "transactionType": "1", |.
        lv_json = |{ lv_json } "otherValue": 0, |.
        lv_json = |{ lv_json } "cessNonAdvolValue": 0, |.
        lv_json = |{ lv_json } "itemList": |.
        lv_json = |{ lv_json } [ \{|.
        DATA(lt_billt) = lt_billdocitem.
        DELETE lt_billt WHERE billingdocument <> ls_billdoc-billingdocument.
        FINAL(lv_len) = lines( lt_billt ).
        LOOP AT lt_billdocitem INTO DATA(ls_billitem) WHERE billingdocument = ls_key-billingdocument.
          lv_p += 1.
          SELECT SINGLE consumptiontaxctrlcode
            FROM i_productplantbasic
            WHERE product = @ls_billitem-product AND plant = @ls_billitem-plant
            INTO @FINAL(lv_hsn).

          FINAL(lv_uom) = VALUE #( lt_uom[ sapuom = ls_billitem-billingquantityunit ]-gstuom OPTIONAL ).
          lv_qty = ls_billitem-billingquantity.
          lv_unitp = ls_billitem-materialbasevalue.
          lv_dismt = ls_billitem-discountvalue.
          val_totinvval = ls_billitem-materialvalue.
          lv_totrt = ls_billitem-totalgstrate.

          lv_igstm = ls_billitem-igstvalue.
          lv_cgstm = ls_billitem-cgstvalue.
          lv_sgstm = ls_billitem-sgstvalue.
*        lv_invmt = 10620 / 100.

          lv_cesrt = ls_billitem-cessbasevalue.
          lv_ass = ls_billitem-materialvalue - ls_billitem-discountvalue.
          ls_billitem-slno = |{ ls_billitem-slno ALPHA = OUT }|.
          lv_igstt = ls_billitem-igstrate.
          lv_cgstt = ls_billitem-cgstrate.
          lv_sgstt = ls_billitem-sgstrate.
          lv_stcna = ls_billitem-cessvalue.
          lv_item = |{ ls_billitem-slno ALPHA = OUT }|.

          lv_invmt = val_totinvval + lv_dismt + lv_igstm + lv_sgstm + lv_cgstm + lv_cesrt.
          lv_invmt1 = val_totinvval  + lv_igstm + lv_sgstm + lv_cgstm.
          SHIFT lv_item LEFT DELETING LEADING '0'.
          lv_invmt = ls_billitem-materialvalue - ls_billitem-discountvalue + lv_igstm + lv_sgstm + lv_cgstm.
          lv_json = |{ lv_json } "itemCode": "IC001", |.
          lv_json = |{ lv_json } "itemNo": { lv_item } ,|.
          lv_json = |{ lv_json } "productName": "{ ls_billitem-product }", |.
          lv_json = |{ lv_json } "productDesc": "{ ls_billitem-productname }", |.
          lv_json = |{ lv_json } "hsnCode": { lv_hsn }, |.
          lv_json = |{ lv_json } "quantity": { ls_billitem-billingquantity }, |.
          lv_json = |{ lv_json } "qtyUnit": "{ lv_uom }", |.
          lv_json = |{ lv_json } "taxableAmount": { lv_ass }, |.
          lv_json = |{ lv_json } "valueOfGoods": { val_totinvval }, |.
          lv_json = |{ lv_json } "toGstin": "{ ls_billdoc-shiptopartygstin }", |.
          lv_json = |{ lv_json } "toTrdName": "{ ls_billdoc-shiptopartyname }", |.
          lv_json = |{ lv_json } "totalValue": { val_assval }, |.
          lv_json = |{ lv_json } "sgstAmount": { lv_sgstm }, |.
          lv_json = |{ lv_json }  "cgstAmount": { lv_cgstm }, |.
          lv_json = |{ lv_json } "igstAmount": { lv_igstm }, |.
          lv_json = |{ lv_json }  "cessAmount": { lv_stcna }, |.
          lv_json = |{ lv_json } "sgstRate": { lv_sgstt }, |.
          lv_json = |{ lv_json } "cgstRate": { lv_cgstt }, |.
          lv_json = |{ lv_json } "igstRate": { lv_igstt }, |.
          lv_json = |{ lv_json } "cessRate": { lv_cesrt }, |.
          lv_json = |{ lv_json } "cessAdvol": 0, |.
          lv_json = |{ lv_json }  "cessNonAdvol": 0 |.
          lv_json = |{ lv_json } \} |.
          IF lv_p <> lv_len.
            lv_json = |{ lv_json } ,  \{|.
          ENDIF.
        ENDLOOP.
        CLEAR lv_p.

        lv_json = |{ lv_json }  ] \} \}|.

      ENDIF.

      SELECT SINGLE billingdocument,
                    billingdocumentiscancelled
      FROM i_billingdocument
      WHERE billingdocument = @ls_billdoc-billingdocument
      INTO @DATA(ls_billingdocument).
      IF ls_billingdocument-billingdocumentiscancelled IS NOT INITIAL.

        lv_msg14 = |Billing Document is cancelled|.

        APPEND VALUE #( %tky        = ls_key-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg14 ) )
               TO reported-head.

        APPEND VALUE #( %tky = ls_key-%tky )
               TO failed-head.
      ENDIF.

      SELECT SINGLE * FROM i_billingdocument
    WHERE billingdocument = @ls_billdoc-billingdocument
    INTO @DATA(ls_bill).

      SELECT SINGLE * FROM zdt_header_token
      WHERE company = @ls_bill-companycode
      INTO @DATA(ls_headtkn).

      lv_gid = ls_headtkn-gstin.
      lv_gid1 = ls_headtkn-clientid.

      IF failed-head IS INITIAL.
        TRY.
*          IF lt_parm IS NOT INITIAL.
*            FINAL(lv_token) = VALUE #( lt_parm[ tparameter = 'Token' ]-value OPTIONAL ).
*            FINAL(lv_customer) = VALUE #( lt_parm[ tparameter = 'CustomerID' ]-value OPTIONAL ).
*          ENDIF.
*          lv_gid = lv_token.
*          lv_gid1 = lv_customer.
            IF ls_gstmap-irnind IS NOT INITIAL.
              DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                         comm_scenario = 'ZCOMM_GENIRN'
                                         service_id    = 'ZOS_STANDALONEEWAY_REST' ).
            ELSE.
              lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario = 'ZCOMM_GENIRN'
                                   service_id    = 'ZOS_STANDALONEEWAY_REST' ).
            ENDIF.
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).
            lo_request->set_header_field( i_name  = 'Clientcode'
                                          i_value = lv_gid1 ).
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = lv_gid ).
            lv_gid2 = ls_billdocitem-in_gstidentificationnumber.
*          lo_request->set_header_field( i_name  = 'GSTIN'
*                                        i_value = lv_gid2 ).
            lo_request->set_text( lv_json ).

            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.
      ENDIF.
      IF ls_result IS NOT INITIAL.
        SELECT SINGLE * FROM zdt_einveway
          WHERE vbeln = @ls_billdoc-billingdocument
          INTO @ls_save.
*        SPLIT ls_result AT '"status":"1"' INTO TABLE FINAL(lt_tab1).
        IF ls_result CS 'errorCodes'.

          " TODO: variable is assigned but never used (ABAP cleaner)
          APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
          SELECT MAX( item ) FROM zdt_error_log
            WHERE billdoc = @ls_billdoc-billingdocument
            INTO @FINAL(lv_max).
          lv_p = lv_max.

*          DATA : lv_p1 TYPE numc5.
          SPLIT ls_result AT '"errorDescription":"' INTO TABLE FINAL(lt_msg).

          LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
            IF <fs_msg> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.
            SPLIT <fs_msg> AT '"}' INTO TABLE FINAL(lt_msg1).
            FINAL(lv_msg) = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
            ls_error-billdoc = ls_billdoc-billingdocument.
            ls_error-item    = lv_p1.
            lv_p1 += 1.
            ls_save-ewayflag = ''.
            ls_error-message = lv_msg.
            ls_error-logdate = sy-datum.
            ls_error-logtime = sy-uzeit.
            APPEND ls_error TO lt_error.
            CLEAR ls_error.
          ENDLOOP.

          DELETE lt_error WHERE item = '00000'.
          MODIFY zdt_error_log FROM TABLE @lt_error.

          MODIFY zdt_einveway FROM @ls_save.
          CLEAR ls_save.

        ELSE.

          SPLIT ls_result AT '"ewayBillNo":"' INTO TABLE FINAL(lt_split01).
          FINAL(ls_split) = VALUE #( lt_split01[ 2 ] OPTIONAL ).

          SPLIT ls_split AT '","ewayBillDate":"' INTO TABLE FINAL(lt_split02).
          FINAL(lv_eway) = VALUE #( lt_split02[ 1 ] OPTIONAL ).

          FINAL(ls_split2) = VALUE #( lt_split02[ 2 ] OPTIONAL ).

          SPLIT ls_split2 AT '","' INTO TABLE FINAL(lt_split03).
          FINAL(lv_ewaydate) = VALUE #( lt_split03[ 1 ] OPTIONAL ).

          ls_save-erdat       = sy-datum.
          ls_save-erzet       = sy-uzeit.
          ls_save-irnflag     = ' '.
          ls_save-ewayflag    = 'X'.
          ls_save-irncancflag = ' '.
          ls_save-eway        = lv_eway.
          ls_save-ewaydate    = lv_ewaydate.
          ls_save-vbeln       = ls_billdoc-billingdocument.

          MODIFY zdt_einveway FROM @ls_save.
          CLEAR ls_save.

        ENDIF.
      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
         ENTITY head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

  METHOD savedata.
    DATA ls_data TYPE zdt_einveway.

    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
         ENTITY head
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(heads).

    FINAL(ls_head) = VALUE #( heads[ 1 ] OPTIONAL ).

    ls_data = CORRESPONDING #( ls_head MAPPING vbeln = billingdocument
                                               transportercode = transportercode
                                               vehiclenumber = vehiclenumber
                                               vehicletype = vehicletype
                                               transporterdocumentdate = transporterdocumentdate
                                               transporterdocumentnumber = transporterdocumentnumber
                                               transportergstin = trasnportergstin
                                               modeoftransport = modeoftransport
                                               extendedvaliditydate = extendedvaliditydate
                                               distance = distance
                                               transportername = transportername
                                               movementstatus = movementstatus
                                               movementplace = movementplace
                                               movementremarks = movementremarks
                                                movementdate = movementdate
                                                movementtime = movementtime
                                                fromplace = fromplace
                                                fromstate = fromstate
                                                remainingdistance =  remainingdistance
                                                extnrsncode = extnrsncode
                                                extnremarks = extnremarks
                                                frompincode = frompincode
                                                consignmentstatus =  consignmentstatus
                                                transittype = transittype
                                                newvehicleno = newvehicleno
                                                newtranno = newtranno
                                                fromplacemultiveh = fromplacemultiveh
                                                fromstatemultiveh = fromstatemultiveh
                                                reasoncodemultiveh = reasoncodemultiveh
                                                reasonremmultiveh = reasonremmultiveh
                                                cancelrsncodeewb = cancelrsncodeewb
                                                cancelremarksewb = cancelremarksewb
                                                cnlrsneinv = cnlrsneinv
                                                cnlremarkseinv = cnlremarkseinv
                                                toplace = toplace
                                                tostate = tostate
                                                totalquantity = totalquantity
                                                unitcode = unitcode ).

    MODIFY zdt_einveway FROM @ls_data.
  ENDMETHOD.

  METHOD veheway.

    DATA lv_gid1        TYPE string.
    DATA lv_gid         TYPE string.
    DATA : lv_json TYPE string.
    DATA ls_save        TYPE zdt_einveway.
    DATA lt_error       TYPE STANDARD TABLE OF zdt_error_log.
    DATA ls_error       TYPE zdt_error_log.
    DATA lv_p1          TYPE char10.
    DATA lv_p           TYPE p LENGTH 8 DECIMALS 0.
    DATA lv_dateeway      TYPE char30.
    DATA lv_validtill      TYPE char30.

    IF keys IS NOT INITIAL.
      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).
    ENDIF.

    SELECT * FROM zdt_gstrmap
      INTO TABLE @FINAL(lt_gstmap).

    DATA : lv_date TYPE char10.

    LOOP AT keys INTO DATA(ls_keys).
      DATA(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_keys-billingdocument ] ).
      FINAL(ls_gstmap) = VALUE #( lt_gstmap[ fkart = ls_billdoc-billingdocumenttype ] OPTIONAL ).

      SELECT SINGLE billingdocument, companycode FROM i_billingdocument WHERE billingdocument = @ls_billdoc-billingdocument INTO @DATA(ls_bill).
      SELECT SINGLE * FROM zdt_header_token WHERE company = @ls_bill-companycode INTO @DATA(ls_headtkn).

      lv_gid = ls_headtkn-gstin.
      lv_gid1 = ls_headtkn-clientid.

      lv_date = |{ ls_billdoc-transporterdocumentdate+6(2) }/{ ls_billdoc-transporterdocumentdate+4(2) }/{ ls_billdoc-transporterdocumentdate+0(4) }|.
      lv_date = |{ ls_billdoc-transporterdocumentdate+6(2) }/{ ls_billdoc-transporterdocumentdate+4(2) }/{ ls_billdoc-transporterdocumentdate+0(4) }|.
      lv_json = '{'.
      lv_json = |{ lv_json } "ewayBillNo": "{ ls_billdoc-eway }", |.
      lv_json = |{ lv_json } "vehNumber": "{ ls_billdoc-newvehicleno }", |.
      lv_json = |{ lv_json } "fromPlace": "{ ls_billdoc-fromplace }", |.
      lv_json = |{ lv_json } "fromState": "{ ls_billdoc-fromstate }", |.
      lv_json = |{ lv_json } "reasonCd": "1", |.
      lv_json = |{ lv_json } "reasonRem": "Vehicle Broke Down", |.
      lv_json = |{ lv_json } "transportDocNo": "{ ls_billdoc-newtranno }", |.
      lv_json = |{ lv_json } "transporterDocDate": "{ lv_date }", |.
      lv_json = |{ lv_json } "modeOfTransport": "2" |.
      lv_json = lv_json && '}'.


      IF    ls_billdoc-newvehicleno        IS INITIAL
         OR ls_billdoc-fromplace IS INITIAL
*         OR ls_billdoc-reasonremmultiveh IS INITIAL
         OR ls_billdoc-trasnportergstin IS INITIAL
         OR ls_billdoc-modeoftransport IS INITIAL
         OR ls_billdoc-newtranno IS INITIAL
         OR ls_billdoc-transporterdocumentdate IS INITIAL
         OR ls_billdoc-fromstate           IS INITIAL.

        DATA(lv_msg14) = |Transporter Details are mandatory field|.

        APPEND VALUE #( %tky        = ls_keys-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg14 ) )
               TO reported-head.

        APPEND VALUE #( %tky = ls_keys-%tky )
               TO failed-head.
      ENDIF.

      IF failed IS INITIAL.
        TRY.
            IF ls_gstmap-irnind IS NOT INITIAL.
              DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                         comm_scenario = 'ZCOMM_GENIRN'
                                         service_id    = 'ZOS_VEHICLEUPD_REST' ).
            ELSE.
              lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario = 'ZCOMM_GENIRN'
                                   service_id    = 'ZOS_VEHICLEUPD_REST' ).
            ENDIF.
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).
            lo_request->set_header_field( i_name  = 'Clientcode'
                                          i_value = lv_gid1 ).
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = lv_gid ).
            lo_request->set_header_field( i_name  = 'Action'
                                        i_value = 'VEH' ).
            lo_request->set_text( lv_json ).

            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

        IF ls_result CS 'errorCodes'.

          " TODO: variable is assigned but never used (ABAP cleaner)
          APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
          SELECT MAX( item ) FROM zdt_error_log
            WHERE billdoc = @ls_billdoc-billingdocument
            INTO @FINAL(lv_max).
          lv_p = lv_max.

*          DATA : lv_p1 TYPE numc5.
          SPLIT ls_result AT '"errorDescription":"' INTO TABLE FINAL(lt_msg).

          LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
            IF <fs_msg> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.
            SPLIT <fs_msg> AT '"}' INTO TABLE FINAL(lt_msg1).
            FINAL(lv_msg) = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
            ls_error-billdoc = ls_billdoc-billingdocument.
            ls_error-item    = lv_p1.
            lv_p1 += 1.
            ls_error-message = lv_msg.
            ls_error-logdate = sy-datum.
            ls_error-logtime = sy-uzeit.
            APPEND ls_error TO lt_error.
            CLEAR ls_error.
          ENDLOOP.

          DELETE lt_error WHERE item = '00000'.
          MODIFY zdt_error_log FROM TABLE @lt_error.

          MODIFY zdt_einveway FROM @ls_save.
          CLEAR ls_save.

        ELSE.

          APPEND VALUE #( %tky        = ls_keys-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                               text     = 'Updated') )
                 TO reported-head.

        ENDIF.
      ENDIF.

    ENDLOOP.


    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
          ENTITY head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

  METHOD dateway.

    DATA lv_gid1        TYPE string.
    DATA lv_gid         TYPE string.
    DATA : lv_json TYPE string.
    DATA ls_save        TYPE zdt_einveway.
    DATA lt_error       TYPE STANDARD TABLE OF zdt_error_log.
    DATA ls_error       TYPE zdt_error_log.
    DATA lv_p1          TYPE char10.
    DATA lv_p           TYPE p LENGTH 8 DECIMALS 0.
    DATA lv_dateeway      TYPE char30.
    DATA lv_validtill      TYPE char30.

    IF keys IS NOT INITIAL.
      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).
    ENDIF.

    SELECT * FROM zdt_gstrmap
      INTO TABLE @FINAL(lt_gstmap).

    DATA : lv_date TYPE char10.

    LOOP AT keys INTO DATA(ls_keys).
      DATA(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_keys-billingdocument ] ).
      FINAL(ls_gstmap) = VALUE #( lt_gstmap[ fkart = ls_billdoc-billingdocumenttype ] OPTIONAL ).

      SELECT SINGLE billingdocument, companycode FROM i_billingdocument WHERE billingdocument = @ls_billdoc-billingdocument INTO @DATA(ls_bill).
      SELECT SINGLE * FROM zdt_header_token WHERE company = @ls_bill-companycode INTO @DATA(ls_headtkn).

      lv_gid = ls_headtkn-gstin.
      lv_gid1 = ls_headtkn-clientid.

      lv_date = |{ ls_billdoc-transporterdocumentdate+6(2) }/{ ls_billdoc-transporterdocumentdate+4(2) }/{ ls_billdoc-transporterdocumentdate+0(4) }|.
      lv_json = lv_json && '}'.
      lv_json = '{'.
      lv_json = |{ lv_json } "ewayBillNo": "{ ls_billdoc-eway }", |.
      lv_json = |{ lv_json } "vehNumber": "{ ls_billdoc-newvehicleno }", |.
      lv_json = |{ lv_json } "fromPlace": "{ ls_billdoc-fromplace }", |.
      lv_json = |{ lv_json } "fromStateCode": "{ ls_billdoc-fromstate }", |.
      lv_json = |{ lv_json } "fromPincode": "{ ls_billdoc-frompincode }", |.
      lv_json = |{ lv_json } "remainingDistance":"{ ls_billdoc-remainingdistance }", |.
      lv_json = |{ lv_json } "transportDocNo": "{ ls_billdoc-newtranno }", |.
      lv_json = |{ lv_json } "transporterDocDate": "{ lv_date }", |.
      lv_json = |{ lv_json } "modeOfTransport": "{ ls_billdoc-modeoftransport }", |.
      lv_json = |{ lv_json }  "extnRsnCode": { ls_billdoc-extnrsncode }, |.
      lv_json = |{ lv_json } "extnRemarks": "{ ls_billdoc-extnremarks }", |.
      lv_json = |{ lv_json } "consignmentStatus": "{ ls_billdoc-consignmentstatus }", |.
      lv_json = |{ lv_json } "transitType": "{ ls_billdoc-transittype }", |.
      lv_json = |{ lv_json } "addressLine1": "{ ls_billdoc-shiptopartyaddress1 }", |.
      lv_json = |{ lv_json } "addressLine2": "{ ls_billdoc-shiptopartyaddress2 }", |.
      lv_json = |{ lv_json } "addressLine3": "{ ls_billdoc-shiptopartylocation }" |.
      lv_json = lv_json && '}'.

      IF    ls_billdoc-newvehicleno        IS INITIAL
         OR ls_billdoc-fromplace IS INITIAL
         OR ls_billdoc-fromstate IS INITIAL
         OR ls_billdoc-frompincode IS INITIAL
         OR ls_billdoc-remainingdistance IS INITIAL
         OR ls_billdoc-newtranno IS INITIAL
         OR ls_billdoc-transporterdocumentdate           IS INITIAL
         OR ls_billdoc-modeoftransport           IS INITIAL
         OR ls_billdoc-extnremarks           IS INITIAL
*         OR ls_billdoc-extendedvaliditydate           IS INITIAL
         OR ls_billdoc-extnrsncode           IS INITIAL
         OR ls_billdoc-consignmentstatus           IS INITIAL
         OR ls_billdoc-transittype           IS INITIAL.

        DATA(lv_msg14) = |Transporter Details are mandatory field|.

        APPEND VALUE #( %tky        = ls_keys-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg14 ) )
               TO reported-head.

        APPEND VALUE #( %tky = ls_keys-%tky )
               TO failed-head.
      ENDIF.

      IF failed IS INITIAL.
        TRY.
            IF ls_gstmap-irnind IS NOT INITIAL.
              DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                         comm_scenario = 'ZCOMM_GENIRN'
                                         service_id    = 'ZOS_EXTENDDATE_REST' ).
            ELSE.
              lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario = 'ZCOMM_GENIRN'
                                   service_id    = 'ZOS_EXTENDDATE_REST' ).
            ENDIF.
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).
            lo_request->set_header_field( i_name  = 'Clientcode'
                                          i_value = lv_gid1 ).
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = lv_gid ).
            lo_request->set_header_field( i_name  = 'Action'
                                        i_value = 'EXT' ).
            lo_request->set_text( lv_json ).

            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

        IF ls_result CS 'errorCodes'.

          " TODO: variable is assigned but never used (ABAP cleaner)
          APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
          SELECT MAX( item ) FROM zdt_error_log
            WHERE billdoc = @ls_billdoc-billingdocument
            INTO @FINAL(lv_max).
          lv_p = lv_max.

*          DATA : lv_p1 TYPE numc5.
          SPLIT ls_result AT '"errorDescription":"' INTO TABLE FINAL(lt_msg).

          LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
            IF <fs_msg> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.
            SPLIT <fs_msg> AT '"}' INTO TABLE FINAL(lt_msg1).
            FINAL(lv_msg) = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
            ls_error-billdoc = ls_billdoc-billingdocument.
            ls_error-item    = lv_p1.
            lv_p1 += 1.
            ls_error-message = lv_msg.
            ls_error-logdate = sy-datum.
            ls_error-logtime = sy-uzeit.
            APPEND ls_error TO lt_error.
            CLEAR ls_error.
          ENDLOOP.

          DELETE lt_error WHERE item = '00000'.
          MODIFY zdt_error_log FROM TABLE @lt_error.

          MODIFY zdt_einveway FROM @ls_save.
          CLEAR ls_save.

        ELSE.

          APPEND VALUE #( %tky        = ls_keys-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                               text     = 'Updated') )
                 TO reported-head.

        ENDIF.
      ENDIF.

    ENDLOOP.


    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
          ENTITY head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).

  ENDMETHOD.

  METHOD traeway.

    DATA lv_gid1        TYPE string.
    DATA lv_gid         TYPE string.
    DATA : lv_json TYPE string.
    DATA ls_save        TYPE zdt_einveway.
    DATA lt_error       TYPE STANDARD TABLE OF zdt_error_log.
    DATA ls_error       TYPE zdt_error_log.
    DATA lv_p1          TYPE char10.
    DATA lv_p           TYPE p LENGTH 8 DECIMALS 0.
    DATA lv_dateeway      TYPE char30.
    DATA lv_validtill      TYPE char30.

    IF keys IS NOT INITIAL.
      SELECT * FROM zr_einveway_f
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
        INTO TABLE @FINAL(lt_billdoc).
    ENDIF.

    SELECT * FROM zdt_gstrmap
      INTO TABLE @FINAL(lt_gstmap).

    DATA : lv_date TYPE char10.

    LOOP AT keys INTO DATA(ls_keys).
      DATA(ls_billdoc) = VALUE #( lt_billdoc[ billingdocument = ls_keys-billingdocument ] ).
      FINAL(ls_gstmap) = VALUE #( lt_gstmap[ fkart = ls_billdoc-billingdocumenttype ] OPTIONAL ).

      SELECT SINGLE billingdocument, companycode FROM i_billingdocument WHERE billingdocument = @ls_billdoc-billingdocument INTO @DATA(ls_bill).
      SELECT SINGLE * FROM zdt_header_token WHERE company = @ls_bill-companycode INTO @DATA(ls_headtkn).

      lv_gid = ls_headtkn-gstin.
      lv_gid1 = ls_headtkn-clientid.

      lv_date = |{ ls_billdoc-transporterdocumentdate+6(2) }/{ ls_billdoc-transporterdocumentdate+4(2) }/{ ls_billdoc-transporterdocumentdate+0(4) }|.
      lv_json = '{'.
      lv_json = |{ lv_json } "ewayBillNo": "{ ls_billdoc-eway }", |.
      lv_json = |{ lv_json } "transporterId": "{ ls_billdoc-trasnportergstin }"|.
      lv_json = lv_json && '}'.

      IF ls_billdoc-trasnportergstin IS INITIAL.

        DATA(lv_msg14) = |Transporter Details are mandatory field|.

        APPEND VALUE #( %tky        = ls_keys-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg14 ) )
               TO reported-head.

        APPEND VALUE #( %tky = ls_keys-%tky )
               TO failed-head.
      ENDIF.

      IF failed IS INITIAL.
        TRY.
            IF ls_gstmap-irnind IS NOT INITIAL.
              DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                         comm_scenario = 'ZCOMM_GENIRN'
                                         service_id    = 'ZOS_UPDTRANS_REST' ).
            ELSE.
              lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario = 'ZCOMM_GENIRN'
                                   service_id    = 'ZOS_UPDTRANS_REST' ).
            ENDIF.
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).
            lo_request->set_header_field( i_name  = 'Clientcode'
                                          i_value = lv_gid1 ).
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = lv_gid ).
            lo_request->set_header_field( i_name  = 'Action'
                                        i_value = 'TRA' ).
            lo_request->set_text( lv_json ).

            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

        IF ls_result CS 'errorCodes'.

          " TODO: variable is assigned but never used (ABAP cleaner)
          APPEND INITIAL LINE TO lt_error ASSIGNING FIELD-SYMBOL(<lfs_error>).
          SELECT MAX( item ) FROM zdt_error_log
            WHERE billdoc = @ls_billdoc-billingdocument
            INTO @FINAL(lv_max).
          lv_p = lv_max.

*          DATA : lv_p1 TYPE numc5.
          SPLIT ls_result AT '"errorDescription":"' INTO TABLE FINAL(lt_msg).

          LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
            IF <fs_msg> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.
            SPLIT <fs_msg> AT '"}' INTO TABLE FINAL(lt_msg1).
            FINAL(lv_msg) = VALUE #( lt_msg1[ 1 ] OPTIONAL ).
            ls_error-billdoc = ls_billdoc-billingdocument.
            ls_error-item    = lv_p1.
            lv_p1 += 1.
            ls_error-message = lv_msg.
            ls_error-logdate = sy-datum.
            ls_error-logtime = sy-uzeit.
            APPEND ls_error TO lt_error.
            CLEAR ls_error.
          ENDLOOP.

          DELETE lt_error WHERE item = '00000'.
          MODIFY zdt_error_log FROM TABLE @lt_error.

          MODIFY zdt_einveway FROM @ls_save.
          CLEAR ls_save.

        ELSE.

          APPEND VALUE #( %tky        = ls_keys-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                               text     = 'Updated') )
                 TO reported-head.

        ENDIF.
      ENDIF.

    ENDLOOP.


    READ ENTITIES OF zr_einveway_f IN LOCAL MODE
          ENTITY head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT FINAL(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

ENDCLASS.


CLASS lsc_zr_einveway_f DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified    REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_zr_einveway_f IMPLEMENTATION.
  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
