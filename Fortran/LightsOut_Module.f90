module lightsout
implicit none
integer :: elements(0:25)
integer :: iswon,moves
logical,parameter :: debug =.false.
 character*30 :: sdata(4)

 contains

subroutine printtable1()
 integer :: i,j,ii,jj

 sdata(1)='        _\|/_        '
 sdata(2)='        (o o)        '
 sdata(3)='+----oOO-{_}-OOo----+'

 do i=1,3
  write(*,'(a30)') sdata(i)
 end do
    write(*,'(6(2x,a))')  ' ','a','b','c','d','e'
    ii=0
    jj=4
    do j=1,5
!      write(*,'(6i3)') j,(elements(i),i=ii,jj)
      write(*,'(i3,5a3)') j,(achar(elements(i)+46),i=ii,jj)
      ii=jj+1
      jj=ii+4
    end do

!    if(debug) then
!    print *,"Degub mode:"
!    write(*,'(5i8)')(elements(i),i=0,24)
!    end if

end subroutine



subroutine printtable()
 integer :: i,j,ii,jj

 sdata(1)='        _\|/_        '
 sdata(2)='        (o o)        '
 sdata(3)='+----oOO-{_}-OOo----+'

 do i=1,3
  write(*,'(a30)') sdata(i)
 end do
    write(*,'(6(1x,a,2x))')  ' ','a','b','c','d','e'
    ii=1

    write(*,'(7(5a))')'    ','___','.','___','.','___','.','___','.','___','.'
    do i=1,5
       do j=1,5

        if(elements(ii) .eq. 0) then
          write(*,'(4a)',advance='no') achar(32),achar(32),achar(32),'|'
        else
          write(*,'(4a)',advance='no')achar(219),achar(219),achar(219),'|'
        end if
         ii=ii+1
       end do
       write(*,*)
       write(*,'(i3,5(5a))')i,'.','___','|','___','|','___','|','___','|','___','|'
    end do

!    if(debug) then
!    print *,"Degub mode:"
!    write(*,'(5i8)')(elements(i),i=0,24)
!    end if

end subroutine

subroutine fillall()
integer :: i
 do i =0 , 24
   elements(i)=1
 end do
end subroutine

subroutine clearall()
integer :: i
 do i = 0, 24
   elements(i)=0
 end do
end subroutine

subroutine level1()
 iswon=0
 moves=0
 call clearall()
 elements(10)=1
 elements(12)=1
 elements(14)=1
end subroutine

subroutine level2()
 iswon=0
 moves=0
 call clearall();
 elements (12)=1;
 elements (16)=1;
 elements (17)=1;
 elements (18)=1;
 elements (20)=1;
 elements (21)=1;
 elements (22)=1;
 elements (23)=1;
 elements (24)=1;
end subroutine

subroutine level3()
 iswon=0
 moves=0
 call fillall();
 elements (4)=0;
 elements (6)=0;
 elements (7)=0;
 elements (8)=0;
 elements (11)=0;
 elements (12)=0;
 elements (13)=0;
 elements (16)=0;
 elements (17)=0;
 elements (18)=0;
 elements (24)=0;
end subroutine

subroutine level4()
 iswon=0
 moves=0
 call clearall();
 elements (2)=1;
 elements (6)=1;
 elements (8)=1;
 elements (10)=1;
 elements (12)=1;
 elements (14)=1;
 elements (16)=1;
 elements (18)=1;
 elements (22)=1;
end subroutine

subroutine level5()
 iswon=0
 moves=0
 call clearall();
 elements (11)=1;
 elements (16)=1;
 elements (21)=1;
end subroutine

subroutine checkall()
 integer :: win,i
 win=1;
 do i = 0 ,24
   if (elements (i)==0) then
      win=0;
   end if
 end do

 if (win==1) then
    call printtable()
    write(*,*) "You Won!!"
    write(*,*) "You did it in ",moves, "moves"
    iswon=1
 end if
if(debug) print *,'7',iswon
end subroutine

subroutine check(v)
integer :: q,w,row,intv,a,b,c,d,kc,kd,kv,is,v
 q=5;
 w=1;
 moves=moves+1
 row=Int(v/q)+w;
 intv =Int(v);
 a=intv+q;
 b=intv-q;
 c=intv+w;
 d=intv-w;
 if(debug) print *, 'check',iswon
 if(debug) print *, 'row a b c d', row,a,b,c,d
 if (a<0 .or. a>24) then
    a=25;
 end if
 if (b<0 .or. b>24) then
   b=25;
 end if
 if (c<0 .or. c>24) then
   c=25;
 end if
 if (d<0 .or. d>24) then
   d=25;
 end if
 kc = (Int(c/q)+w)
 kd = (Int(d/q)+w)
 kv = row;
 if (kc /= kv) then
   c=25;
 end if
 if (kd /= kv) then
   d=25;
 end if
 if (v==5) d=25;
 if(debug) print *,'a b c d second', a,b,c,d
 if ( elements (a) == 1) then
   elements (a)=0;
 else
   elements (a)=1;
 end if

 if ( elements (b) == 1) then
  elements (b)=0;
 else
  elements (b)=1;
 end if

 if ( elements (c) == 1) then
   elements (c)=0;
 else
   elements (c)=1;
end if

 if ( elements (d) == 1) then
  elements (d)=0;
 else
  elements (d)=1;
 end if

 if ( elements (v) == 1) then
  elements (v)=0;
 else
  elements (v)=1;
 end if

 if(debug) print *,'6',iswon
 call checkall()
 if(debug) print *, 'check',iswon
end subroutine

end module


