# Alltoall

```c
#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[])
{
  int isend[3], irecv[3];
  int i,nprocs, myrank;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD,&nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  for(i=0;i<nprocs;i++){
    isend[i]=1+i+nprocs*myrank;
  }
  printf("Before ");
  printf("%s(%d) : %d %d %d\n","myrank",myrank,
         isend[0],isend[1],isend[2]);
  MPI_Alltoall(isend,1,MPI_INT, irecv,1,MPI_INT,MPI_COMM_WORLD);
  printf("%s(%d) : %d %d %d\n","myrank",myrank,
         irecv[0],irecv[1],irecv[2]);
  MPI_Finalize();
  return 0;
}
```
```bash
Before myrank(0) : 1 2 3
Before myrank(2) : 7 8 9
Before myrank(1) : 4 5 6
myrank(1) : 2 5 8
myrank(0) : 1 4 7
myrank(2) : 3 6 9
```

# Alltoallv

```c
#include <mpi.h>
#include <stdio.h>
int main(int argc, char *argv[])
{
  int isend[6]={1,2,2,3,3,3}, irecv[9]={0};
  int iscnt[3]={1,2,3}, isdsp[3]={0,1,3}, ircnt[3],irdsp[3];
  int myrank,nprocs,i;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  for(i=1;i<=6;i++)
    isend[i-1]=nprocs*myrank+isend[i-1];
  if(myrank==0){
    ircnt[0]=1, ircnt[1]=1, ircnt[2]=1;
    irdsp[0]=0, irdsp[1]=1, irdsp[2]=2;
  }else if(myrank==1){
    ircnt[0]=2, ircnt[1]=2, ircnt[2]=2;
    irdsp[0]=0, irdsp[1]=2, irdsp[2]=4;
  }else if(myrank==2){
    ircnt[0]=3, ircnt[1]=3, ircnt[3]=3;
    irdsp[0]=0, irdsp[1]=3, irdsp[2]=6;
  }
  MPI_Alltoallv(isend, iscnt, isdsp, MPI_INT,
                irecv, ircnt, irdsp, MPI_INT,
                MPI_COMM_WORLD);
  printf("%s(%d) : %d, %d, %d, %d, %d, %d, %d, %d, %d\n","myrank",myrank,
         isend[0],isend[1],isend[2],isend[3],isend[4],isend[5], isend[6], isend[7],isend[8]);
  printf("%s(%d) : %d, %d, %d, %d, %d, %d, %d, %d, %d\n","myrank",myrank,
         irecv[0],irecv[1],irecv[2],irecv[3],irecv[4],irecv[5], irecv[6], irecv[7],irecv[8]);
  MPI_Finalize();
  return 0;
}
```
```bash
$ mpicc -np 3 ./a.out
myrank(0) : 1, 2, 2, 3, 3, 3, 0, 7, 669105088
myrank(0) : 1, 4, 7, 0, 0, 0, 0, 0, 0
myrank(1) : 4, 5, 5, 6, 6, 6, 0, 7, 669105088
myrank(1) : 2, 2, 5, 5, 8, 8, 0, 0, 0
myrank(2) : 7, 8, 8, 9, 9, 9, 0, 7, 669105088
myrank(2) : 3, 3, 3, 6, 6, 6, 9, 9, 9

```
