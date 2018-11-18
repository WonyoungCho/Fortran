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
  
  print *, 'Hello World! (Process name = ', trim(name), ', Rank = ', rank, ', nProcs = ',proc, ')'
  
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
     print *, 'send1'
     call mpi_recv(b, buf_size, mpi_double_precision, 1, 55, mpi_comm_world, status)
     print *, 'recv1'
  elseif (rank == 1) then
     call mpi_send(a, buf_size, mpi_double_precision, 0, 55, mpi_comm_world)
     print *, 'send2'
     call mpi_recv(b, buf_size, mpi_double_precision, 0, 11, mpi_comm_world, status)
     print *, 'recv2'
  endif

  print *, 'Source = ', status%mpi_source, 'tag = ', status%mpi_tag
  call mpi_finalize
  print *, 'finish'
end program deadlock_blocking
```
`rank0`과 `rank0` 둘 다 보내고 있는 상황이다. `mpi_send`는 보내는 작업이 끝나야 다음 작업을 실행하는데, 받을 준비가 된 프로세서가 없어 **deadlock**에 걸린 상태이다. **Isend**와 **Irecv**를 통해 이를 해결할 수 있다.

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
     print *, 'send1'
     call mpi_irecv(b, buf_size, mpi_double_precision, 1, 55, mpi_comm_world, ireq2)
     print *, 'recv1'
  elseif (rank == 1) then
     call mpi_isend(a, buf_size, mpi_double_precision, 0, 55, mpi_comm_world, ireq1)
     print *, 'send2'
     call mpi_irecv(b, buf_size, mpi_double_precision, 0, 11, mpi_comm_world, ireq2)
     print *, 'recv2'
  endif

  call mpi_wait(ireq1, status)
  print *, 'wait1 source = ', status%mpi_source, 'tag = ', status%mpi_tag
  call mpi_wait(ireq2, status)
  print *, 'wait2 source = ', status%mpi_source, 'tag = ', status%mpi_tag
  call mpi_finalize
  print *, 'finish'
end program non_blocking
```
**if**문을 통해 `rank0`과 `rank1`은 각각 작업을 실행한다. `rank0`과 `rank1`은 `mpi_isend`를 통해 잡을 보내고 `mpi_irecv`를 실행하게 되며 **if**문을 빠져나온다. 이 후 `rank0`과 `rank1`의 `mpi_isend`는 첫 번째 `mpi_wait`를 만나게 되어 작업이 끝나길 기다리고, `mpi_irecv`는 두 번째 `mpi_wait`를 만나게 되어 작업이 끝나면 전체 작업이 종료된다.
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

# Broadcast

한 프로세서의 데이터를 다른 프로세서에 모두 전달하는 방식이다.

`mpi_bcast(buf, count, datatype, root, mpi_comm_world)`

- buf : 전송 버퍼 시작 주소
- INTEGER count : 전송할 버퍼의 원소 갯수
- TYPE(MPI_DATATYPE) datatype : 받는 버퍼 원소의 데이터 타입 (ex. MPI_INTEGER)
- INTEGER root : 전송할 데이터가 있는 프로세스 rank
- TYPE(MPI_COMM) comm : **MPI** communicator, MPI_COMM_WORLD
---

- **Example - Broadcast**
```fortran
program bcast
  use mpi_f08
  implicit none
  integer :: nproc, rank, buf(4)

  data buf/0, 0, 0, 0/

  call mpi_init
  call mpi_comm_size(mpi_comm_world, nproc)
  call mpi_comm_rank(mpi_comm_world, rank)

  if (rank == root) then
    buf(1) = 5; buf(2) = 6; buf(3) = 7; buf(4) = 8
  endif

  print *, 'rank = ', rank, ' before :', buf

  call mpi_bcast(buf, 4, mpi_integer, 0, mpi_comm_world)

  print *, 'rank = ', rank, ' after  :', buf

  call mpi_finalize
end program bcast
```
```sh
$ mpirun -np 4 ./a.out
 rank =            0  before :           5           6           7           8
 rank =            3  before :           0           0           0           0
 rank =            2  before :           0           0           0           0
 rank =            1  before :           0           0           0           0
 rank =            2  after  :           5           6           7           8
 rank =            0  after  :           5           6           7           8
 rank =            1  after  :           5           6           7           8
 rank =            3  after  :           5           6           7           8
```

