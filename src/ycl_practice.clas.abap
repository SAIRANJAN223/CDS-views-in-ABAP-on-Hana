CLASS ycl_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    CLASS-METHODS get_arth_data.
    CLASS-METHODS get_aggre_data.
    CLASS-METHODS get_case_data.
    CLASS-METHODS get_host_exp_data.
    CLASS-METHODS class_constructor.
    CLASS-METHODS get_client_handling.
  PROTECTED SECTION.
    CLASS-DATA : lr_out TYPE REF TO if_oo_adt_classrun_out.
  PRIVATE SECTION.
    CLASS-DATA: lt_carrier TYPE STANDARD TABLE OF /dmo/carrier.
    CLASS-DATA: lv_carrier_id TYPE /dmo/carrier_id.

ENDCLASS.



CLASS ycl_practice IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    lr_out = out.
*    me->get_arth_data(  ).
*    me->get_aggre_data(  ).
*    me->get_case_data( ).
*    me->get_host_exp_data( ).
    me->get_client_handling( ).

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
* SUM, AVG, MAX, MIN, COUNT
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

  METHOD get_case_data.

    SELECT
        FROM /dmo/booking
        FIELDS customer_id,
*        Case with String
               CASE currency_code
                WHEN 'USD' THEN 'Doller'
                WHEN 'EUR' THEN 'Euro'
                WHEN 'JPY' THEN 'Yen'
                WHEN 'SGD' THEN 'Sin'
                ELSE 'Other Currency'
               END AS Currency,
*        Case with expression
               CASE
                 WHEN flight_price < 200 THEN 'Low Price'
                 WHEN ( flight_price > 200 AND flight_price < 5000 ) THEN 'Medium Price'
                 WHEN flight_price > 5000 THEN 'High Price'
               END AS PriceRange
               INTO TABLE @DATA(lt_case)
               UP TO 200 ROWS.

    lr_out->write( lt_case ).

  ENDMETHOD.

  METHOD class_constructor.
    SELECT
        FROM /dmo/carrier
        FIELDS *
        INTO TABLE @DATA(lt_carrier).
  ENDMETHOD.

  METHOD get_host_exp_data.

    SELECT
        FROM /dmo/flight
        FIELDS carrier_id, flight_date, price
        WHERE carrier_id = @( VALUE /dmo/flight-carrier_id( lt_carrier[ name = 'Deutsche Lufthansa AG' ]-carrier_id ) )
        INTO TABLE @DATA(lt_flight_data).

    lr_out->write( lt_flight_data ).

  ENDMETHOD.

  METHOD get_client_handling.

    SELECT
        FROM /dmo/booking AS booking
        INNER JOIN /dmo/flight AS flight
        ON booking~carrier_id = flight~carrier_id
*        USING CLIENT '200'
        FIELDS booking_id, flight~carrier_id, flight_price
        INTO TABLE @DATA(lt_client)
        up to 20 rows.

    lr_out->write( lt_client ).

  ENDMETHOD.

ENDCLASS.
