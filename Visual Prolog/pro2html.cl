/*****************************************************************************

                        Copyright (c) Becerril 2003 Private

******************************************************************************/

class blueGreen
    open core

    predicates
        classInfo : core::classInfo.
        % @short Class information  predicate. 
        % @detail This predicate represents information predicate of this class.
        % @end
    predicates
        run : core::runnable.
end class blueGreen