CLASS ycl_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    CLASS-METHODS get_data.
  PROTECTED SECTION.
    CLASS-DATA : lr_out TYPE REF TO if_oo_adt_classrun_out.
  PRIVATE SECTION.

ENDCLASS.

CLASS ycl_practice IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    lr_out = out.
    me->get_data(  ).
  ENDMETHOD.

  METHOD get_data.
    DATA: lv_discount TYPE p DECIMALS 1 VALUE '0.8',
          lv_dec type p DECIMALS 2 VALUE '0.57'.
    SELECT
        FROM /dmo/booking
        FIELDS booking_id,
               booking_date,
               flight_date,
               flight_price AS FlightPrice,
               cast( flight_price * @lv_discount as int8 ) AS FlightPriAftDis,
*               cast( flight_price + @lv_dec as int8 ) AS FlightPriWithDec,
               ceil( flight_price ) AS CeilValue,
               floor( flight_price ) as FloorValue,
               abs( flight_price ) as AbsValue,
               round( flight_price, 2 ) as RoundValue,
               div( cast( flight_price + @lv_dec as int8 ), 10 ) as DivValue,
               mod( cast( flight_price + @lv_dec as int8 ), 10 ) as ModValue
               INTO TABLE @DATA(lt_data)
        UP TO 10 ROWS.
    lr_out->write( lt_data ).
  ENDMETHOD.

ENDCLASS.
