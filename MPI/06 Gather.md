# Gather

```c
#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[])
{
  int i, nprocs, nrank;
  int isend, irecv[4];

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &nrank);

  isend = nrank + 1;
  printf("rank (%d) : isend = %d ", nrank, isend);

  MPI_Gather(&isend, 1, MPI_INT, irecv, 1, MPI_INT, 0, MPI_COMM_WORLD);

  if (nrank == 0) {
    printf("\n");
    for (i=0; i<3; i++)
      printf("rank (%d) : irecv[%d] = %d\n",
             nrank, i, irecv[i]);
  }
  printf("\n");
  MPI_Finalize();

  return 0;
}
```

```bash
$ mpicc -np 3 ./a.out
rank (2) : isend = 3
rank (1) : isend = 2
rank (0) : isend = 1
rank (0) : irecv[0] = 1
rank (0) : irecv[1] = 2
rank (0) : irecv[2] = 3
```

# Gatherv

```c
#include <mpi.h>
#include <stdio.h>
int main (int argc, char *argv[]){
  int i, myrank ;
  int isend[3], irecv[6];
  int iscnt, ircnt[3]={1,2,3}, idisp[3]={0,1,3};
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  for(i=0; i<myrank+1; i++) isend[i] = myrank + 1;
  iscnt = myrank +1;
  MPI_Gatherv(isend, iscnt, MPI_INT, irecv, ircnt, idisp,
              MPI_INT, 0, MPI_COMM_WORLD);
  if(myrank == 0) {
      printf(" irecv = "); for(i=0; i<6; i++) printf(" %d", irecv[i]);
      printf("\n");
  }
  MPI_Finalize();
  return 0;
}
```
```bash
$ mpicc -np 3 ./a.out
 irecv =  1 2 2 3 3 3
 ```