# Gather

각 프로세서에 있는 동일한 크기의 데이터를 취합할 때 사용한다.

`mpi_gather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, mpi_comm_world)`

- sendbuf : 전송 버퍼 시작 주소
- INTEGER sendcount : 전송할 버퍼의 원소 갯수
- TYPE(MPI_DATATYPE) sendtype : 전송 버퍼 원소의 데이터 타입 (ex. MPI_INTEGER)
- recvbuf : 취합될 버퍼 시작 주소
- INTEGER recvcount : 취합될 버퍼의 원소 갯수 (sendcount 와 동일한 수)
- TYPE(MPI_DATATYPE) recvtype : 취합될 버퍼 원소의 데이터 타입 (ex. MPI_INTEGER)
- INTEGER root : 취합 프로세스 rank
- TYPE(MPI_COMM) comm : **MPI** communicator, MPI_COMM_WORLD

### Allgather
모든 프로세서에서 각 프로세서의 동일한 크기의 데이터를 취합한다.

`mpi_allgather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, mpi_comm_world)`

---

- **Example - Gather**
```fortran
program gather
  use mpi_f08
  implicit none
  integer :: nproc, rank, buf(4)
  integer :: send, recv(4)
  
  call mpi_init
  call mpi_comm_rank(mpi_comm_world, rank)
  
  send = rank + 1
  
  print *, 'rank = ', rank, ' send :', send
  
  call mpi_gather(send, 1, mpi_integer, recv, 1, mpi_integer, 0, mpi_comm_world)
  
  if (rank == 0) then
    print *, 'rank = ', rank, ' recv :', recv
  endif
   
  call mpi_finalize
end program gather
```
```sh
$ mpirun -np 4 ./a.out
 rank =            1  send :           2
 rank =            3  send :           4
 rank =            2  send :           3
 rank =            0  send :           1
 rank =            0  recv :           1           2           3           4
```
 
# Gatherv
취합하려는 각 프로세서의 데이터 갯수가 다를 때 사용된다.
 
`mpi_gatherv(sendbuf, sendcount, sendtype, recvbuf, recvcount, displ, recvtype, root, mpi_comm_world)`

- sendbuf : 전송 버퍼 시작 주소
- INTEGER sendcount : 전송할 버퍼의 원소 갯수
- TYPE(MPI_DATATYPE) sendtype : 전송 버퍼 원소의 데이터 타입 (ex. MPI_INTEGER)
- recvbuf : 취합될 버퍼 시작 주소
- INTEGER recvcount : 취합될 버퍼의 원소 갯수 (sendcount 와 동일한 수)
- INTEGER displ : 취합된 데이터가 위치할 버퍼 위치 (배열로 설정)
- TYPE(MPI_DATATYPE) recvtype : 취합될 버퍼 원소의 데이터 타입 (ex. MPI_INTEGER)
- INTEGER root : 취합 프로세스 rank
- TYPE(MPI_COMM) comm : **MPI** communicator, MPI_COMM_WORLD

### Allgatherv
모든 프로세서가 각 프로세서에서 취합하려는 데이터 갯수가 다를 때 사용된다.
 
`mpi_gatherv(sendbuf, sendcount, sendtype, recvbuf, recvcount, displ, recvtype, mpi_comm_world)`

---

