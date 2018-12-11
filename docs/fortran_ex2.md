# Array arguments

- **Example 1**
```fortran
program assumedshape
  implicit none
  interface
     subroutine sub(ra,rb,rc,j,k)
       implicit none
       integer:: j,k
       integer, dimension(0:,:), intent(in):: ra,rb
       integer:: rc(j,*)
     end subroutine sub
  end interface

  integer:: ra(3,3), rb(2,2)
  integer:: rc1(0:2,2:2), rc2(0:3,2:3)
  integer:: i

  ra = reshape((/(i,i=1,9)/),(/3,3/))
  rb = reshape((/(i,i=1,4)/),(/2,2/))
  rc1= reshape((/(i,i=1,3)/),(/3,1/))
  rc2= reshape((/(i,i=1,8)/),(/4,2/))

  call sub(ra,rb,rc1,3,1)
  call sub(ra,rb,rc2,4,2)
end program assumedshape

subroutine sub(ra,rb,rc,j,k)
  implicit none
  integer:: j,k
  integer, dimension(0:,:), intent(in):: ra,rb
  integer:: rc(j,*)
  
  print*,'ra=',ra
  print*,'rb=',rb
  print*,'rc=',rc(j,k)
end subroutine sub
```
`Subroutine`에 dummy 배열 사용이 가능하다.단, 차원과 형식이 일치해야 하며 `program`에 명시해 주어야 한다. 배열의 shape을 `j`값처럼 ***argument***로 받아와 사용할 수 있고, `*`을 사용하여 배열 size의 마지막 index를 지정하지 않고도 사용이 가능하다.

```sh
$ ./a
 ra=           1           2           3           4           5           6           7           8           9
 rb=           1           2           3           4
 rc=           1           2           3
 ra=           1           2           3           4           5           6           7           8           9
 rb=           1           2           3           4
 rc=           1           2           3           4           5           6           7           8
```
