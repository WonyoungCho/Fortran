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
