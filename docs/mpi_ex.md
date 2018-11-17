# Hello World!

```fortran
program hello
  use mpi_f08
  integer :: ierr
  
  call mpi_init(ierr)
  print *, 'Hello World!'
  call mpi_finalize(ierr)
end program hello
```
```sh
$ mpirun -np 4 ./a.out
 Hello World!
 Hello World!
 Hello World!
 Hello World!
```

# Derived data type
여러 타입의 변수들을 묶어서 새로운 타입의 변수로 사용할 때 사용된다. **c**의 구조체와 비슷하다.

변수를 묶어 새로운 타입으로 쓰려면 약속이 필요하다.

`MPI_TYPE_COMMIT(datatype, ierr)`

작업이 끝나면 새로 정의한 변수를 없애준다.

`MPI_TYPE_FREE(datatype, ierr)`
## Contiguous
연속된 데이터를 묶을 때 사용한다.

D1 | D2 | D3
----|---|---


`MPI_TYPE_CONTIGUOUS(count, oldtype, newtype, ierr)`

- INTEGER count : 묶을 데이터 갯수
- INTEGER oldtype : 묶는 데이터들의 타입 (ex. MPI_INTEGER)
- INTEGER newtype : 묶은 데이터들의 새로운 타입
```fortran
PROGRAM type_contiguous
  INCLUDE 'mpif.h'
  INTEGER ibuf(20)
  INTEGER inewtype
  ibuf=0
  CALL MPI_INIT(ierr)
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, myrank, ierr)
  IF (myrank==0) THEN
     DO i=1,20
        ibuf(i) = i
     ENDDO
  ENDIF
  CALL MPI_TYPE_CONTIGUOUS(3, MPI_INTEGER, inewtype, ierr)
  CALL MPI_TYPE_COMMIT(inewtype, ierr)
  CALL MPI_BCAST(ibuf, 3, inewtype, 0, MPI_COMM_WORLD, ierr)
  PRINT *,'ibuf =',ibuf
  CALL MPI_TYPE_FREE(inewtype,ierr);
  CALL MPI_FINALIZE(ierr)
END PROGRAM type_contiguous
```

## Vector


# PI - Numerical Integration

```fortran
PROGRAM pi_integral
  include "mpif.h"

  integer, parameter:: num_steps=1000000000
  real(8) sum, step, x, pi, tsum;
  integer :: i, nprocs, myrank, ierr

  call MPI_INIT(ierr);
  call MPI_Comm_size(MPI_COMM_WORLD,nprocs,ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD,myrank,ierr)

  sum=0.0
  step=1./dble(num_steps)

  call para_range(1, num_steps, nprocs, myrank, ista, iend)
  print*, "myrank =", myrank, ":", ista," ~ ", iend
  do i=ista, iend
     x = (i-0.5)*step
     sum = sum + 4.0/(1.0+x*x)
  enddo

  call MPI_REDUCE(sum, tsum, 1, MPI_REAL8, MPI_SUM, 0, &
       MPI_COMM_WORLD, ierr)

  if(myrank ==0) then
     pi = step*tsum
     print*, "numerical  pi = ", pi
     print*, "analytical pi = ", dacos(-1.d0)
     print*, " Error = ", dabs(dacos(-1.d0)-pi)
  endif

  call MPI_FINALIZE(ierr)

end PROGRAM pi_integral

SUBROUTINE para_range(n1, n2, nprocs, irank, ista, iend)
  iwork1 = (n2 - n1 + 1) / nprocs
  iwork2 = MOD(n2 - n1 + 1, nprocs)
  ista = irank * iwork1 + n1 + MIN(irank, iwork2)
  iend = ista + iwork1 - 1
  IF (iwork2 > irank) iend = iend + 1
END SUBROUTINE para_range
```
`subroutine para_range`는 계산하고자 하는 구간을 나눌때 만히 사용한다.
```sh
$ mpirun -np 4 ./a.out
 myrank =           0 :           1  ~    250000000
 myrank =           2 :   500000001  ~    750000000
 myrank =           1 :   250000001  ~    500000000
 myrank =           3 :   750000001  ~   1000000000
 numerical  pi =    3.1415926525874704
 analytical pi =    3.1415926535897931
  Error =   1.00232266930788683E-009
```
