# Hello World!

```bash
PROGRAM hello
  INCLUDE 'mpif.h'
  INTEGER iErr
  
  CALL MPI_Init(iErr)
  WRITE (*, *) 'Hello World!'
  CALL MPI_Finalize(iErr)
END PROGRAM hello
```
```
 Hello World!
 Hello World!
 Hello World!
 Hello World!
```


