/*****************************************************************************

                        Copyright (c) Becerril 2003 Private

******************************************************************************/

implement blueGreen
    open core

    constants
        className = "blueGreen".
        classVersion = "".

    clauses
        classInfo(className, classVersion).

    clauses
        run():-
            TaskWindow = taskWindow::new(),
            TaskWindow:show().
end implement blueGreen

goal
    mainExe::run(blueGreen::run).
