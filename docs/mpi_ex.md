# Hello World!

```fortran
program hello
  use mpi_f08
  implicit none
  
  call mpi_init
  print *, 'Hello World!'
  call mpi_finalize
end program hello
```
```sh
$ mpirun -np 4 ./a.out
 Hello World!
 Hello World!
 Hello World!
 Hello World!
```

또는

```fortran
program  hello
  use mpi_f08
  implicit none
  integer :: nproc, rank, namelen
  character*(mpi_max_processor_name) :: name
  
  call mpi_init
  call mpi_comm_size(mpi_comm_world, nproc)
  call mpi_comm_rank(mpi_comm_world, rank)
  
  call mpi_get_processor_name(name, namelen)
  
  print*, 'Hello World! (Process name = ', trim(name), ', Rank = ', rank, ', nProcs = ',proc, ')'
  
  call mpi_finalize
end program hello  
```
```sh
$ mpirun -np 4 ./a.out
 Hello World! (Process name = ycho, Rank =            3 , nProcs =            4 )
 Hello World! (Process name = ycho, Rank =            1 , nProcs =            4 )
 Hello World! (Process name = ycho, Rank =            2 , nProcs =            4 )
 Hello World! (Process name = ycho, Rank =            0 , nProcs =            4 )
```

# Block & Non-blocking communication
- **Blocking** 통신에는 `MPI_SEND`와 `MPI_RECV`가 있으며, 잡이 다 실행될때까지 다음 명령을 실행하지 않는다.
- **Non-blocking** 통신에는 대표적으로 `MPI_ISEND`와 `MPI_IRECV`가 있으며, 잡을 보내놓고 다음 명령을 실행한다. **Non-blocking** 통신에서 전송이 완료 되었는지 확인 될때까지 기다리는 `MPI_WAIT(ireq, status)` 가 있다.


## Send & Recv
**Send**와 **Recv**는 편지봉투에 편지를 써서 보내는 것과 같이 생각하면 된다. 구성은 앞에 3개의 data 부분과 그 뒤로 3개의 envelope 부분으로 나누어 진다.

```fortran
mpi_send(buf, count, datatype, dest, tag, comm)
```
- buf : 보낼 버퍼의 시작 주소
- INTEGER count : 보낼 버퍼의 원소 갯수
- TYPE(MPI_DATATYPE) datatype : 보낼 버퍼 원소의 데이터 타입 (ex. MPI_REAL)
- INTEGER dest : 보내려는 프로세스의 rank
- INTEGER tag : 보내는 메시지의 tag 번호 (임의의 값을 정해주면 된다.)
- INTEGER comm : **MPI** communicator, MPI_COMM_WORLD

```fortran
mpi_recv(buf, count, datatype, source, tag, comm, status)
```
- buf : 받는 버퍼의 시작 주소
- INTEGER count : 받는 버퍼의 원소 갯수 (보내는 원소 갯수보다 같거나 많아야 한다.)
- TYPE(MPI_DATATYPE) datatype : 받는 버퍼 원소의 데이터 타입 (ex. MPI_REAL)
- INTEGER source : 보내진 원소의 프로세스 rank
- INTEGER tag : 받는 메시지의 tag 번호 (보내는 메시지의 tag 번호와 같아야 한다.)
- INTEGER comm : **MPI** communicator, MPI_COMM_WORLD
- TYPE(MPI_STATUS) status : 받은 메시지의 정보를 가지고 있다. (MPI_SOURCE, MPI_TAG, MPI_ERROR) 정보가 필요 없으면 `MPI_STATUS_IRNORE`
---

- **Example - Send & Recv**
```fortran
program blocking
  use mpi_f08
  integer :: nproc, rank, count
  real data(100), value(200)
  type(mpi_status) :: status
  
  call mpi_init
  call mpi_comm_size(mpi_comm_world,nproc)
  call mpi_comm_rank(mpi_comm_world,rank)
  
  if (rank.eq.0) then
     data=3.0
     call mpi_send(data, 100, mpi_real, 1, 11, mpi_comm_world)
  elseif (rank .eq. 1) then
     call mpi_recv(value,200, mpi_real, mpi_any_source, 11, mpi_comm_world, status)

     print *, "p:",rank," got data from processor ",status%mpi_source

     call mpi_get_count(status,mpi_real,count)

     print *, "p:",rank," got ",count," elements"
     print *, "p:",rank," value(5)=",value(5)
  endif
  call mpi_finalize
end program blocking
```
```sh
$ mpirun -np 2 ./a.out
 p:           1  got data from processor            0
 p:           1  got          100  elements
 p:           1  value(5)=   3.00000000 
```
---

- **Example - Deadlock blocking**

