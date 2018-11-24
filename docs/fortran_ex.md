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
유용하게 사용하는 기능 중 하나이다. 단순히 `goto 10` 으로 사용할 수도 있고 다음처럼 조건에 따른 사용도 가능하다.

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
 
