CLASS ycl_amdp_procedure DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    INTERFACES if_oo_adt_classrun.

    TYPES: BEGIN OF ty_booking,
             CustomerId  TYPE /dmo/customer_id,
             FlightPrice TYPE /dmo/flight_price,
*             CustCat     TYPE char256,
           END OF ty_booking.

    TYPES: tt_booking TYPE TABLE OF ty_booking WITH EMPTY KEY.

    TYPES: BEGIN OF ty_session_var,
             clnt     TYPE sy-mandt,
             cds_clnt TYPE sy-mandt,
             uname    TYPE sy-uname,
             lang     TYPE sy-langu,
             datum    TYPE datum,
           END  OF ty_session_var.

    METHODS get_top_flop_customer
      IMPORTING
        VALUE(iv_top)   TYPE int1
      EXPORTING
        VALUE(et_top)   TYPE tt_booking
        VALUE(et_flop)  TYPE tt_booking.

  PROTECTED SECTION.
    CLASS-DATA : lr_out TYPE REF TO if_oo_adt_classrun_out.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_amdp_procedure IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    lr_out = out.
    me->get_top_flop_customer(
      EXPORTING
        iv_top = '10'
      IMPORTING
        et_top   = DATA(lt_top)
        et_flop  = data(lt_flop)
    ).

    lr_out->write( 'Top' ).
    lr_out->write( lt_top ).
    lr_out->write( 'Flop' ).
    lr_out->write( lt_flop ).

  ENDMETHOD.

  METHOD get_top_flop_customer BY DATABASE PROCEDURE
                               FOR HDB
                               LANGUAGE SQLSCRIPT
                               OPTIONS READ-ONLY
                               USING /dmo/booking.

    et_top = select top :iv_top
                        customer_id as CustomerId,
                        flight_price as FlightPrice
                        from "/DMO/BOOKING"
*                        where flight_price > 6000
                        ORDER BY flightPrice desc;
    et_flop = select top :iv_top
                        customer_id as CustomerId,
                        flight_price as FlightPrice
                        from "/DMO/BOOKING"
*                        where ( flight_price < 6000 and flight_price > 200 )
                        ORDER BY flightPrice asc;

  ENDMETHOD.

ENDCLASS.
