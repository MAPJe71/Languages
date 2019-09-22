program test
use lightsout
 character*2 ::ss
 integer :: ival,ilev
 if(debug) call fillall()
 if(debug) call printtable()
 if(debug) print *, "*******"
 if(debug) call clearall()
 if(debug)  call printtable()

 if(debug)  print *, "*******"
 if(debug)  call level1()
 if(debug)  call printtable()
 if(debug)  print *, "*******"
 if(debug)  call level2()
 if(debug)  call printtable()
 if(debug)  print *, "*******"
 if(debug)  call level3()
 if(debug)  call printtable()
 if(debug)  print *, "*******"
 if(debug)  call level4()
 if(debug)  call printtable()
 if(debug)  print *, "*******"
 if(debug)  call level5()
 if(debug)  call printtable()

 ival=0
 ilev=1
 call level1()

 do while(.true.)
  if(debug)  print *,iswon,ilev
  if(iswon .ne. 0) then
    ilev=ilev+1
    print *, "Entering level :" ,ilev
    if (ilev == 2) call level2
    if (ilev == 3) call level3
    if (ilev == 4) call level4
    if (ilev == 5) call level5
  end if

  call printtable()
   if(debug) print *,'2',iswon,ilev
  write(*,'(a1)',advance="no") ":"
  read(*,'(2a)') ss
  call givevalue(ss,ival)
  if(debug)  print *, ival
  if (ival .eq. 999) exit
   if(debug) print *,'3',iswon,ilev
   if(ival .ne. -1) call check(ival)
   if(debug) print *,'4',iswon,ilev

 end do
 contains

 subroutine givevalue(sstext,value)
  character*2 :: sstext
  integer :: value,i,k

  if (sstext(1:1) .eq. 'q') then
    value=999
  end if

  select case(sstext(1:1))

   case('a')
   i=1
   case ('b')
   i=2
   case ('c')
   i=3
   case ('d')
   i=4
   case ('e')
   i=5
   case default
   i=-1
   value=-1
  end select


  read(sstext(2:2),'(i1)',err=100) k



  if (k <7 .and. k .ne. 0) then
      value=(i-1)+(k-1)*5
  else
    value=-1
    k=-1
  end if
  if(debug) print *, k,i,value
  return
100  value =999

 end subroutine


end program

