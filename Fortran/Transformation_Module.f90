module transformation
implicit none
!

! Code: Sukhbinder
! 31st March 2010
!

real (kind=8) :: angle,agrad
real (kind=8),parameter :: PI = 3.141592653589793
real (kind=8),parameter :: torad = PI/180.0d0

real (kind=8) :: rotz(4,4),rotx(4,4),roty(4,4)
real (kind=8) :: shearxy(4,4),shearxz(4,4),shearyz(4,4)
real (kind=8) :: trans(4,4),scale(4,4)


contains
subroutine setshearxy(a,b)
real (kind=8) :: a,b

  shearxy(1:4,1:4) = 0.0d0
  shearxy(1,3) = a
  shearxy(2,3) = b
  shearxy(1,1) =1.0d0
  shearxy(2,2) =1.0d0
  shearxy(3,3) =1.0d0
  shearxy(4,4) =1.0d0

end subroutine

subroutine setshearxz(a,b)
real (kind=8) :: a,b

  shearxz(1:4,1:4) = 0.0d0
  shearxz(1,2) = a
  shearxz(3,2) = b
  shearxz(1,1) =1.0d0
  shearxz(2,2) =1.0d0
  shearxz(3,3) =1.0d0
  shearxz(4,4) =1.0d0

end subroutine


subroutine setshearyz(a,b)
real (kind=8) :: a,b

  shearyz(1:4,1:4) = 0.0d0
  shearyz(2,1) = a
  shearyz(3,1) = b
  shearyz(1,1) =1.0d0
  shearyz(2,2) =1.0d0
  shearyz(3,3) =1.0d0
  shearyz(4,4) =1.0d0

end subroutine

subroutine setscale(p,q,r)
real (kind=8) :: p,q,r

  scale(1:4,1:4) = 0.0d0
  scale(1,1) = p
  scale(2,2) = q
  scale(3,3) = r
  scale(4,4) = 1.0d0
end subroutine

subroutine settrans(p,q,r)
real (kind=8) :: p,q,r

  trans(1:4,1:4) = 0.0d0
  trans(1,4) = p
  trans(2,4) = q
  trans(3,4) = r
  trans(1,1) =1.0d0
  trans(2,2) =1.0d0
  trans(3,3) =1.0d0
  trans(4,4) =1.0d0

end subroutine

subroutine setrotz(ang)
real(kind=8) :: ang

rotz(1:4,1:4)=0.0d0

rotz(1,1) = cos(ang*torad)
rotz(1,2) = -1*sin(ang*torad)
rotz(2,1) = sin(ang*torad)
rotz(2,2) = cos(ang*torad)
rotz(3,3) = 1.0d0
rotz(4,4) = 1.0d0

end subroutine


subroutine setrotx(ang)
real(kind=8) :: ang

rotx(1:4,1:4)=0.0d0

rotx(1,1) = 1.0d0
rotx(2,2) = cos(ang*torad)
rotx(3,2) = sin(ang*torad)
rotx(2,3) = -1*sin(ang*torad)
rotx(3,3) = cos(ang*torad)
rotx(4,4) = 1.0d0

end subroutine

subroutine setroty(ang)
real(kind=8) :: ang

roty(1:4,1:4)=0.0d0

roty(1,1) = cos(ang*torad)
roty(3,1) = -1*sin(ang*torad)
roty(2,2) = 1.0d0
roty(1,3) = sin(ang*torad)
roty(3,3) = cos(ang*torad)
roty(4,4) = 1.0d0

end subroutine


subroutine getnewcoords(oldcords,rotmat)
real (kind=8)              :: oldcords(:,:),rotmat(4,4)
real (kind=8), allocatable :: newcoords(:,:)
real (kind=8) :: oldone(4),newone(4)

integer :: isize,i

isize=size(oldcords,2)

allocate(newcoords(3,isize))


do i=1,isize
 oldone(1:4)=1.0d0
 oldone(1:3) = oldcords(1:3,i)
 newone(1:4)=1.0d0
 newone=matmul(rotmat,oldone)
 newcoords(1:3,i)=newone(1:3)
end do

oldcords = newcoords
deallocate(newcoords)


end subroutine

end module
