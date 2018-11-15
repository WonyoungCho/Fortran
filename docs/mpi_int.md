
# Introduction

**MPI**를 구현하기 위해서는 코드내에 `mpi_f08` 헤더파일을 반드시 포함한다.
```bash
program hello
use mpi_f08'
...
```

# Compile

```bash
$ mpif90 -o a.out file_name.f90
```
몇 개의 **process**로 할 것인가는 `-np` 옵션을 사용한다.
```bash
$ mpirun -np 4 ./a.out
```
