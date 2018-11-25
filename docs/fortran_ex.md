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

## Array structure

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

## Array function
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

## Array expression
```fortran
program array
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
end program array
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
