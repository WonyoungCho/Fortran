# Hello World!

```fortran
program hello
  implicit none

  print*, 'Hello World!'
end program hello
```
```sh
$ ./a.out
Hello World!
```

# If

- **Example - usual**
```fortran
if (i > 0) print *, i
```
or
```fortran
if (i > 0) then
  r=i*100
else
  r=-i*100
endif
print *, r
```

- **Example - Arithmetic**

`if (expression) Negative, Zero, Positive`
```fortran
program if
  implicit none
  integer :: i
  
  i = -1
  if (i) 10, 20, 30
  i = 0
  if (i) 10, 20, 30
  i = 1
  if (i) 10, 20, 30
  
10 print *, 'i is negative'
20 print *, 'i is zero'
30 print *, 'i is positive'
```
```sh
$ ./.a.out
 i is negative
 i is zero
 i is positive
```

# Select case
`if`의 순차적인 선택과 다르게 병렬적 선택이며, `if`문 보다 간결하다.
```fortran
program select_case
  implicit none
  integer :: n, k
  
  print *, 'Enter the value ='
  read *, n
  
  select case (n)
    case (:0)
      k = -k
    case (10:20)
      k = n + 10
    case default
      k = n
  end select
  
  print *, 'k =', k
end program select_case
```

# Goto
유용하게 사용하는 기능 중 하나이다. 단순히 `goto 10` 처럼 사용할 수도 있고 다음처럼 조건에 따른 사용도 가능하다.

`GOTO(label 1, label 2, ..., label n) inter 'n'th-label`
```fortran
program merge
  implicit none
  integer :: i
  read *, i
  
  goto(10, 20, 30, 40) mod(i,4)

10 print *, '1'
  goto 50
20 print *, '2'
  goto 50
30 print *, '3'
  goto 50
40 print *, '4'

  print *, 'otherwise'
50 continue
end program merge
```
```sh
$ ./a
3
 3
```

# Do loop

```fortran
program do_loop
  implicit none
  integer :: i=0, j=0

  do
     i = i + 1
     if(mod(i,2)==0)cycle
     if(i > 10)exit
     print *, 'i =', i
  end do

  print *, ''

  do while(j <= 10)
     j = j + 1
     if(mod(j,2)==1)cycle
     print *, 'j =', j
  end do

end program do_loop
```
```sh
$ ./a.out
 i =           1
 i =           3
 i =           5
 i =           7
 i =           9
 
 j =           2
 j =           4
 j =           6
 j =           8
 j =          10
```
 
# Array

- **Example - static array**

고정된 크기를 가지는 행렬이다.
```fortran
real a, b, c
dimension a(100), b(10,10), c(2,3,4)

or

real, dimension(100) :: a      ! 1D
real, dimension(10,10) :: b    ! 2D
real, dimension(2,3,4) :: c    ! 3D

or

real a(100), b(10,10), c(2,3,4)

or

real a(1:100), b(3:12,2:11), c(1:2,4:6,3:6)
```

- **Example - dynamic array**

차원만 정해놓고 크기는 정해놓지 않은 행렬을 말한다.
```fortran
integer, dimension(:), allocatable :: string   ! 1D
```
```fortran
program allocate
  implicit none
  integer, allocatable :: a(:), b(:)
  integer :: istat
  character(80) :: string='Success'

  allocate(a(5), source=1, stat=istat, errmsg=string)
  allocate(b,source=a*10)

  print *, 'State =', istat, 'ErrMSG = ', trim(string)
  print *, a
  print *, b
end program allocate
```
```sh
$ ./a.out
 State =           0 ErrMSG = Success
           1           1           1           1           1
          10          10          10          10          10
```

- **Example - pointer array**

