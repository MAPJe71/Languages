program average

! Read in some numbers and take the average
! As written, if there are no data points, an average of zero is returned
! While this may not be desired behavior, it keeps this example simple

implicit none

real, dimension(:), allocatable :: points
integer                         :: number_of_points
real                            :: average_points=0., positive_average=0., negative_average=0.

write (*,*) "Input number of points to average:"
read  (*,*) number_of_points

allocate (points(number_of_points))

write (*,*) "Enter the points to average:"
read  (*,*) points

! Take the average by summing points and dividing by number_of_points
if (number_of_points > 0) average_points = sum(points) / number_of_points

! Now form average over positive and negative points only
if (count(points > 0.) > 0) then
    positive_average = sum(points, points > 0.) / count(points > 0.)
end if

if (count(points < 0.) > 0) then
    negative_average = sum(points, points < 0.) / count(points < 0.)
end if

deallocate (points)

! Print result to terminal
write (*,'(a,g12.4)') 'Average = ', average_points
write (*,'(a,g12.4)') 'Average of positive points = ', positive_average
write (*,'(a,g12.4)') 'Average of negative points = ', negative_average

end program average