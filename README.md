# Compile a fortran file

``` no-highlight
$ gfortran -O3 -o a file_name
      
$ gfortran -O3 -fopenmp -o a file_name
```

# CPU TIME
``` bash
real :: start, finish
call cpu_time(start)

   ! code here !

call cpu_time(finish)
print '("Time = ",f6.3," seconds.")',finish-start
```