다음은 **Deadlock blocking**의 예이다. 
```fortran
program  deadlock_blocking
  use mpi_f08
  integer :: nprocs, rank, i
  integer, parameter :: buf_size = 1500
  double precision , dimension(buf_size) :: a, b
  type(mpi_status) :: status
  
  call mpi_init
  call mpi_comm_size(mpi_comm_world, nprocs)
  call mpi_comm_rank(mpi_comm_world, rank)

  if (rank == 0) then
     call mpi_send(a, buf_size, mpi_double_precision, 1, 11, mpi_comm_world)
     print*, 'send1'
     call mpi_recv(b, buf_size, mpi_double_precision, 1, 55, mpi_comm_world, status)
     print*, 'recv1'
  elseif (rank == 1) then
     call mpi_send(a, buf_size, mpi_double_precision, 0, 55, mpi_comm_world)
     print*, 'send2'
     call mpi_recv(b, buf_size, mpi_double_precision, 0, 11, mpi_comm_world, status)
     print*, 'recv2'
  endif

  print*, 'Source = ', status%mpi_source, 'tag = ', status%mpi_tag
  call mpi_finalize
  print*, 'finish'
end program deadlock_blocking
```
`rank0`과 `rank0` 둘 다 보내고 있는 상황이다. `mpi_send`는 보내는 작업이 끝나야 다음 작업으로 실행하는데, 받을 준비가 된 프로세서가 없어 **deadlock**에 걸린 상태이다. **Isend**와 **Irecv**를 통해 이를 해결할 수 있다.

## Isend & Irecv
**Isend**와 **Irecv**는 **Non-block** 통신으로 잡을 보내놓고 다음 명령을 실행한다. 구성은 앞에 3개의 data 부분과 그 뒤로 3개의 envelope 부분, 1개의 request로 총 3부분으로 나누어 진다.

```fortran
mpi_isend(buf, count, datatype, dest, tag, comm, ireq)
```
- buf : 보낼 버퍼의 시작 주소
- INTEGER count : 보낼 버퍼의 원소 갯수
- TYPE(MPI_DATATYPE) datatype : 보낼 버퍼 원소의 데이터 타입 (ex. MPI_REAL)
- INTEGER dest : 보내려는 프로세스의 rank
- INTEGER tag : 보내는 메시지의 tag 번호 (임의의 값을 정해주면 된다.)
- TYPE(MPI_COMM) comm : **MPI** communicator, MPI_COMM_WORLD
- TYPE(mpi_request) ireq : 통신 식별에 이용

```fortran
mpi_irecv(buf, count, datatype, source, tag, comm, ireq)
```
- buf : 받는 버퍼의 시작 주소
- INTEGER count : 받는 버퍼의 원소 갯수 (보내는 원소 갯수보다 같거나 많아야 한다.)
- TYPE(MPI_DATATYPE) datatype : 받는 버퍼 원소의 데이터 타입 (ex. MPI_REAL)
- INTEGER source : 보내진 원소의 프로세스 rank
- INTEGER tag : 받는 메시지의 tag 번호 (보내는 메시지의 tag 번호와 같아야 한다.)
- TYPE(MPI_COMM) comm : **MPI** communicator, MPI_COMM_WORLD
- TYPE(mpi_request) ireq : 통신 식별에 이용
---

- **Example - Isend & Irecv**
```fortran
program  non_blocking
  use mpi_f08
  integer :: nprocs, rank, i
  integer, parameter :: buf_size = 1500
  double precision , dimension(buf_size) :: a, b
  type(mpi_status) :: status
  type(mpi_request) :: ireq1, ireq2
  
  call mpi_init
  call mpi_comm_size(mpi_comm_world, nprocs)
  call mpi_comm_rank(mpi_comm_world, rank)

  if (rank == 0) then
     call mpi_isend(a, buf_size, mpi_double_precision, 1, 11, mpi_comm_world, ireq1)
     print*, 'send1'
     call mpi_irecv(b, buf_size, mpi_double_precision, 1, 55, mpi_comm_world, ireq2)
     print*, 'recv1'
  elseif (rank == 1) then
     call mpi_isend(a, buf_size, mpi_double_precision, 0, 55, mpi_comm_world, ireq1)
     print*, 'send2'
     call mpi_irecv(b, buf_size, mpi_double_precision, 0, 11, mpi_comm_world, ireq2)
     print*, 'recv2'
  endif

  call mpi_wait(ireq1, status)
  print*, 'wait1 source = ', status%mpi_source, 'tag = ', status%mpi_tag
  call mpi_wait(ireq2, status)
  print*, 'wait2 source = ', status%mpi_source, 'tag = ', status%mpi_tag
  call mpi_finalize
  print*, 'finish'
end program non_blocking
```
```sh
$ mpirun -np 2 ./a.out
 send1
 recv1
 wait1 source =            0 tag =           17
 wait2 source =            1 tag =           19
 send2
 recv2
 wait1 source =            1 tag =           19
 wait2 source =            0 tag =           17
 finish
 finish
```


# Derived data type
여러 타입의 변수들을 묶어서 새로운 타입의 변수로 사용할 때 사용된다. **c**의 구조체와 비슷하다.

변수를 묶어 새로운 타입으로 쓰려면 약속이 필요하다.

`MPI_TYPE_COMMIT(datatype, ierr)`

작업이 끝나면 새로 정의한 변수를 없애준다.

`MPI_TYPE_FREE(datatype, ierr)`
## Contiguous
연속된 데이터를 묶을 때 사용한다.

1|2|3|4|5|6|7|8|9|10|11
---|---|---|---|---|---|---|---|---|---|---
-|-|R|R|-|R|R|-|R|R|-



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
