
# Introduction

**MPI**는 프로세서 사이의 통신을 통하여 병렬로 작업을 처리하는 방식이다. 프로세서 사이의 통신을 위해서는 **communicator**가 필요하며 default로 `MPI_COMM_WORLD`가 있다. 

**MPI**의 통신방식에는 [ 점 대 점 p2p] 와 [ 점 대 다수 p2m] 의 두가지 방식이 있다. p2p 방식에서는 기본적으로 2가지만 알면 된다.

1. `MPI_SEND`
2. `MPI_RECV`

p2m 방식에서는 여러가지가 있지만, 사용 빈도수가 높은 대표적인 6개의 방식이 있다.

1. `MPI_ISEND`
2. `MPI_IRECV`
3. `MPI_BCAST`
4. `MPI_SCATTER`
5. `MPI_GATHER`
6. `MPI_REDUCE`

**MPI**를 구현하기 위해서는 코드내에 `mpi_f08` 헤더파일을 반드시 포함한다.
```fortran
program hello
use mpi_f08
...
```

코드는 대부분 다음과 같은 틀로 짜여진다.
```fortran
program mpi_default_frame
use mpi_f08
implicit none

integer :: ierr, nproc, nrank

call mpi_init(ierr)
call mpi_comm_size(mpi_comm_world, nproc, ierr)
call mpi_comm_rank(mpi_comm_world, nrank, ierr)

!  code here

call mpi_finalize(ierr)
end program mpi_default_frame
```







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
