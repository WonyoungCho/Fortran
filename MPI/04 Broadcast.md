# Broadcast

```c
#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[])
{
  int i, nrank, nprocs, ROOT = 0;
  int buf[4] = { 0, 0, 0, 0 };

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &nrank);

  if (nrank == ROOT) {
    buf[0] = 5; buf[1] = 6; buf[2] = 7; buf[3] = 8;
  }

  printf("rank (%d) :   Before :  ", nrank);
  for (i=0; i<4; i++)   printf(" %d", buf[i]);
  printf("\n");

  MPI_Bcast(buf, 4, MPI_INT, ROOT, MPI_COMM_WORLD);

  printf("rank (%d) :   After  :  ", nrank);
  for (i=0; i<4; i++)   printf(" %d", buf[i]);
  printf("\n");

  MPI_Finalize();
  return 0;
}
```
```bash
$ mpicc -np 4 ./a.out
rank (2) :      Before :   0 0 0 0
rank (2) :      After  :   5 6 7 8
rank (0) :      Before :   5 6 7 8
rank (0) :      After  :   5 6 7 8
rank (1) :      Before :   0 0 0 0
rank (1) :      After  :   5 6 7 8
rank (3) :      Before :   0 0 0 0
rank (3) :      After  :   5 6 7 8
```