행렬의 값을 **point**해서 보여준다.
```fortran
program pointer
  implicit none
  integer :: l, i, j, k, m, n
  real, target :: b(6,6)=1
  real, pointer :: u(:,:), v(:), w(:,:)
  print *, b
  print *, '---------'  
  m=3; n=2
  i=2; j=4
  n=6
  do k=1,6
     do l=1,6
        b(l,k)=2*l+k
     end do
  end do
  print *, b
  print *, '---------'  
  u => b(i:i+2, j:j+2)
  print *, u
  print *, '---------'  
  allocate(w(m,n))
  w = 9
  v => b(:,j)
  print *, v  
  print *, '---------'  
  v => w(i-1, 1:n:2)

  print *, v
end program pointer
```
아래 결과에서 행렬처럼 적어 두었지만, 사실 결과값은 하나의 열이다.
```sh
$ ./a.out
1.00000000       1.00000000       1.00000000       1.00000000       1.00000000       1.00000000
1.00000000       1.00000000       1.00000000       1.00000000       1.00000000       1.00000000
1.00000000       1.00000000       1.00000000       1.00000000       1.00000000       1.00000000
1.00000000       1.00000000       1.00000000       1.00000000       1.00000000       1.00000000
1.00000000       1.00000000       1.00000000       1.00000000       1.00000000       1.00000000
1.00000000       1.00000000       1.00000000       1.00000000       1.00000000       1.00000000    
 ---------
3.00000000       5.00000000       7.00000000       9.00000000       11.0000000       13.0000000
4.00000000       6.00000000       8.00000000       10.0000000       12.0000000       14.0000000
5.00000000       7.00000000       9.00000000       11.0000000       13.0000000       15.0000000
6.00000000       8.00000000       10.0000000       12.0000000       14.0000000       16.0000000
7.00000000       9.00000000       11.0000000       13.0000000       15.0000000       17.0000000
8.00000000       10.0000000       12.0000000       14.0000000       16.0000000       18.0000000    
 ---------
8.00000000       10.0000000       12.0000000
9.00000000       11.0000000       13.0000000
10.0000000       12.0000000       14.0000000    
 ---------
6.00000000       8.00000000       10.0000000       12.0000000       14.0000000       16.0000000    
 ---------
9.00000000       9.00000000       9.00000000
```

## - structure

**Fortran**과 **C**는 메모리 주소의 구조가 다르다. 주소를 채우는 방식을 알고 있어야 데이터를 다룰 때 올바로 다룰 수 있다. `loop`문을 다룰 때도 배열의 이해가 요구된다.

a(0,0)|*a(0,1)*|a(0,2)
:-:|:-:|:-:
a(1,0)|*a(1,1)*|a(1,2)
a(2,0)|*a(2,1)*|a(2,2)

- **Column-major order (Fortran)**
```fortran
do j=0,2
  do i=0,2
    print *, a(i,j)
  end do
end do
```

a(0,0)|a(1,0)|a(2,0)|*a(0,1)*|*a(1,1)*|*a(2,1)*|a(0,2)|a(1,2)|a(2,2)
-|-|-|-|-|-|-|-|-

- **Column-major order (C)**
```c
for(i=0;i<3;i++)
  for(i=0;i<3;i++)
    print('%d\n', a[i][j]);
```

a(0,0)|a(0,1)|a(0,2)|*a(1,0)*|*a(1,1)*|*a(1,2)*|a(2,0)|a(2,1)|a(2,2)
-|-|-|-|-|-|-|-|-

## - function
```fortran
program array_function
  implicit none
  integer, dimension(-10:10, 23, 14:28) :: a
  integer :: d(3)

  print *, lbound(a)
  print *, lbound(a,1)

  print *, ubound(a)
  print *, ubound(a,1)

  print *, shape(a)
  print *, size(a)
  print *, size(a,1)

  d = shape(a)

  print *, d
  print *, size(d)
  print *, shape(d)
  
end program array_function
```
```sh
$ ./a.out
         -10           1          14
         -10
          10          23          28
          10
          21          23          15
        7245
          21
          21          23          15
           3
           3
```

## - expression
```fortran
program array_expression
  implicit none
  integer :: i, j, k
  real, dimension(3,3) :: a, c
  real, dimension(9) :: b

  a = reshape((/(k,k=1,9)/),(/3,3/))
  b = (/a + 1.3/)
  c = reshape(b,(/3,3/))

  print *, a
  print *, '-----------'
  print *, b
  print *, '-----------'

  do i=1,3
     print *, c(i,:)
  end do
  print *, '-----------'
  
  b = (/((a(j,k) + 1.3, k=1,3), j=1,3)/)
  c = reshape(b,(/3,3/))

  print *, b
  print *, '-----------'
  do i=1,3
     print *, c(i,:)
  end do
end program array_expression
```
```sh
$ ./a.out
   1.00000000       2.00000000       3.00000000       4.00000000       5.00000000       6.00000000       7.00000000       8.00000000       9.00000000    
 -----------
   2.29999995       3.29999995       4.30000019       5.30000019       6.30000019       7.30000019       8.30000019       9.30000019       10.3000002    
 -----------
   2.29999995       5.30000019       8.30000019    
   3.29999995       6.30000019       9.30000019    
   4.30000019       7.30000019       10.3000002    
 -----------
   2.29999995       5.30000019       8.30000019       3.29999995       6.30000019       9.30000019       4.30000019       7.30000019       10.3000002    
 -----------
   2.29999995       3.29999995       4.30000019    
   5.30000019       6.30000019       7.30000019    
   8.30000019       9.30000019       10.3000002
```

