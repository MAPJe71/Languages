C file: example.fG. Moody23 August 1995
C                               Last revised:   8 October 2001 (comments only)
C
C -----------------------------------------------------------------------------
C Sample program illustrating use of Fortran wrappers for the WFDB library
C Copyright (C) 2001 George B. Moody
C
C This program is free software; you can redistribute it and/or modify it under
C the terms of the GNU General Public License as published by the Free Software
C Foundation; either version 2 of the License, or (at your option) any later
C version.
C
C This program is distributed in the hope that it will be useful, but WITHOUT
C ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
C FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
C details.
C
C You should have received a copy of the GNU General Public License along with
C this program; if not, write to the Free Software Foundation, Inc., 59 Temple
C Place - Suite 330, Boston, MA 02111-1307, USA.
C
C You may contact the author by e-mail (george@mit.edu) or postal mail
C (MIT Room E25-505A, Cambridge, MA 02139 USA).  For updates to this software,
C please visit PhysioNet (http://www.physionet.org/).
C _____________________________________________________________________________
        program example
        real :: bob,fred
        open (1,file="Bobs.dat")
        open (2,file="Freds.dat")
        do
        read (1,*,end=100),bob
        if (bob >= 0) then
        fred = bob*bob
        else
        fred = -bob*bob
        end if
        write (2,10), fred,bob
        10 format ('fred has ',F8.6,' while bob has ',F8.6) 
        print*, 'Hey i just printed ',fred, ' to a file'
        end do
        100 print*, 'Dudes, im finished'
        end
        