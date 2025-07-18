CLASS ycl_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    CLASS-METHODS get_arth_data.
    CLASS-METHODS get_aggre_data.
  PROTECTED SECTION.
    CLASS-DATA : lr_out TYPE REF TO if_oo_adt_classrun_out.
  PRIVATE SECTION.

ENDCLASS.

CLASS ycl_practice IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    lr_out = out.
*    me->get_arth_data(  ).
    me->get_aggre_data(  ).
  ENDMETHOD.

  METHOD get_arth_data.
    DATA: lv_discount TYPE p DECIMALS 1 VALUE '0.8',
          lv_dec      TYPE p DECIMALS 2 VALUE '0.57'.
    SELECT
        FROM /dmo/booking
        FIELDS booking_id,
               booking_date,
               flight_date,
               flight_price AS FlightPrice,
               CAST( flight_price * @lv_discount AS INT8 ) AS FlightPriAftDis,
*               cast( flight_price + @lv_dec as int8 ) AS FlightPriWithDec,
               ceil( flight_price ) AS CeilValue,
               floor( flight_price ) AS FloorValue,
               abs( flight_price ) AS AbsValue,
               round( flight_price, 2 ) AS RoundValue,
               div( CAST( flight_price + @lv_dec AS INT8 ), 10 ) AS DivValue,
               mod( CAST( flight_price + @lv_dec AS INT8 ), 10 ) AS ModValue
               INTO TABLE @DATA(lt_data)
        UP TO 10 ROWS.
    lr_out->write( lt_data ).
  ENDMETHOD.

  METHOD get_aggre_data.
    SELECT
        FROM /dmo/booking
        FIELDS customer_id,
               currency_code,
               SUM( flight_price ) AS SumPrice,
               AVG( flight_price ) AS AvgPrice,
               MAX( flight_price ) AS MaxPrice,
               MIN( flight_price ) AS MinPrice,
               COUNT( * ) AS TotalCount
*        WHERE customer_id eq 1
        GROUP BY customer_id, currency_code
        INTO TABLE @DATA(lt_data).
    lr_out->write( lt_data ).
  ENDMETHOD.

ENDCLASS.
