# Programming for Fortran.

This is a tutorial review of Fortran language.

# Compile

``` no-highlight
$ gfortran -o a file_name
      
$ gfortran -fopenmp -o a file_name
```

# CPU TIME
``` bash
real :: start, finish
call cpu_time(start)

   ! code here !

call cpu_time(finish)
print '("Time = ",f6.3," seconds.")',finish-start
```
or

```bash
$ time ./a.out
```
