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
    SELECT
        FROM /dmo/booking
        FIELDS *
        INTO TABLE @DATA(lt_data)
        UP TO  100 ROWS.
    lr_out->write( lt_data ).
  ENDMETHOD.

ENDCLASS.
