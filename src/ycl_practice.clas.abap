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
    CLASS-METHODS get_group_by_data.
    CLASS-METHODS get_having_clause_data.
    CLASS-METHODS get_union_data.
  PROTECTED SECTION.
    CLASS-DATA : lr_out TYPE REF TO if_oo_adt_classrun_out.
  PRIVATE SECTION.
    CLASS-DATA: lt_carrier TYPE STANDARD TABLE OF /dmo/carrier.
    CLASS-DATA: lv_carrier_id TYPE /dmo/carrier_id.

ENDCLASS.



CLASS ycl_practice IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    lr_out = out.
*    me->get_arth_data( ).
*    me->get_aggre_data( ).
*    me->get_case_data( ).
*    me->get_host_exp_data( ).
*    me->get_client_handling( ).
*    me->get_group_by_data( ).
*    me->get_having_clause_data( ).
    me->get_union_data( ).

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
        UP TO 20 ROWS.

    lr_out->write( lt_client ).

  ENDMETHOD.

  METHOD get_group_by_data.

    " This will not meet out requirement
*    SELECT
*        FROM /dmo/booking
*        FIELDS customer_id,
*               currency_code,
*               SUM( flight_price ) AS SumPrice,
**               AVG( flight_price ) AS AvgPrice,
**               MAX( flight_price ) AS MaxPrice,
**               MIN( flight_price ) AS MinPrice,
*               COUNT( * ) AS TotalCount,
*               CASE
*                 WHEN flight_price < 500 THEN 'Low range ticket total'
*                 WHEN ( flight_price > 500 AND flight_price < 5000 ) THEN 'Medium range ticket total'
*                 ELSE 'High range ticket total'
*               END AS CountDes
*        WHERE customer_id EQ 1
*        GROUP BY customer_id, currency_code, flight_price
**        ORDER BY currency_code ASCENDING
*        INTO TABLE @DATA(lt_group_by).

    SELECT
            FROM /dmo/booking
            FIELDS customer_id,
                   currency_code,
                   SUM( flight_price ) AS SumPrice,
*                   AVG( flight_price ) AS AvgPrice,
*                   MAX( flight_price ) AS MaxPrice,
*                   MIN( flight_price ) AS MinPrice,
                   COUNT( * ) AS TotalCount,
                   CASE
                     WHEN flight_price < 500 THEN 'Low range ticket total'
                     WHEN ( flight_price > 500 AND flight_price < 5000 ) THEN 'Medium range ticket total'
                     ELSE 'High range ticket total'
                   END AS CountDes
            WHERE customer_id EQ 1
            GROUP BY customer_id, currency_code,
                     CASE
                        WHEN flight_price < 500 THEN 'Low range ticket total'
                        WHEN ( flight_price > 500 AND flight_price < 5000 ) THEN 'Medium range ticket total'
                        ELSE 'High range ticket total'
                     END
*            ORDER BY currency_code ASCENDING
            INTO TABLE @DATA(lt_group_by).

    lr_out->write( lt_group_by ).

  ENDMETHOD.

  METHOD get_having_clause_data.

    SELECT
        FROM /dmo/booking
        FIELDS customer_id,
               currency_code,
               SUM( flight_price ) AS SumPrice,
               AVG( flight_price ) AS AvgPrice,
               MAX( flight_price ) AS MaxPrice,
               MIN( flight_price ) AS MinPrice,
               COUNT( * ) AS TotalCount
        WHERE customer_id BETWEEN 1 AND 5
        GROUP BY customer_id, currency_code
*        Check the results with and without Having clause to understand
        HAVING SUM( flight_price ) > 60000
        ORDER BY customer_id ASCENDING
        INTO TABLE @DATA(lt_hav_cla).

    lr_out->write( lt_hav_cla ).

  ENDMETHOD.

  METHOD get_union_data.

** As this query hitting DB twice not advisable to use
*     SELECT
*        FROM /dmo/booking
*        FIELDS customer_id,
*               currency_code,
*               SUM( flight_price ) AS SumPrice,
**               AVG( flight_price ) AS AvgPrice,
**               MAX( flight_price ) AS MaxPrice,
**               MIN( flight_price ) AS MinPrice,
*               COUNT( * ) AS TotalCount,
*               'Long travelling customers' as CustCat
*        WHERE customer_id BETWEEN 1 AND 5
*        GROUP BY customer_id, currency_code
*        HAVING SUM( flight_price ) > 60000
*        ORDER BY customer_id ASCENDING
*        INTO TABLE @DATA(lt_union).
*
*        SELECT
*        FROM /dmo/booking
*        FIELDS customer_id,
*               currency_code,
*               SUM( flight_price ) AS SumPrice,
**               AVG( flight_price ) AS AvgPrice,
**               MAX( flight_price ) AS MaxPrice,
**               MIN( flight_price ) AS MinPrice,
*               COUNT( * ) AS TotalCount,
*               'Short travelling customer' as CustCat
*        WHERE customer_id BETWEEN 1 AND 5
*        GROUP BY customer_id, currency_code
*        HAVING SUM( flight_price ) < 60000
*        ORDER BY customer_id ASCENDING
*        APPENDING TABLE @lt_union.

*Using union we can use select query in one hit to DB
    SELECT
            FROM /dmo/booking
            FIELDS customer_id,
                   currency_code,
                   SUM( flight_price ) AS SumPrice,
*               AVG( flight_price ) AS AvgPrice,
*               MAX( flight_price ) AS MaxPrice,
*               MIN( flight_price ) AS MinPrice,
                   COUNT( * ) AS TotalCount,
                   'Long travelling customers' AS CustCat
            WHERE customer_id BETWEEN 1 AND 5
            GROUP BY customer_id, currency_code
            HAVING SUM( flight_price ) > 60000
*            ORDER BY customer_id ASCENDING
*            INTO TABLE @DATA(lt_union).
    UNION ALL
    SELECT
    FROM /dmo/booking
    FIELDS customer_id,
           currency_code,
           SUM( flight_price ) AS SumPrice,
*               AVG( flight_price ) AS AvgPrice,
*               MAX( flight_price ) AS MaxPrice,
*               MIN( flight_price ) AS MinPrice,
           COUNT( * ) AS TotalCount,
           'Short travelling customer' AS CustCat
    WHERE customer_id BETWEEN 1 AND 5
    GROUP BY customer_id, currency_code
    HAVING SUM( flight_price ) < 60000
    ORDER BY customer_id ASCENDING
    into TABLE @data(lt_union).

    lr_out->write( lines( lt_union ) ).

    lr_out->write( lt_union ).

  ENDMETHOD.

ENDCLASS.
