program test
use transformation 
 
!open(20,file='bladeps.txt',status='old')
!open(40,file='30degree.txt',status='new')
real(kind=8) :: oldcords(4),xyz(3,10),temp(3,10)
 
call random_number(oldcords)
call random_number(xyz)
oldcords=oldcords*10.0d0
oldcords(4)=1.0d0
 
xyz=xyz*10.0d0
write(*, '(3f10.2)') ((xyz(i,j),i=1,3),j=1,10)
write(*,*)
write(*, '(4f10.2)') (oldcords(i), i=1,4)
write(*,*)
call setrotz(30.0d0)
write(*, '(4f10.2)') ((rotz(i,j),j=1,4),i=1,4)
temp=xyz
call getnewcoords(temp,rotz)
write(*,*)
write(*, '(3f10.2)') ((temp(i,j),i=1,3),j=1,10)
 
!close(30)
!close(20)
 
end program test
