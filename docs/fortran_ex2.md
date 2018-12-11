# Array arguments

```fortran
program assumedshape
  implicit none
  interface
     subroutine sub(ra,rb,rc)
       integer, dimension(:,:), intent(in):: ra,rb
       integer, dimension(0:,2:), intent(in):: rc
     end subroutine sub
  end interface

  integer:: ra(3,3), rb(2,2)
  integer:: rc1(0:2,2:2), rc2(0:3,2:3)
  integer:: i
  ra = reshape((/(i,i=1,9)/),(/3,3/))
  rb = reshape((/(i,i=1,4)/),(/2,2/))
  rc1= reshape((/(i,i=1,3)/),(/3,1/))
  rc2= reshape((/(i,i=1,8)/),(/4,2/))
  call sub(ra,rb,rc1)
  call sub(ra,rb,rc2)
end program assumedshape

subroutine sub(ra,rb,rc)
  integer, dimension(:,:), intent(in):: ra,rb
  integer, dimension(0:,2:), intent(in):: rc

  print*,'ra=',ra
  print*,'rb=',rb
  print*,'rc=',rc
  
end subroutine sub
```
