# Subroutine
```fortran
[property] Subroutine subroutine_name(dummy_arg)
  [USE 문]
  [선언문]
  [실행문]
  [내부 프로시저]
END Subroutine subroutine_name
```

> - `call subroutine_name(variables)`
> - `[property]` = `pure`, `elemental`, `recursive`


# Function
```fortran
[property][type] Function function_name(dummy_arg) [result (result_name)]
  [USE 문]
  [선언문]
  [실행문]
  [내부 프로시저]
END Funtion function_name
```

> - `variable = function_name(variables)`
> - `[property]` = `pure`, `elemental`, `recursive`
> - `[type]` = `integer`, `real`, `complex`, `character`, `logical`
> - `[result (result_name)]` : 함수의 값을 함수 이름으로 받을 것인지, 결과 이름을 정해서 받을 것인지이다.

# Intent attribute
- intent(in) : 들어와서 나갈 때까지 값의 변화가 없는 인수
- intent(out) : 값을 새로 할당 받을 때까지 사용되지 않는 인수
- intent(inout) : 프로시저에 들어와 사용되고 값을 새로 할당 받아 그 결과를 호출 프로그램에 되돌려 주는 인수

```fortran
program intent
  implicit none
  real :: x, y

  y = 5.0
  
  call mistaken(x,y)

  print *, x

contains
  subroutine mistaken(a,b)
    implicit none
    real, intent(in) :: a
    real, intent(out) :: b

    a = 2*b
  end subroutine mistaken

end program intent
```
```sh
$ ./a.out
intent.f90:17:4:

     a = 2*b
    1
Error: Dummy argument ‘a’ with INTENT(IN) in variable definition context (assignment) at (1)
```

# Pure property
- `pure subroutine`의 모든 **argument**는 `intent` 속성을 가져야 한다.
- `pure function`의 모든 **argument**는 `intent(in)` 속성을 가져야 한다.
```fortran
program pure_property
  implicit none
  integer :: a=1, b=1

  call pure_subr(a,b)
  print *, b
  print *, pure_func(a,b)

contains
  pure subroutine pure_subr(a,b)
    implicit none
    integer, intent(in) :: a
    integer, intent(out) :: b

    b = a + 1
  end subroutine pure_subr
  
  pure integer function pure_func(a,b)
    implicit none
    integer, intent(in) :: a,b

    pure_func = a + b
  end function pure_func
end program pure_property
```
```sh
$ ./a.out
           2
           3
```

# Elemental property
- `Elemental`로 정의되면 **argument**가 scalar면 결과도 scalar이여야 하고, 배열이면 결과도 배열이여야 한다.
```fortran
program elemental_property
  implicit none
  integer, dimension(10) :: x, y
  integer :: a=100, b, k

  x = (/(k,k=1,10)/)
  y = func(x)

  print *, y
  print *, func(a)

  call routine(x,y)
  print *, y

  call routine(a,b)
  print *, b

contains
  elemental integer function func(x)
    implicit none
    integer, intent(in) :: x

    func = x + 1
  end function func

  elemental subroutine routine(x,y)
    implicit none
    integer, intent(in) :: x
    integer, intent(out) :: y

    y = x + 1
  end subroutine routine
end program elemental_property
```
```sh
$ ./a.out
           2           3           4           5           6           7           8           9          10          11
         101
           2           3           4           5           6           7           8           9          10          11
         101
```

# Recursive property
- 자기 자신을 호출하는 **subprogram**이다.
- 재귀 호출 함수는 **result**로 선언된 변수를 통해 리턴된다.
```fortran
program recursive_property
  implicit none
  integer :: n, res

  print *, 'Input positive integer'
  read *, n

  res = factorial(n)
  print *, res

  call fac_routine(n,res)
  print *, res

contains
  recursive integer function factorial(n) result(fact)
    implicit none
    integer, intent(in) :: n
    if (n == 0) then
       fact = 1
    else
       fact = n*factorial(n-1)
    end if
  end function factorial

  recursive subroutine fac_routine(n,fact)
    implicit none
    integer, intent(in) :: n
    integer, intent(out) :: fact
    if (n == 0) then
       fact = 1
    else
       call fac_routine(n-1,fact)
       fact = n * fact
    end if
  end subroutine fac_routine
end program recursive_property
```
```sh
$ ./a.out
 Input positive integer
6
         720
         720
```

# Value attribute
**subprogram**에서의 값은 변경될 수 있지만, 실제 **argument** 값은 변하지 않는다.
```fortran
program value
  implicit none
  real :: x=1.1
  call call_by_value(x)
  print *, x

  call call_by_reference(x)
  print *, x

contains
  subroutine call_by_value(d)
    implicit none
    real, value :: d
    d = 2*d
    print *, d
  end subroutine call_by_value

  subroutine call_by_reference(d)
    implicit none
    real :: d
    d = 2*d
    print *, d
  end subroutine call_by_reference
end program value
```
```sh
$ ./a.out
   2.20000005    
   1.10000002    
   2.20000005    
   2.20000005
```