## - reshape
```fortran
reshape(array_data, shape, pad, order)
```
> - array_data : reshape하고자 하는 array.
> - shape : 바꾸려는 shape
> - pad : reshape한 array가 더 클경우 비어있는 위치의 채울 값
> - order : 정렬하고자 하는 차원 (행이 첫 번째 차원, 열이 두 번째 차원)

```fortran
program array_reshape
  implicit none
  integer :: i, j
  integer, parameter, dimension(4,4) :: ident4 = reshape((/(1,(0, i=1,4), j=1,3),1/),(/4,4/))
  integer, dimension(2,2) :: a = reshape((/1,2,3,4/),(/2,2/)), b
  integer :: c(2,3)
  
  do i=1,4
     print *, ident4(i,:)
  end do

  print *, '------------'
  do i=1,2
     print *, a(i,:)
  end do

  print *, '------------'
  b = reshape(a,(/2,2/),order=(/2,1/))
  print *, b(1,:)
  print *, b(2,:)

  print *, '------------'
  c = reshape(a,(/2,3/),pad=(/0/),order=(/2,1/))
  print *, c(1,:)
  print *, c(2,:)
  
end program array_reshape
```
```sh
$ ./a.out
           1           0           0           0
           0           1           0           0
           0           0           1           0
           0           0           0           1
 ------------
           1           3
           2           4
 ------------
           1           2
           3           4
 ------------
           1           2           3
           4           0           0
```

## - mask
`where(mask)`에서 `mask`가 **true**일 때만 배열 원소 값을 할당. 
```
program array_mask
  implicit none
  integer :: i, j
  integer, dimension(2,2) :: a, b = reshape((/2,4,6,8/),(/2,2/)), &
       c = reshape((/2,0,0,2/),(/2,2/))

  where(c /= 0)
     a = b/c
  else where
     a = b
  end where

  print *, b(1,:)
  print *, b(2,:)
  print *, '------------'
  print *, c(1,:)
  print *, c(2,:)
  print *, '------------'
  print *, a(1,:)
  print *, a(2,:)

  
end program array_mask
```
```sh
$ ./a.out
           2           6
           4           8
 ------------
           2           0
           0           2
 ------------
           1           6
           4           4
```

## - forall
`where(mask)`의 확장형이다.
```fortran
program array_forall
  implicit none
  integer :: i, j
  integer, dimension(3,3) :: a = reshape((/(i, i=1,9)/),(/3,3/))

  print *, a(1,:)
  print *, a(2,:)
  print *, a(3,:)
  
  forall(i=1:3,j=1:3,j>i) a(i,j) = 0
  print *, '----------'
  print *, a(1,:)
  print *, a(2,:)
  print *, a(3,:)

end program array_forall
```
```sh
           1           4           7
           2           5           8
           3           6           9
 ----------
           1           0           0
           2           5           0
           3           6           9
```

# Statement function
간단한 함수를 1개의 문장으로 정의해 사용한다.
```fortrans
statment_function(v1,v2,..., vn) = expression
...
variable = statment_function(a1,a2,..., an)
```
```fortran
program statement_function
  implicit none
  integer :: a, b
  integer :: plus_one
  real(8) :: e, m
  real(8), parameter :: c=299792458d0

  plus_one(a) = a + 1
  e(m) = m*c**2

  a = 10
  b = plus_one(a)
  print *, a, b

  m = 1d-3
  print *, e(m)
    
end program statement_function
```
```sh
$ ./a.out
          10          11
   89875517873681.766
```

# Interface block

- ** Example - implicit interface**
```fortran
program implicit
  implicit none
  real :: i=3d0, j=25d0
  real :: ratio

  print *, ratio(i,j)

end program implicit

real function ratio(x,y)
  real :: x, y
    
  ratio = x/y
end function ratio
```
```sh
$ ./a.out
  0.119999997
```

- ** Example - explicit interface**
```fortran
program explicit
  implicit none
  interface
     real function ratio(x,y)
       real :: x, y
     end function ratio
  end interface
  real :: i=3d0, j=25d0

  print *, ratio(i,j)

end program explicit

real function ratio(x,y)
  real :: x, y
    
  ratio = x/y
end function ratio
```
```sh
$ ./a.out
  0.119999997
```

- ** Example - internal procedure**
```fortran
program internal
  implicit none
  real :: i=3d0, j=25d0

  print *, ratio(i,j)

contains
  real function ratio(x,y)
    real :: x, y
    
    ratio = x/y
  end function ratio

end program internal
```
```sh
$ ./a.out
  0.119999997
```

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