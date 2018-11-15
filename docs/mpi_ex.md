# Hello World!

```fortran
PROGRAM hello
  use mpi_f08
  INTEGER iErr
  
  CALL MPI_Init(iErr)
  WRITE (*, *) 'Hello World!'
  CALL MPI_Finalize(iErr)
END PROGRAM hello
```
```sh
$ mpirun -np 4 ./a.out
 Hello World!
 Hello World!
 Hello World!
 Hello World!
```