# Keyword argument
- `Subroutine` 이나 `function`의 **argument** 이름을 **keyword**로 사용하여 값을 넣어 줄 수 있다. 단, `interface block`이나 `contains`처럼 명시적 인터페이스에서 사용 가능하다.

```fortran
program keyword_arg
  implicit none
  interface
     subroutine axis(x0,y0,l,min,max,i)
       implicit none
       real, intent(in) :: x0, y0, l ,min, max
       integer, intent(in) :: i
     end subroutine axis
  end interface

  call axis(0.0, 0.0, 100.0, 0.1, 1.0, 10)
  print *, '---------'
  call axis(0.0,0.0, max=1.0, min=0.1, l=100.0, i=10)
end program keyword_arg

subroutine axis(x0,y0,l,min,max,i)
  implicit none
  real, intent(in) :: x0, y0, l ,min, max
  integer, intent(in) :: i
  print *, 'x0=',x0
  print *, 'y0=',y0
  print *, 'l=',l
  print *, 'min=',min
  print *, 'max=',max
  print *, 'i=',i
end subroutine axis
```
```sh
$ ./a.out
 x0=   0.00000000    
 y0=   0.00000000    
 l=   100.000000    
 min=  0.100000001    
 max=   1.00000000    
 i=          10
 ---------
 x0=   0.00000000    
 y0=   0.00000000    
 l=   100.000000    
 min=  0.100000001    
 max=   1.00000000    
 i=          10
```

# Optional argument
- `Optional`로 선언된 인수는 생략이 가능하다.
- 생랼된 인수는 **keyword**로 넣어주어야 한다.
- 명시적 인터페이스에서 사용 가능하다.
- `present(arg_name)` : `optional` 인수가 있는지 확인한다.

```fortran
program optional_arg
  implicit none
  integer :: ierr

  call opt_rtn()
  call opt_rtn(a=2.0)
  call opt_rtn(b=3)
  call opt_rtn(b=3,a=2.0)
  print *, '------------'
  ierr = opt_func()
  ierr = opt_func(a=2.0)
  ierr = opt_func(b=3)
  ierr = opt_func(b=3,a=2.0)

contains
  subroutine opt_rtn(a,b)
    implicit none
    real, intent(in), optional :: a
    integer, intent(in), optional :: b
    real :: ay
    integer :: bee

    ay=1.0; bee=1
    if(present(a)) ay=a
    if(present(b)) bee=b
    print *, 'ay=',ay,'bee=',bee
  end subroutine opt_rtn
  
  integer function opt_func(a,b)
    implicit none
    real, intent(in), optional :: a
    integer, intent(in), optional :: b
    real :: ay
    integer :: bee

    ay=1.0; bee=1
    if(present(a)) ay=a
    if(present(b)) bee=b
    print *, 'ay=',ay,'bee=',bee
  end function opt_func
end program optional_arg
```
```sh
$ ./a.out
 ay=   1.00000000     bee=           1
 ay=   2.00000000     bee=           1
 ay=   1.00000000     bee=           3
 ay=   2.00000000     bee=           3
 ------------
 ay=   1.00000000     bee=           1
 ay=   2.00000000     bee=           1
 ay=   1.00000000     bee=           3
 ay=   2.00000000     bee=           3
```

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
$ ./a.out
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
> - 유도타입(derived type)은 parameter 성질을 가질 수 업다. 
> - 아래 예제의 `sphere`와 같이 이미 정의된 유도 타입 `cooord_3d` 이용해 새로운 유도 타입을 정의할 수 있다. 
> - `%` 연산자를 사용하여 아래 `ball`과 같이 두 가지 방법으로 값을 할당한다.
> - 배열을 포함하는 유도 타입의 작성이 가능하다.

- **Example**
```fortran
program derivedtype
  implicit none
  type coord_3d
     real::x,y,z
  end type coord_3d
  type sphere
     type(coord_3d) :: center
     real :: radius
  end type sphere

  type(coord_3d)::pt1, pt2=coord_3d(2.0,2.0,2.0), pt3
  type(sphere)::ball

  ball=sphere(center=pt2,radius=3.0)
  or
  ball%center%x=2.0; ball%center%y=2.0; ball%center%z=2.0; ball%radius=3.0; 
  
  pt1%x=1.0; pt1%y=1.0; pt1%z=1.0
  pt3=coord_3d(3.0,3.0,3.0)
  print*, pt1
  print*, pt2
  print*, pt3
  print*, ball
end program derivedtype
```
`sphere`는 `coord_3d`의 **supertype**이다. 
```bash
$ ./a.out
   1.00000000       1.00000000       1.00000000    
   2.00000000       2.00000000       2.00000000    
   3.00000000       3.00000000       3.00000000
   2.00000000       2.00000000       2.00000000       3.00000000
```