- **Example - Gatherv**
```fortran
program gatherv
  use mpi_f08
  implicit none
  integer :: nproc, rank, buf(4)
  integer :: send(3), recv(6)
  integer :: scount(0:2) displ(0:2)
  data scount/1, 2, 3/ displ/0, 1, 3/
  
  call mpi_init
  call mpi_comm_rank(mpi_comm_world, rank)
  
  do i = 1, rank + 1
    send(i) = rank + 1
  enddo
  scount = rank + 1
  
  call mpi_gatherv(send, scount, mpi_integer, recv, rcount, displ, mpi_integer, 0, mpi_comm_world)
  
  if (rank == 0) then
    print *, 'rank = ', rank, ' recv =', recv
  endif
   
  call mpi_finalize
end program gatherv
```
```sh
$ mpirun -np 3 ./a.out
 rank           0 recv =           1           2           2           3           3           3
```

# Scatter
한 프로세서의 데이터를 다른 프로세서로 동일한 크기의 데이터를 뿌릴때 사용된다. `gather`과 반대 과정으로 생각하면 되고, 변수 배열도 같다.

`mpi_scatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, displ, recvtype, root, mpi_comm_world)`

### Scatterv
한 프로세서의 데이터를 다른 프로세서로 다른 크기의 데이터를 뿌릴때 사용된다. `gatherv`와 반대 과정으로 생각하면 된다.

`mpi_scatterv(sendbuf, sendcount, sendtype, recvbuf, recvcount, displ, recvtype, root, mpi_comm_world)`


# Reduce
각 프로세서의 데이터를 연산자를 통하여 계산하여 도출하는 방식이다.

`mpi_reduce(sendbuf, recvbuf, count, datatype, op, root, mpi_comm_world)`

- TYPE(MPI_Op) op : 취합할 때 연산자이다.
---

- **Example - Reduce**
```fortran
program reduce
  use mpi_f08
  implicit none
  integer :: nproc, rank, ista, iend, i
  real :: a(9), sum, tsum

  call mpi_init
  call mpi_comm_size(mpi_comm_world, nproc)
  call mpi_comm_rank(mpi_comm_world, rank)

  ista = rank * nproc
  iend = (rank + 1) * nproc - 1

  do i=ista, iend
    a(i) = i
  enddo

  sum = 0.0
  do i=ista, iend
    sum = sum + a(i)
  enddo

  call mpi_reduce(sum, tsum, 1, mpi_real, mpi_sum, 0, mpi_comm_world)

  if (rank == 0) then
    print *, 'sum =', tsum
  endif
  call mpi_finalize
end program reduce
```
```sh
$ mpirun -np 4 ./a.out
 sum =   114.000000
```

### Allreduce
각각의 프로세서에서 동일한 갯수만큼 각각의 프로세서에 취합된다. 행렬의 **trace** 비슷하다.

`mpi_allreduce(sendbuf, recvbuf, count, datatype, op, root, mpi_comm_world)`

# AlltoAll
`Allgather`의 확장버전이다.

`mpi_alltoal(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, mpi_comm_world)`

- **Example - AlltoAll**
```fortran
program alltoall
  use mpi_f08
  implicit none
  integer :: nproc, rank, i
  integer :: send(3), recv(3)

  call mpi_init
  call mpi_comm_size(mpi_comm_world, nproc)
  call mpi_comm_rank(mpi_comm_world, rank)

  do i = 1, nproc
    send(i) = i + nproc * rank
  enddo

  print *, 'send=', send

  call mpi_alltoall(send, 1, mpi_integer, recv, 1, mpi_integer, mpi_comm_world)

  print *, 'recv=', recv

  call mpi_finalize
end program alltoall
```
```sh
$ mpirun -np 3 ./.aout
 send=           4           5           6
 send=           7           8           9
 send=           1           2           3
 recv=           3           6           9
 recv=           2           5           8
 recv=           1           4           7
```

### AlltoAllv

`mpi_alltoal(sendbuf, sendcount, sendtype, recvbuf, recvcount, displ, recvtype, mpi_comm_world)`



# Derived data type
여러 타입의 변수들을 묶어서 새로운 타입의 변수로 사용할 때 사용된다. **c**의 구조체와 비슷하다.

