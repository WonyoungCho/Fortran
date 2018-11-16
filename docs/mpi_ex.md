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

`MPI_TYPE_COMMIT(datatype, ierr)`
## Contiguous
연속된 데이터를 묶을 때 사용한다.

`MPI_TYPE_CONTIGUOUS(count, oldtype, newtype, ierr)`
- INTEGER count : 묶을 데이터 갯수
- INTEGER oldtype : 묶는 데이터들의 타입 (ex. MPI_INTEGER)
- INTEGER newtype : 묶은 데이터들의 새로운 

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
