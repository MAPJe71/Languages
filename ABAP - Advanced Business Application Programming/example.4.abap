     CLASS cx_negative_amount DEFINITION PUBLIC
                             INHERITING FROM cx_static_check.
    ENDCLASS. 

    CLASS cl_account DEFINITION ABSTRACT PUBLIC.
      PUBLIC SECTION.
        METHODS: constructor IMPORTING id     TYPE string,
                 withdraw    IMPORTING amount TYPE i
                             RAISING cx_negative_amount.
      PROTECTED SECTION.
        DATA amount TYPE accounts-amount.
    ENDCLASS. 

    CLASS cl_account IMPLEMENTATION.
      METHOD constructor.
        "fetch amount for one account into attribute amount
         ...
      ENDMETHOD.
      METHOD withdraw.
        me->amount = me->amount - amount.
      ENDMETHOD.
    ENDCLASS. 

    CLASS cl_checking_account DEFINITION PUBLIC
                              INHERITING FROM cl_account.
      PUBLIC SECTION.
        METHODS withdraw REDEFINITION.
    ENDCLASS. 

    CLASS cl_checking_account IMPLEMENTATION.
      METHOD withdraw.
         super->withdraw( amount ).
         IF me->amount < 0.
            "Handle debit balance
             ...
         ENDIF.
      ENDMETHOD.
    ENDCLASS. 

    CLASS cl_savings_account DEFINITION PUBLIC
                             INHERITING FROM cl_account.
        PUBLIC SECTION.
          METHODS withdraw REDEFINITION.
    ENDCLASS. 

    CLASS cl_savings_account IMPLEMENTATION.
      METHOD withdraw.
        IF me->amount > amount.
           super->withdraw( amount ).
        ELSE.
           RAISE EXCEPTION TYPE cx_negative_amount.
        ENDIF.
      ENDMETHOD.
    ENDCLASS.
    ******************************************************** 

    CLASS bank_application DEFINITION PUBLIC.
      PUBLIC SECTION.
       CLASS-METHODS main.
    ENDCLASS. 

    CLASS bank_application IMPLEMENTATION.
      METHOD main.
        DATA: account1 TYPE REF TO cl_account,
              account2 TYPE REF TO cl_account.
      ... 

    CREATE OBJECT account1 TYPE cl_checking_account
      EXPORTING
        id = ... 

    CREATE OBJECT account2 TYPE cl_savings_account
      EXPORTING
        id                   = ...
    ... 

    TRY.
          account1->withdraw( ... ).
          account2->withdraw( ... ).
        CATCH cx_negative_amount.
          ...
       ENDTRY.
      ENDMETHOD.
    ENDCLASS. 