변수를 묶어 새로운 타입으로 쓰려면 약속이 필요하다.

`MPI_TYPE_COMMIT(datatype, ierr)`

작업이 끝나면 새로 정의한 변수를 없애준다.

`MPI_TYPE_FREE(datatype, ierr)`
## Contiguous
연속된 데이터를 묶을 때 사용한다.

rank0|1|2|3|4|5|6|7|8|9|10|11|12|13|14
---|---|---|---|---|---|---|---|---|---|---|---|---|---|---
rank1|-|-|D|D|D|**D**|**D**|**D**|D|D|D|-|-|-

: `MPI_TYPE_CONTIGUOUS(3, oldtype, newtype)`

`MPI_TYPE_CONTIGUOUS(count, oldtype, newtype)`

- INTEGER count : 묶을 데이터 갯수
- INTEGER oldtype : 묶는 데이터들의 타입 (ex. MPI_INTEGER)
- TYPE(MPI_datatype) newtype : 묶은 데이터들의 새로운 타입
---

- **Example - Contiguous**
```fortran
program type_contiguous
  use mpi_f08
  implicit none
  integer :: rank, ibuf(14), i
  type(mpi_datatype) :: newtype
  
  ibuf=0
  
  call mpi_init
  call mpi_comm_rank(mpi_comm_world, rank)
  
  if (rank == 0) then
     do i = 1, 14
        ibuf(i) = i
     enddo
  endif
  
  call mpi_type_contiguous(3, mpi_integer, newtype)
  call mpi_type_commit(newtype)
  call mpi_bcast(ibuf(3), 3, newtype, 0, mpi_comm_world)
  
  print *, 'rank', rank, 'ibuf =', ibuf
  
  call mpi_type_free(newtype)
  call mpi_finalize
end program type_contiguous
```
```sh
$ mpirun -np 2 ./a.out
 rank    0 ibuf =    1    2    3    4    5    6    7    8    9   10   11   12   13   14
 rank    1 ibuf =    0    0    3    4    5    6    7    8    9   10   11    0    0    0
```

## Vector

데이터를 선택적으로 가져온다.

rank0|1|2|3|4|5|6|7|8|9|10|11|12|13|14
---|---|---|---|---|---|---|---|---|---|---|---|---|---|---
rank1|D|D|D|-|-|**D**|**D**|**D**|-|-|D|D|D|-

: `MPI_TYPE_VECTOR(3, 3, 5, newtype)`

`MPI_TYPE_VECTOR(count, blocklength, stride, newtype)`

- INTEGER count : 묶을 데이터 갯수
- INTEGER blocklength : 묶을 블럭 갯수
- INTEGER stride : 한 블럭의 묶을 데이터 갯수
- TYPE(MPI_datatype) newtype : 묶은 데이터들의 새로운 타입
---

```fortran
program type_vector
  use mpi_f08
  implicit none
  integer :: rank, ibuf(14), i
  type(mpi_datatype) :: newtype
  
  ibuf=0
  
  call mpi_init
  call mpi_comm_rank(mpi_comm_world, rank)
  
  if (rank == 0) then
     do i = 1, 14
        ibuf(i) = i
     enddo
  endif
  
  call mpi_type_vector(3, 3, 5, mpi_integer, newtype)
  call mpi_type_commit(newtype)
  call mpi_bcast(ibuf, 1, newtype, 0, mpi_comm_world)
  
  print *, 'rank', rank, 'ibuf =', ibuf
  
  call mpi_type_free(newtype)
  call mpi_finalize
end program type_vector
```
```sh
$ mpirun -np 2 ./a.out
 rank    0 ibuf =    1    2    3    4    5    6    7    8    9   10   11   12   13   14
 rank    1 ibuf =    1    2    3    0    0    6    7    8    0    0   11   12   13    0
```
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
`subroutine para_range`는 계산하고자 하는 구간을 나눌때  사용한다.
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
