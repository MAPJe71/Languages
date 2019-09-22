      program stlread

! Program to Read Binary STL file.
! programmed by Sukhbinder Singh
! stores normals and the triangles in the normals and triangles arrays.
!
! 23rd May 2011

      real*4 n(3),x1(3),x2(3),x3(3)
      integer*2 padding
      integer*4 ntri,iunit,irc
      character(len=80) title, filename
      double precision, allocatable :: normals(:,:),triangles(:,:)
     
      filename="C:\Documents and Settings\sukhbinder\Desktop\projects\stlbinaryread\sample.stl"

      iunit=13
     
      open(unit=iunit,file=filename,status='old',form='unformatted', &
    & access='direct',recl=80)

      read(iunit,rec=1)title
      close(iunit,status='keep')

      open(unit=iunit,file=filename,status='old',form='unformatted', &
    & access='direct',recl=4)
     
      read(iunit,rec=21)ntri
      close(iunit,status='keep')
           
      open(unit=iunit,file=filename,status='old',form='unformatted', &
    & access='direct',recl=2)
      irc=(80+4)/2+1
     
      allocate(normals(3,ntri))
      allocate(triangles(3,ntri*3))
     
      k=1
      do i=1,ntri
       call readbin(iunit,n(1),irc) 
       call readbin(iunit,n(2),irc)
       call readbin(iunit,n(3),irc)

       call readbin(iunit,x1(1),irc)
       call readbin(iunit,x1(2),irc)
       call readbin(iunit,x1(2),irc)

       call readbin(iunit,x2(1),irc)
       call readbin(iunit,x2(2),irc)
       call readbin(iunit,x2(3),irc)

       call readbin(iunit,x3(1),irc)
       call readbin(iunit,x3(2),irc)
       call readbin(iunit,x3(3),irc)

       normals(1,i)=n(1)
       normals(2,i)=n(2)
       normals(3,i)=n(3)
     
       triangles(1,k)=x1(1)
       triangles(2,k)=x1(2)
       triangles(3,k)=x1(3)

       triangles(1,k+1)=x2(1)
       triangles(2,k+1)=x2(2)
       triangles(3,k+1)=x2(3)


       triangles(1,k+2)=x3(1)
       triangles(2,k+2)=x3(2)
       triangles(3,k+2)=x3(3)

       k=k+3
       read(iunit,rec=irc)padding
       irc=irc+1
      end do   

      write(*,*) trim(filename),' has this title ',trim(title),' and has',ntri, ' triangles' 
      end program

      subroutine readbin(iunit,a,irc)
      real*4 a,b
      integer*2 ib(2)
      equivalence(b,ib)

      read(iunit,rec=irc)ib(1)
      irc=irc+1
      read(iunit,rec=irc)ib(2)
      irc=irc+1
      
      a=b

      end
	  