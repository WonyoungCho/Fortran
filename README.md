Welcome to visit [Fortran homepage](https://fortran.readthedocs.io/).

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
