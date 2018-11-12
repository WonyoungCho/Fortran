# Programming with Fortran.

**Fortran** 언어를 기본으로 하여 병렬처리 방법인 `OpenMP`와 `MPI` 사용법에 대하여 예제와 함께 공부할 수 있는 공간입니다.

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
