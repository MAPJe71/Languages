!
!   https://notepad-plus-plus.org/community/topic/11059/custom-functions-list-rules
!
!
!   A regular Fortran 90 function is something like this:
!

(optional type) function my_function (optional arguments)
    some stuff
end function my_function

!
!   Here are two examples of Fortran functions that computes x², but written differently.
!

function xsquare(x)
    real, intent(in) :: x
    real :: xsquare
    xsquare = x*x
    return
end function xsquare

real function xsquare(x)
    real, intent(in) :: x
    xsquare = x*x
    return
end function xsquare

!
!   Slightly modified so that it can also handle (correctly) functions 
!   ending with “result” (yeah, Fortran is quite a mess), and subroutines.
!

function xsquare(x) result(y)
    real, intent(in) :: x
    real :: y
    y = x*x
    return
end function xsquare

subroutine hello()
    print *, "Hello World!"
    return
end subroutine hello

