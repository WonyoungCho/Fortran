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
`Subroutine`에 dummy 배열 사용이 가능하다. 단, **차원**과 **형식**이 **일치**해야 하며 `program`에 명시해 주어야 한다. 배열의 크기를 `j`값처럼 **argument**로 받아와 사용할 수 있고, `*`을 사용하여 배열의 **마지막 index**를 지정하지 않고도 사용이 가능하다. shape 또한 `rc(j,k:*)` 처럼 `*`의 마지막에 사용이 가능하다.

```sh
$ ./a
 ra=           1           2           3           4           5           6           7           8           9
 rb=           1           2           3           4
 rc=           1           2           3
 ra=           1           2           3           4           5           6           7           8           9
 rb=           1           2           3           4
 rc=           1           2           3           4           5           6           7           8
```

- **Example 2**
```fortran
module test
contains
  subroutine test_alloc(array)
    implicit none
    real, dimension(:), allocatable, intent(inout):: array

    if(allocated(array)) deallocate(array)
    allocate(array(5), source=1.0)
    print*, array
  end subroutine test_alloc

  function test_alloc_func(n)
    implicit none
    integer, intent(in):: n
    real, allocatable, dimension(:):: test_alloc_func
    integer:: i
    allocate(test_alloc_func(n))
    do i=1,n
       test_alloc_func(i)=i
    end do
  end function test_alloc_func
end module test

program allocate
  use test
  implicit none
  real, dimension(:), allocatable:: arr

  call test_alloc(arr)
  print*, arr*10
  if(allocated(arr)) deallocate(arr)
  print*, '-----------'
  print*, test_alloc_func(5)
end program allocate
```
`Procedure - Subroutine`에서 `allocatable array`를 사용하면 `procedure`내에서 배열의 크기가 결정된다. `Function`에서는 함수 결과가 `allocatable` 속성을 갖는 것이 가능하며, 함수가 반환되기 전에 반드시 할당되고 값을 포함해야 한다.
```sh
$ ./a
   1.00000000       1.00000000       1.00000000       1.00000000       1.00000000    
   10.0000000       10.0000000       10.0000000       10.0000000       10.0000000    
-----------
   1.00000000       2.00000000       3.00000000       4.00000000       5.00000000
```

# Derived Type

- **Example**
```fortran
program derivedtype
  implicit none
  type coord_3d
     real::x,y,z
  end type coord_3d
  type(coord_3d)::pt1, pt2=coord_3d(2.0,2.0,2.0), pt3

  pt1%x=1.0; pt1%y=1.0; pt1%z=1.0
  pt3=coord_3d(3.0,3.0,3.0)
  print*, pt1
  print*, pt2
  print*, pt3
end program derivedtype
```
```bash
$ ./a.out
   1.00000000       1.00000000       1.00000000    
   2.00000000       2.00000000       2.00000000    
   3.00000000       3.00000000       3.00000000
```
