
# Introduction

**MPI**를 구현하기 위해서는 코드내에 `mpi_f08` 헤더파일을 반드시 포함한다.
```fortran
program hello
use mpi_f08
...
```

**MPI**의 통신방식에는 [ 점 대 점 ] 와 [ 점 대 다수] 의 두가지 방식이 있다.

# Compile

```bash
$ mpif90 -o a.out file_name.f90
```
몇 개의 **process**로 할 것인가는 `-np` 옵션을 사용한다.
```bash
$ mpirun -np 4 ./a.out
```

# Useful site
- <a href='https://www.mpi-forum.org/' target='_blank'> https://www.mpi-forum.org/ </a>
