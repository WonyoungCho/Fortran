# Isend & Irecv

`MPI_Isend`와 `MPI-Irecv`는 **Non-blocking** 통신 방법으로, 값을 **return** 받지 않아도 다음 작업으로 진행된다.

- **Send & Recv**
```c
if (nrank == 0) {
  MPI_Isend(a, BUF_SIZE, MPI_DOUBLE, 1, 17, MPI_COMM_WORLD);
  MPI_Irecv(b, BUF_SIZE, MPI_DOUBLE, 1, 19, MPI_COMM_WORLD, &status);
}
else if (nrank == 1) {
  MPI_Isend(a, BUF_SIZE, MPI_DOUBLE, 0, 19, MPI_COMM_WORLD);
  MPI_Irecv(b, BUF_SIZE, MPI_DOUBLE, 0, 17, MPI_COMM_WORLD, &status);
}
```
- **Isend & Irecv**
```c
if (nrank == 0) {
  MPI_Isend(a, BUF_SIZE, MPI_DOUBLE, 1, 17, MPI_COMM_WORLD);
  MPI_Irecv(b, BUF_SIZE, MPI_DOUBLE, 1, 19, MPI_COMM_WORLD, &status);
}
else if (nrank == 1) {
  MPI_Isend(a, BUF_SIZE, MPI_DOUBLE, 0, 19, MPI_COMM_WORLD);
  MPI_Irecv(b, BUF_SIZE, MPI_DOUBLE, 0, 17, MPI_COMM_WORLD, &status);
}
```

