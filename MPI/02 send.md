# Send & Recv
`MPI_Send`와 `MPI_Recv`는 **blocking**통신 방식이다. 즉, 작업이 끝나야 값이 **return**된다.
```c
#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[]) {
  int rank, i, count;
  float data[100],value[200];
  MPI_Status status;
  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  if(rank==1) {
    for(i=0;i<100;++i) data[i]=i;
    MPI_Send(data,100,MPI_FLOAT,0,55,MPI_COMM_WORLD);
  }
  else {
    MPI_Recv(value,200,MPI_FLOAT,MPI_ANY_SOURCE,55,MPI_COMM_WORLD,&status);
    printf("P:%d Got data from processor %d \n",rank, status.MPI_SOURCE);
    MPI_Get_count(&status,MPI_FLOAT,&count);
    printf("P:%d Got %d elements \n",rank,count);
      printf("P:%d value[5]=%f \n",rank,value[5]);
  }
  MPI_Finalize();
  return 0;
}
```
```bash
$ mpirun -np 2 ./a.out
P:0 Got data from processor 1
P:0 Got 100 elements
P:0 value[5]=5.000000
```
