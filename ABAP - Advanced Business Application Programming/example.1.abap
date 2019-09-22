* Defines an interface if_counter for a counter and includes it in a class 
* cl_counter. Creates an object and uses it using an interface reference 
* counter.

INTERFACE if_counter.
  METHODS: reset,
           increment,
           get_counts RETURNING value(count) TYPE i.
ENDINTERFACE.

CLASS cl_counter DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING offset TYPE i.
    INTERFACES if_counter.
  PRIVATE SECTION.
    DATA count TYPE i.
ENDCLASS.

CLASS cl_counter IMPLEMENTATION.
  METHOD constructor.
    count = offset.
  ENDMETHOD.
  METHOD if_counter~reset.
    count = 0.
  ENDMETHOD.
  METHOD if_counter~increment.
    count = count + 1.
  ENDMETHOD.
  METHOD if_counter~get_counts.
    count = me->count.
  ENDMETHOD.
ENDCLASS.

...

START-OF-SELECTION.
  DATA counter TYPE REF TO if_counter.

  counter = NEW cl_counter( 10 ).

  counter->increment( ).

  DATA(counts) = counter->get_counts( ).

  counter->reset( ).
            